/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  theme: {
    fontFamily: {
      sans: [
        'PingFang TC',
        'Roboto',
        'ui-sans-serif',
        'system-ui',
        'sans-serif',
        'Apple Color Emoji',
        'Segoe UI Emoji',
        'Segoe UI Symbol',
        'Noto Color Emoji'
      ]
    },
    extend: {
      fontSize: {
        h1: '1.75rem'
      },
      colors: {
        primary: {
          50: '#edf8fa',
          100: '#dbf1f5',
          200: '#b4e2ea',
          300: '#93d4df',
          400: '#71c5d5',
          500: '#2eb6c7',
          600: '#468d9b',
          700: '#356c77',
          800: '#22474e',
          900: '#112629',
          950: '#081315'
        },
        secondary: {
          50: '#fdf8ed',
          100: '#fcf2df',
          200: '#f8e3bc',
          300: '#f4d69e',
          400: '#edbb60',
          500: '#f5ba4b',
          600: '#e7a43c',
          700: '#b07d2c',
          800: '#74521b',
          900: '#3c2b0b',
          950: '#1c1304'
        },
        grey: {
          50: '#f1f3f4',
          100: '#e3e7e9',
          200: '#cad1d5',
          300: '#adb8be',
          400: '#91a0a8',
          500: '#738995',
          600: '#5e6d76',
          700: '#475259',
          800: '#30383d',
          900: '#171b1d',
          950: '#080d0e'
        },
        main: {
          50: '#eef7f9',
          100: '#def0f3',
          200: '#bde1e7',
          300: '#8ccad6',
          400: '#5ab3c4',
          500: '#51a1b0',
          600: '#488f9d',
          700: '#366b76',
          800: '#2d5a62',
          900: '#24484e'
        },
        mid: {
          50: '#ffffff',
          100: '#f5f5f5',
          200: '#f0f0f0',
          300: '#dddddd',
          400: '#959595',
          500: '#434343'
        },
        mango: '#eac600',
        banana: '#f5ba4b',
        grape: '#5e73b4',
        orange: {
          50: '#FDF3EC',
          100: '#FBE7D9',
          200: '#F7CFB2',
          300: '#F4B992',
          400: '#F1A26D',
          500: '#FD853A',
          600: '#E6692C',
          700: '#AE501F',
          800: '#713311',
          900: '#391A06',
          950: '#1C0C02'
        },
        warn: {
          100: '#ea686f',
          200: '#e5464b'
        },
        success: '#6a0'
      }
    }
  },
  plugins: []
};
