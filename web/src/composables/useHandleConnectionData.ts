import { onUnmounted } from 'vue';

/**
 *
 * @param cb - 針對 app 傳送回來的資料透過 callback 做處理，cb 只接收一個參數 event，app 的回傳資料會以 string 形式存在 event.data 中
 *
 * <strong>重要提醒：</strong>建議都在 /views 呼叫此 hook，每一個 view 只呼叫一次，該頁面所需的 app 資料都在屬於頁面的 view 處理，不要在 /components 層呼叫，以免不好管理，也避免監聽器重複創建造成非預期錯誤。
 */
export const useHandleConnectionData = (cb?: (event: { data: string }) => void) => {
  // @ts-ignore
  if (typeof flutterObject !== 'undefined' && flutterObject) {
    if (cb) {
      // @ts-ignore
      flutterObject.addEventListener('message', cb);

      onUnmounted(() => {
        // @ts-ignore
        flutterObject.removeEventListener('message', cb);
      });
    }
  }
};
