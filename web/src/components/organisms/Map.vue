<template>
  <div ref="mapContainer" class="map-container"></div>
</template>

<script>
import { useHandleConnectionData } from '../../composables/useHandleConnectionData';
import { useConnectionMessage } from '../../composables/useConnectionMessage';
import calcCrow from '@/utils/calcCrow';
import mapboxgl from 'mapbox-gl';
import axios from 'axios';

let thisI;
let map;
let userCoord = [121.5624999, 25.0325917];
const markers = [];

mapboxgl.accessToken =
  'pk.eyJ1IjoiZjc0MTE0NzYwIiwiYSI6ImNtMHJyenV3eTBjOGQyaXNicDFsbXU2YzIifQ.fhoguJDc6TfWAGwn471Hog';
export default {
  emits: ['point-click'],
  props: ['destPos'],
  watch: {
    destPos: {
      handler: function (val) {
        if (!val) return;
        console.log('destPos:', val);
        clearAllLayer();
        makeMarker('', '#26a7ac', 25, [val.lng, val.lat], 1, null);
        zoomToFeat([userCoord, [val.lng, val.lat]]);
      },
      deep: true,
      immediate: true
    }
  },
  mounted() {
    thisI = this;
    map = this.map = new mapboxgl.Map({
      container: this.$refs.mapContainer,
      style: 'mapbox://styles/mapbox/light-v11', // Replace with your preferred map style
      center: [121.5624999, 25.0325917],
      zoom: 15
    });

    map.on('dragend', (e) => {
      console.log('move end:', e);
      getParkingData();
    });

    map.on('click', 'yellowLine', function (e) {
      // alert('click yellow line');
      thisI.$emit('point-click', {
        name: 'Yellow Line',
        lat: e.lngLat.lat,
        lng: e.lngLat.lng,
        remainingSpace: 1,
        price: '',
        distance: calcCrow(e.lngLat.lat, e.lngLat.lng, userCoord[1], userCoord[0]),
        type: 'yellow_line'
      });
    });

    let getCurrentPosCallback = null;
    let watchPositionId = 0;
    const watchPositionListeners = {};

    map.addControl(
      new mapboxgl.GeolocateControl({
        geolocation: { getCurrentPosition, watchPosition, clearWatch },
        trackUserLocation: true
      })
    );

    function getCurrentPosition(success, error, options) {
      console.log('Get location');
      getCurrentPosCallback = success;
      useConnectionMessage('location', null);
    }

    function watchPosition(success, error, options) {
      // new mapboxgl.Popup({ closeOnClick: false })
      //   .setLngLat(map.getCenter())
      //   .setHTML('<h1>' + 'stratWatch' + '</h1>')
      //   .addTo(map);

      const id = ++watchPositionId;
      const interval = setInterval(() => {
        useConnectionMessage('location', null);
      }, 4000);
      useConnectionMessage('location', null);
      watchPositionListeners[id] = { success, interval };
      return id;
    }

    function clearWatch(id) {
      // new mapboxgl.Popup({ closeOnClick: false })
      //   .setLngLat(map.getCenter())
      //   .setHTML('<h1>' + 'clearWatch' + '</h1>')
      //   .addTo(map);
      const listener = watchPositionListeners[id];
      clearInterval(listener.interval);
      delete watchPositionListeners[id];
    }

    useHandleConnectionData((i) => {
      i = JSON.parse(i.data);
      const name = i.name;
      const data = i.data;
      const geoPos = { coords: data };

      userCoord = [data.longitude, data.latitude];
      if (getCurrentPosCallback) {
        getCurrentPosCallback(geoPos);
        getCurrentPosCallback = null;
      }
      Object.values(watchPositionListeners).forEach((i) => i.success(geoPos));
    });

    let updating = false;

    getParkingData();

    async function getParkingData() {
      if (updating) return;
      updating = true;

      let center = map.getCenter();
      let lon = center.lng,
        lat = center.lat;
      let d0 = axios.get(`https://api.wavjaby.nckuctf.org:25569?lon=${lon}&lat=${lat}`);
      let d1 = axios.get(`https://api.wavjaby.nckuctf.org:25569/get_line?lon=${lon}&lat=${lat}`);

      d0 = await (await d0).data;
      d1 = await (await d1).data;
      updating = false;

      markers.forEach((i) => i.remove());

      console.log(d0);
      addPoints(
        'parkingLot',
        d0.parkingLot.map((i) => ({
          type: 'Feature',
          properties: {
            color: '#ff0000'
          },
          geometry: {
            type: 'Point',
            coordinates: [i.lon, i.lat]
          }
        })),
        1,
        3
      );
      addPolygon(
        'parkingGrid',
        d0.parkingGrid.map((i) => ({
          type: 'Feature',
          properties: {
            color: i.available ? '#ccff33' : '#e07a5f'
          },
          geometry: {
            type: 'Polygon',
            coordinates: [i.wkt]
          }
        })),
        1
      );
      // add markers to map
      d0.parkingGrid.forEach(
        (i) => i.available && makeMarker('1', '#26a7ac', 25, [i.lon, i.lat], 1, i)
      );
      d0.parkingLot
        .sort((a, b) => a.carRemainderNum - b.carRemainderNum)
        .forEach((i) =>
          makeMarker(
            Math.max(0,i.carRemainderNum),
            i.carRemainderNum > 0 ? '#693' : '#f20',
            i.carRemainderNum === 0 ? 20 : Math.min(50 * (i.carRemainderNum / 1000) + 25, 60),
            [i.lon, i.lat],
            i.carRemainderNum,
            i
          )
        );
      console.log(d1);
      let featuresPath = d1.map((i) => ({
        type: 'Feature',
        properties: {
          color: '#f0cf65'
        },
        geometry: {
          type: 'LineString',
          coordinates: i.coordinates
        }
      }));
      addSourceAndLayer('yellowLine', featuresPath, {
        type: 'line',
        layout: {
          'line-join': 'round',
          'line-cap': 'round'
        },
        paint: {
          'line-color': ['get', 'color'],
          'line-width': 4
        }
      });
    }
  },
  unmounted() {
    this.map.remove();
    this.map = null;
  }
};

function clearAllLayer() {
  removeSourceAndLayer('parkingLot');
  removeSourceAndLayer('parkingGrid');
  removeSourceAndLayer('yellowLine');
  markers.forEach((i) => i.remove());
}

function zoomToFeat(coordinates) {
  // based on this: https://www.mapbox.com/mapbox-gl-js/example/zoomto-linestring/

  // Pass the first coordinates in the LineString to `lngLatBounds` &
  // wrap each coordinate pair in `extend` to include them in the bounds
  // result. A variation of this technique could be applied to zooming
  // to the bounds of multiple Points or Polygon geomteries - it just
  // requires wrapping all the coordinates with the extend method.
  var bounds = coordinates.reduce(
    function (bounds, coord) {
      return bounds.extend(coord);
    },
    new mapboxgl.LngLatBounds(coordinates[0], coordinates[0])
  );

  map.fitBounds(bounds, {
    padding: 100
  });
}

function makeMarker(text, color, size, cord, remaining, info) {
  let el = document.createElement('div');
  el.className = 'marker';
  // Set text and size
  let sp = document.createElement('span');
  sp.innerHTML = '<b>' + text + '</b>';
  sp.style.background = color;
  sp.style.width = sp.style.height = size + 'px';
  el.append(sp);

  const marker = new mapboxgl.Marker(el).setLngLat(cord).addTo(map);
  if(info)
  marker.getElement().addEventListener('click', () => {
    thisI.$emit('point-click', {
      name: info.parkName,
      lat: info.lat,
      lng: info.lon,
      remainingSpace: remaining,
      price: info.payex,
      // distance: userCoord?calcCrow(info.lat, info.lon, userCoord[1], userCoord[0]):'--',
      distance: calcCrow(info.lat, info.lon, userCoord[1], userCoord[0]),
      type: 'park'
    });
  });
  markers.push(marker);
  return marker;
}

function removeSourceAndLayer(id) {
  const srcId = id + '_src';
  if (map.getLayer(id)) map.removeLayer(id);
  if (map.getSource(srcId)) map.removeSource(srcId);
}

function addSourceAndLayer(id, features, layerConfig) {
  const srcId = id + '_src';
  if (map.getLayer(id)) map.removeLayer(id);
  if (map.getSource(srcId)) map.removeSource(srcId);
  map.addSource(srcId, {
    type: 'geojson',
    data: { type: 'FeatureCollection', features: features }
  });
  layerConfig.id = id;
  layerConfig.source = srcId;
  map.addLayer(layerConfig);
}

function addPoints(id, features, opacity, radius) {
  addSourceAndLayer(id, features, {
    type: 'circle',
    layout: {},
    paint: {
      'circle-opacity': opacity,
      'circle-color': ['get', 'color'],
      'circle-radius': radius
    }
  });
}

function addPolygon(id, features, opacity) {
  addSourceAndLayer(id, features, {
    type: 'fill',
    layout: {},
    paint: {
      'fill-opacity': opacity,
      'fill-color': ['get', 'color']
    }
  });
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
