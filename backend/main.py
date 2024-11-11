from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import json
import requests
import uvicorn
import os
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from geospatialsearch import GeoSpatialSearch
load_dotenv()
geo_search = GeoSpatialSearch()

app = FastAPI()
origins = [
    "http://localhost",
    "http://localhost:5173",
    "https://localhost:5173",
    "https://vaclis-taipei-town.web.app",
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)



@app.get("/")
def read_root(lon: float, lat: float):
    print(lon, lat)
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    response = requests.post(
        "https://itaipeiparking.pma.gov.taipei/MapAPI/GetAllPOIData",
        data={"lon": lon, "lat": lat, "catagory": "car", "type": 1},
        headers=headers,
    )
    data = response.json()
    parkingLot = []
    parkingGrid = []
    for i in data:
        if i["wkt"] is None:
            parkingLot.append(
                {
                    "parkId": i["parkId"],
                    "parkName": i["parkName"],
                    "lon": i["lon"],
                    "lat": i["lat"],
                    "carTotalNum": i["carTotalNum"],
                    "carRemainderNum": i["carRemainderNum"],
                    "payex": i["payex"],
                    "chargeStationTotalNum": i["chargeStationTotalNum"],
                    # "entrance": json.loads(i["entrance"]) if i["entrance"] is not None else None,
                }
            )
        else:
            if i["remark"] != "目前空格" and i["remark"] != "目前有車停放":
                print(i["remark"])
            parkingGrid.append(
                {
                    "parkId": i["parkId"],
                    "parkName": i["parkName"],
                    "lon": i["lon"],
                    "lat": i["lat"],
                    "available": i["remark"] == "目前空格",
                    "payex": i["payex"],
                    "chargeStationTotalNum": i["chargeStationTotalNum"],
                    # "entrance": json.loads(i["entrance"]) if i["entrance"] is not None else None,
                    "wkt": list(map(strToCord, i["wkt"][10:-2].split(", "))),
                }
            )
    return {"parkingLot": parkingLot, "parkingGrid": parkingGrid}

def strToCord(string):
    string = string.split(" ")
    return (float(string[0]),float(string[1]))


@app.get("/get_line")
def get_line(lon: float, lat: float):
    """
    Search for lines within a 1 km radius of the given coordinates
    """
    try:
        # Call the GeoSpatialSearch method to find nearby lines
        results = geo_search.find_nearby_lines(lat, lon, search_radius_km=1.0)

        # If no lines are found, return 204 No Content
        if not results:
            return JSONResponse(
                status_code=204,
                content={"status": "No Content", "data": []}
            )

        # Return the successful result with status code 200 OK
        return JSONResponse(
            status_code=200,
            content={"status": "success", "data": results}
        )

    except Exception as e:
        # Handle any potential errors
        raise HTTPException(status_code=500, detail=str(e))



if __name__ == "__main__":
    ssl_keyfile=os.getenv("SSL_KEYFILE")
    ssl_certfile=os.getenv("SSL_CERTFILE")
    ssl_password=os.getenv("SSL_PASSWORD")
    uvicorn.run(app, host="localhost", port=25569, ssl_keyfile=ssl_keyfile, ssl_certfile=ssl_certfile, ssl_keyfile_password=ssl_password)
