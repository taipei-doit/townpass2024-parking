# ParkFlow - TownPass Services（找車位——台北通微服務）

ParkFlow is a web-based application built with Vue3 and Vite, designed to make parking in Taipei more efficient and user-friendly by providing real-time parking information and assistance.

This project was developed during a 24-hour non-stop Taipei Hackathon, where we were selected as one of the top 12 teams out of 55 entries. We proudly secured third place, winning a prize of NT$100,000.

![ParkFlow Preview](https://raw.githubusercontent.com/vaclisinc/vaclis-TownPass-Services/24ec17c43d856ad05349fb072df98daaa7e2178c/parkflow_preview.jpg)

## Features
1. ***Real-time Data Pipeline***
   Integrates with external sources such as the Taipei parking API to deliver up-to-date parking availability for different parking grids in Taipei.

2. ***Parking Area Notifications***:
   Notifies users about parking duration and fees to help avoid penalties, ensuring they remain informed throughout their parking period.

3. ***Yellow Line Service***:
   Assists users with parking near yellow lines, adapting to traffic conditions. Provides a 3-minute buffer alert during peak hours and offers guidance on maximizing yellow line parking during off-peak hours where permitted.

## Demo 

For a behind-the-scenes look at our journey, including the development process, final presentation, and award ceremony, check out our [YouTube vlog](https://www.youtube.com/watch?v=ZP9nikrbwak&t=15s).


## Technologies Stack
- Vue 3: Front-end framework for building user interfaces.
- Vite: Fast development server and build tool for modern web projects.
- Flutter: Enables bi-directional communication between the web application and mobile devices for notifications and GPS functionality.
- Mapbox: Provides interactive maps and location services to help users find parking spots and navigate to them easily.
- Real-time Data APIs: Integration with Taipei parking API and other external data sources to provide current parking information.
- Notifications & GPS: Supports two-way communication with Flutter for sending notifications and receiving GPS data, ensuring a seamless user experience across web and mobile platforms.



## Getting Started
### Recommended IDE Setup

- [VSCode](https://code.visualstudio.com/)
- [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar) (and disable Vetur).

### Project Setup

Install the required dependencies:
```sh
pnpm install
```

### Compile and Hot-Reload for Development

Compile and start the development server:
```sh
pnpm dev
```

### Production

Type-check, compile, and minify the code for production:
```sh
pnpm build
```

### Linting

Lint the code using [ESLint](https://eslint.org/):

```sh
pnpm lint
```

## Team Members
- [@vaclisinc](https://www.github.com/vaclisinc)
- [@SimonLiu423](https://www.github.com/SimonLiu423)
- [@nyraa](https://github.com/nyraa)
- [@WavJaby](https://www.github.com/WavJaby)
- [@Andrewtangtang](https://www.github.com/Andrewtangtang)

<br>

---


Developed with ❤️ by 游松澤 (Yu Song-Ze), 張羿軒 (Zhang Yi-Xuan), 劉力瑋 (Liu Li-Wei), 楊乃昀（Yang Nai-Yun） ,張昀棠 (Zhang Yun-Tang)

Project Team: 嘻嘻的時候，黑客松松澤
