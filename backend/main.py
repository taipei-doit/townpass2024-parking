from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import json
import requests
import uvicorn
import os
from dotenv import load_dotenv
from geopy.distance import geodesic
load_dotenv()

app = FastAPI()
with open('yellow_line.json', 'r', encoding='utf-8') as f:
    yellow_line_data = json.load(f)
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
def get_line(lon:float, lat:float):
    target_coord = (lat,lon)
    nearby_coordinates = []
    for item in yellow_line_data:
        for coord in yellow_line_data[item]['coordinates']:
            lon, lat = coord
            distance = geodesic(target_coord, (lat, lon)).kilometers
            if distance < 1:
                nearby_coordinates.append(yellow_line_data[item])

    return nearby_coordinates


if __name__ == "__main__":
    ssl_keyfile=os.getenv("SSL_KEYFILE")
    ssl_certfile=os.getenv("SSL_CERTFILE")
    ssl_password=os.getenv("SSL_PASSWORD")
    uvicorn.run(app, host="0.0.0.0", port=25569, ssl_keyfile=ssl_keyfile, ssl_certfile=ssl_certfile, ssl_keyfile_password=ssl_password)
