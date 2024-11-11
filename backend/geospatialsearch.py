import geopandas as gpd
from shapely.geometry import Point, LineString, MultiLineString
from shapely.strtree import STRtree


class GeoSpatialSearch:
    def __init__(self):
        """
        Initialize the GeoSpatialSearch class
        Read the shapefile and create a GeoDataFrame
        Create an STRtree spatial index
        """
        # Read the shapefile and build the GeoDataFrame
        self.gdf = gpd.read_file("raw_data_from_platform\\noparkin_202407121525.shp")

        # Check the CRS and ensure it is WGS 84 (EPSG:4326)
        if self.gdf.crs != "EPSG:4326":
            self.gdf = self.gdf.to_crs("EPSG:4326")

        # Round the coordinates to 6 decimal places
        self.gdf['geometry'] = self.gdf['geometry'].apply(self.round_coordinates)

        # Create an STRtree spatial index
        self.tree = STRtree(self.gdf['geometry'])

    def round_coordinates(self, geometry):
        """
        INPUT:
            geometry: shapely.geometry, a geometry object
        OUTPUT:
            geometry: shapely.geometry, a geometry object with rounded coordinates
        """
        if geometry is None:
            return None

        if isinstance(geometry, LineString):
            rounded_coords = [(round(x, 6), round(y, 6)) for x, y in geometry.coords]
            return LineString(rounded_coords)
        elif isinstance(geometry, MultiLineString):
            rounded_lines = [
                LineString([(round(x, 6), round(y, 6)) for x, y in line.coords])
                for line in geometry.geoms
            ]
            return MultiLineString(rounded_lines)
        else:
            return geometry

    def find_nearby_lines(self, latitude, longitude, search_radius_km=1.0):
        """
        INPUT:
            latitude: float, latitude of the point
            longitude: float, longitude of the point
            search_radius_km: float, search radius in kilometers
        OUTPUT:
            result_list: list of dict, list of line segments within the search radius
        ACTION:
            Find the line segments within the search radius of the point
        """
        point = Point(longitude, latitude)
        search_radius_deg = search_radius_km / 111

        # Query the STRtree index
        indices = self.tree.query(point.buffer(search_radius_deg))

        # Filter the line segments truly within the search radius
        result_list = []
        for idx in indices:
            geom = self.gdf.iloc[idx].geometry
            if geom.distance(point) <= search_radius_deg:
                row = self.gdf.iloc[idx]
                coordinates = list(geom.coords) if geom.geom_type == 'LineString' else [list(line.coords) for line in geom.geoms]
                result_list.append({
                    "coord": coordinates,
                    "t": int(row['patype']) if row['patype'] is not None else 2
                })
        return result_list


if __name__ == "__main__":
    geo_search = GeoSpatialSearch()

    # Find line segments within a 1 km radius of the specified coordinates
    results = geo_search.find_nearby_lines(25.081580, 121.606869, search_radius_km=1.0)
    print(results)
