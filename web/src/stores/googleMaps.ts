import { reactive, ref } from 'vue';
import { defineStore } from 'pinia';
import { Loader } from '@googlemaps/js-api-loader';

export const useGoogleMapsStore = defineStore('googleMaps', () => {
  const loader = new Loader({
    // 替換成您的 API KEY
    apiKey: '',
    version: 'weekly',
    libraries: ['places', 'geometry']
  });

  /**
   * 是否顯示未開啟取用位置權限通知
   */
  const showMapNotification = ref(false);

  /**
   * 獲取目前位置
   */
  const gettingPosition = () => {
    if (navigator.geolocation) {
      return new Promise((resolve, reject) => {
        const option = {
          enableAcuracy: false, // 提高精確度
          maximumAge: 0, // 設定上一次位置資訊的有效期限(毫秒)
          timeout: 10000 // 逾時計時器(毫秒)
        };
        navigator.geolocation.getCurrentPosition(resolve, reject, option);
      });
    } else {
      alert('Does not support positioning!');
    }
  };

  return {
    loader,
    showMapNotification,
    gettingPosition
  };
});
