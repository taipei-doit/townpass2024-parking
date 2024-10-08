# ParkFlow - TownPass Services（找車位——台北通微服務）

![ParkFlow Preview](https://raw.githubusercontent.com/vaclisinc/vaclis-TownPass-Services/24ec17c43d856ad05349fb072df98daaa7e2178c/parkflow_preview.jpg)

## Important Notes
### Frontend:
- We use mapbox API which can directly put in _____.
- We design a temporary logo from picture online which are uploaded to the index of this repo.
![ParkFlow Preview](https://raw.githubusercontent.com/vaclisinc/vaclis-TownPass/3bb54814c2583cefa2d54191647f1b5304eef8fe/assets/image/ParkFlow_.png)

### Backend:
- 停車位的即時資訊，目前是去抓[北市好停車](https://itaipeiparking.pma.gov.taipei/)的api，但臺北市政府應該有提供，可能需要請資訊局的人幫我們申請，網路上看應該是[這個網站](https://www.dot.gov.taipei/cp.aspx?n=B99327E88E732290)。
- 紅黃線的位置資訊目前放上去的yellow_line.json檔是從 [台北公開資料大平台](https://data.taipei/dataset/detail?id=a9c282c5-3a43-41ed-badc-f9c1bdf1cc34) 下載下來進行處理，完整處理過程與code
會之後完成後一併上傳