<template>
  <div ref="mapContainer" class="map-container"></div>
</template>

<script lang="ts">
import {useHandleConnectionData} from '@/composables/useHandleConnectionData';
import {useConnectionMessage} from '@/composables/useConnectionMessage';
import calcCrow from '@/utils/calcCrow';
import {Marker, Map, GeoJSONSource} from 'mapbox-gl';
import mapboxgl from 'mapbox-gl';
import axios from 'axios';

type Coordinate = { lat: number, lng: number }

/**
 * [longitude, latitude]
 */
type CoordinateArr = [number, number];

type ParkingLotData = {
  carRemainderNum: number,
  carTotalNum: number,
  chargeStationTotalNum: number,
  lat: number,
  lon: number,
  parkName: string,
  payex: string
}

type StreetParkingGridData = {
  lat: number,
  lon: number,
  available: boolean,
  wkt: Coordinate[],
}

type StreetLineData = {
  coord: Coordinate[]
  t: 1 | 2 | 3,
}

type MapElementData = {
  map?: any,
  markers: any[],
  userCoord: CoordinateArr,
  parkingLotData?: ParkingLotData[],
  parkingGridData?: StreetParkingGridData[],
  lineData?: StreetLineData[]
}

mapboxgl.accessToken = import.meta.env.VITE_MAPBOX_API_KEY;
export default {
  emits: ['point-click'],
  props: ['destPos'],
  watch: {
    destPos: {
      handler: function (val) {
        if (val === null) {
          this.displayMapParkingInfo();
          return;
        }
        console.log('destPos:', val);
        this.clearMapParkingInfo();
        this.makeMarker('', '#26a7ac', 25, [val.lng, val.lat], 1, null);
        this.zoomToFeat([this.userCoord, [val.lng, val.lat]]);
      },
      deep: true,
      immediate: true
    }
  },
  data: (): MapElementData => ({
    markers: [],
    userCoord: [121.5624999, 25.0325917]
  }),
  mounted() {
    const map = new Map({
      container: this.$refs.mapContainer as HTMLElement,
      style: 'mapbox://styles/mapbox/light-v11', // Replace with your preferred map style
      center: [121.5624999, 25.0325917],
      zoom: 15
    });
    this.map = map;
    map.on('dragend', () => this.updateParkingData().then(this.displayMapParkingInfo));

    map.on('click', 'roadLine', (e) => {
      // alert('click yellow line');
      const features = map.queryRenderedFeatures(e.point, {
        layers: ['roadLine']
      });
      const type = features[0].properties?.type;
      this.$emit('point-click', {
        name: type === 1 ? '紅線' : type === 2 ? '黃線' : '其他',
        lat: e.lngLat.lat,
        lng: e.lngLat.lng,
        remainingSpace: 1,
        price: '',
        distance: calcCrow(e.lngLat.lat, e.lngLat.lng, this.userCoord[1], this.userCoord[0]),
        type: 'yellow_line'
      });
    });

    const navigateParkingGrid = (info: CoordinateArr, remaining: number) => {
      console.log(info)
      this.$emit('point-click', {
        name: '停車格',
        lat: info[1],
        lng: info[0],
        remainingSpace: remaining,
        price: 'PRICE',
        distance: calcCrow(info[1], info[0], this.userCoord[1], this.userCoord[0]),
        type: 'park'
      });
    }

    map.on('click', 'parkingGridPoint', (e) => {
      const features = map.queryRenderedFeatures(e.point, {
        layers: ['parkingGridPoint']
      });
      if (!features || !features[0])
        return;
      const clusterProp = features[0].properties;
      const clusterId = clusterProp?.cluster_id;
      (map.getSource('parkingGridPoint_src') as GeoJSONSource)
          .getClusterExpansionZoom(clusterId, (error: any, zoom: number) => {
            if (error) return;
            if (zoom > 16) {
              console.log(features[0].properties)
              navigateParkingGrid(features[0].geometry.coordinates, clusterProp?.point_count);
              return;
            }

            map.easeTo({
              center: features[0].geometry.coordinates,
              zoom: zoom
            });
          });
    });

    map.on('click', 'parkingGridPointSingle', (e) => {
      navigateParkingGrid([e.lngLat.lng, e.lngLat.lat], 1);
    });

    let mapBoxCurrentPosCallback: null | PositionCallback;
    const watchPositionListeners: { [key: number]: PositionCallback } = {};

    // Implement location tracker for mapbox
    map.addControl(
        new mapboxgl.GeolocateControl({
          geolocation: {getCurrentPosition, watchPosition, clearWatch},
          trackUserLocation: true
        })
    );

    function getCurrentPosition(success: PositionCallback, error?: PositionErrorCallback, options?: PositionOptions) {
      console.log('Get location');
      mapBoxCurrentPosCallback = success;
      useConnectionMessage('location', null);
    }

    function watchPosition(success: PositionCallback, error?: PositionErrorCallback, options?: PositionOptions) {
      // new mapboxgl.Popup({ closeOnClick: false })
      //   .setLngLat(map.getCenter())
      //   .setHTML('<h1>' + 'stratWatch' + '</h1>')
      //   .addTo(map);

      const watchId = setInterval(() => {
        useConnectionMessage('location', null);
      }, 4000);
      useConnectionMessage('location', null);
      watchPositionListeners[watchId] = success;
      return watchId;
    }

    function clearWatch(watchId: number) {
      // new mapboxgl.Popup({ closeOnClick: false })
      //   .setLngLat(map.getCenter())
      //   .setHTML('<h1>' + 'clearWatch' + '</h1>')
      //   .addTo(map);
      clearInterval(watchId);
      delete watchPositionListeners[watchId];
    }

    useHandleConnectionData((i) => {
      const locData = JSON.parse(i.data);
      const name = locData.name;
      const data = locData.data;
      const geoPos: GeolocationPosition = {coords: data, timestamp: new Date().getTime()};

      this.userCoord = [data.longitude, data.latitude];
      if (mapBoxCurrentPosCallback) {
        mapBoxCurrentPosCallback(geoPos);
        mapBoxCurrentPosCallback = null;
      }
      Object.values(watchPositionListeners).forEach((callback) => callback(geoPos));
    });

    // Get current location data
    this.updateParkingData().then(this.displayMapParkingInfo);
  },
  unmounted() {
    this.map!.remove();
    this.map = null;
  },
  methods: {
    makeMarker(text: string, color: string, size: number, cord: CoordinateArr, remaining: number, info: null | ParkingLotData) {
      let el = document.createElement('div');
      el.className = 'marker';
      // Set text and size
      let sp = document.createElement('span');
      sp.innerHTML = '<b>' + text + '</b>';
      sp.style.background = color;
      sp.style.width = sp.style.height = size + 'px';
      el.append(sp);

      const marker = new Marker(el).setLngLat(cord).addTo(this.map!);
      if (info)
        marker.getElement().addEventListener('click', () => {
          this.$emit('point-click', {
            name: info.parkName,
            lat: info.lat,
            lng: info.lon,
            remainingSpace: remaining,
            price: info.payex,
            distance: calcCrow(info.lat, info.lon, this.userCoord[1], this.userCoord[0]),
            type: 'park'
          });
        });
      this.markers.push(marker);
      return marker;
    },
    clearMapParkingInfo() {
      this.removeSourceAndLayer('parkingLot');
      this.removeSourceAndLayer('parkingGrid');
      this.removeLayer('parkingGridPointSingle');
      this.removeLayer('parkingGridPointText');
      this.removeSourceAndLayer('parkingGridPoint');
      this.removeSourceAndLayer('roadLine');
      this.markers.forEach((i) => i.remove());
    },
    async updateParkingData() {
      console.log('Update parking data');
      let center = this.map!.getCenter();
      const {parkData, lineData} = await getParkingData(center);
      this.parkingGridData = parkData.parkingGrid;
      this.parkingLotData = parkData.parkingLot;
      this.lineData = lineData.data;
    },
    displayMapParkingInfo() {
      if (!this.parkingGridData || !this.parkingLotData || !this.lineData)
        return;
      console.log('Display parking data');
      this.markers.forEach((i) => i.remove());

      const parkingGridData = this.parkingGridData.map((i) => ({
        type: 'Feature',
        properties: {
          color: i.available ? '#51bbd6' : '#e07a5f'
        },
        geometry: {
          type: 'Polygon',
          coordinates: [i.wkt]
        }
      }));
      this.addPolygon('parkingGrid', parkingGridData, 1);

      const roadLinePath = this.lineData.map((i) => ({
        type: 'Feature',
        properties: {
          type: i.t,
          color: i.t === 1 ? '#d74b24' : '#f0cf65'
        },
        geometry: {
          type: 'LineString',
          coordinates: i.coord
        }
      }));
      this.addSourceAndLayer('roadLine', 0, 0, roadLinePath, {
        type: 'line',
        layout: {
          'line-join': 'round',
          'line-cap': 'round'
        },
        paint: {
          'line-color': ['get', 'color'],
          'line-width': 5
        }
      });

      // add markers to map
      const availableParkingGridPoint = this.parkingGridData.filter(i => i.available).map((i) => ({
        type: 'Feature',
        properties: {
          point_count: 1
        },
        geometry: {
          type: 'Point',
          coordinates: [i.lon, i.lat]
        }
      }));
      this.removeLayer('parkingGridPointSingle');
      this.removeLayer('parkingGridPointText');
      this.addSourceAndLayer('parkingGridPoint', 50, 20, availableParkingGridPoint, {
        type: 'circle',
        filter: ['>', 'point_count', 1],
        layout: {},
        paint: {
          'circle-color': [
            'step',
            ['get', 'point_count'],
            '#f1f075', 5, '#51bbd6', 15, '#51d65c',
          ],
          'circle-radius': [
            'step',
            ['get', 'point_count'],
            15, 5, 20, 15, 30
          ],
          'circle-opacity': 0.9
        }
      });
      this.addLayer('parkingGridPoint', 'parkingGridPointSingle', {
        type: 'circle',
        filter: ['==', 'point_count', 1],
        paint: {
          'circle-color': '#11b4da',
          'circle-radius': 10,
          'circle-stroke-width': 1,
          'circle-stroke-color': '#fff',
          'circle-opacity': 0.9
        }
      });
      this.addLayer('parkingGridPoint', 'parkingGridPointText', {
        type: 'symbol',
        filter: ['has', 'point_count'],
        layout: {
          'text-field': ['get', 'point_count_abbreviated'],
          'text-size': 16,
        },
        paint: {
          'text-color': '#ffffff',
          'text-halo-color': '#000000',
          'text-halo-width': 0.5
        }
      });

      // this.parkData.parkingGrid.forEach(
      //     (i) => i.available && this.makeMarker('1', '#26a7ac', 25, [i.lon, i.lat], 1, i)
      // );
      this.parkingLotData
          .sort((a, b) => a.carRemainderNum - b.carRemainderNum)
          .forEach((i) => this.makeMarker(
              Math.max(0, i.carRemainderNum).toString(),
              i.carRemainderNum > 0 ? '#693' : '#f20',
              i.carRemainderNum === 0 ? 20 : Math.min(50 * (i.carRemainderNum / 1000) + 25, 60),
              [i.lon, i.lat],
              i.carRemainderNum,
              i
          ));
    },
    zoomToFeat(coordinates: CoordinateArr[]) {
      const bounds = coordinates.reduce(
          function (bounds, coord) {
            return bounds.extend(coord);
          },
          new mapboxgl.LngLatBounds(coordinates[0], coordinates[0])
      );

      this.map!.fitBounds(bounds, {
        padding: 100
      });
    },
    removeSourceAndLayer(id: string) {
      const srcId = id + '_src';
      if (this.map!.getLayer(id)) this.map!.removeLayer(id);
      if (this.map!.getSource(srcId)) this.map!.removeSource(srcId);
    },
    addSourceAndLayer(id: string, clusterRadius: number, clusterMaxZoom: number, features: any, layerConfig: any) {
      const srcId = id + '_src';
      if (this.map!.getLayer(id)) this.map!.removeLayer(id);
      if (this.map!.getSource(srcId)) this.map!.removeSource(srcId);
      this.map!.addSource(srcId, {
        type: 'geojson',
        cluster: clusterRadius != 0,
        clusterRadius: clusterRadius,
        clusterMaxZoom: clusterMaxZoom,
        data: {type: 'FeatureCollection', features: features}
      });
      layerConfig.id = id;
      layerConfig.source = srcId;
      this.map!.addLayer(layerConfig);
    },
    removeLayer(id: string) {
      if (this.map!.getLayer(id))
        this.map!.removeLayer(id);
    },
    addLayer(sourceId: string, id: string, layerConfig: any) {
      const srcId = sourceId + '_src';
      if (this.map!.getLayer(id)) this.map!.removeLayer(id);
      layerConfig.id = id;
      layerConfig.source = srcId;
      this.map!.addLayer(layerConfig);
    },
    addPolygon(id: string, features: any, opacity: number) {
      this.addSourceAndLayer(id, 0, 0, features, {
        type: 'fill',
        layout: {},
        paint: {
          'fill-opacity': opacity,
          'fill-color': ['get', 'color']
        }
      });
    },
  }
};

async function getParkingData(center: Coordinate) {
  const lon = center.lng, lat = center.lat;
  const parkDataFetch = axios.get(`${import.meta.env.VITE_BACKEND_URL}?lon=${lon}&lat=${lat}`);
  const lineDataFetch = axios.get(`${import.meta.env.VITE_BACKEND_URL}/get_line?lon=${lon}&lat=${lat}`);

  const parkData = await (await parkDataFetch).data;
  const lineData = await (await lineDataFetch).data;
  return {parkData, lineData};
}
</script>

<style>
.map-container {
  flex: 1;
}

.marker {
  width: 0;
  height: 0;
  font-size: 16px;
}

.marker > span {
  display: flex;
  justify-content: center;
  align-items: center;
  box-sizing: border-box;
  color: #fff;
  border: solid 1px;
  border-radius: 0 70% 70%;
  box-shadow: 0 0 2px #000;
  cursor: pointer;
  transform-origin: 0 0;
  transform: rotateZ(-135deg);
}

.marker b {
  transform: rotateZ(135deg);
}
</style>
