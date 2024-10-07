/**
 * 使用 flutter_inappwebview 的 Web Message Listeners 跟 app 做資料溝通
 * 目前定義的 connection object name 是 flutterObject
 * 開發者可以自己在城市通定義自己的名稱，定義好後記得要跟微服務同步即可
 * @see https://inappwebview.dev/docs/webview/javascript/communication#web-message-listeners
 */

/**
 * @param name - 傳送給 app 讓 app 知道 web 需要什麼類型的溝通
 * @param data - 需要傳送給 app 的資料
 *
 * <strong>重要提醒：</strong>建議都在 /views 呼叫此 hook，為了方便跟 useHandleConnectionData 管理。
 */
export const useConnectionMessage = <T>(name: string, data: T) => {
  // @ts-ignore
  if (typeof flutterObject !== 'undefined' && flutterObject) {
    const postInfo = JSON.stringify({ name, data });

    // @ts-ignore
    flutterObject.postMessage(postInfo);
  }
};
