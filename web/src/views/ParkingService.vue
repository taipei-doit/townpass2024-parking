<script setup lang="ts">
import Map from '@/components/organisms/Map.vue';
import 'mapbox-gl/dist/mapbox-gl.css';
import NavigatorCard from '@/components/organisms/NavigatorCard.vue';
import { useConnectionMessage } from '@/composables/useConnectionMessage';
import { ref } from 'vue';
import { computed, onMounted } from 'vue';

export type ParkPoint = {
  name: string;
  lat: number;
  lng: number;
  remainingSpace: number;
  price: string;
  distance: number;
  type: 'park' | 'yellow_line';
};

enum NavigatorStep {
  BrowsingMap = 'browsing_map', // 瀏覽地圖，沒有顯示任何卡片
  NavigatorPark = 'navigator_park', // 查看停車場
  NavigatorYellowLine = 'navigator_yellow_line', // 查看黃線
  Navigating = 'navigating', // 導航中
  ParkConfirm = 'park_confirm', // 確認停車
  ParkLocationMemo = 'park_location_memo', // 停車地點備註
  ParkSetTimer = 'park_set_timer', // 設定停車計時
  ParkTimer = 'park_timer' // 停車計時
}

const currentSelectedPark = ref<ParkPoint | null>({
  name: 'sussy',
  lat: 100,
  lng: 24,
  remainingSpace: 48763,
  price: '40 元/小時',
  distance: 20,
  type: 'yellow_line'
});

const parkTimer = ref(0); // 單位：半小時
const parkMemo = ref(''); // 停車地點備註
const currentStep = ref<NavigatorStep>(NavigatorStep.BrowsingMap);
const handleMapClick = (point: ParkPoint) => {
  currentSelectedPark.value = point;
  currentStep.value =
    point.type === 'park' ? NavigatorStep.NavigatorPark : NavigatorStep.NavigatorYellowLine;
};

export interface Point {
  lat: number;
  lng: number;
}
const destPos = ref<Point | null>(null);
// 前往目的地
const handleGoClick = (dest: Point | null) => {
  // TODO: pop up the routing card
  destPos.value = dest;
  currentStep.value = NavigatorStep.Navigating;
};

// 返回地圖
const handleBackClick = () => {
  currentSelectedPark.value = null;
  currentStep.value = NavigatorStep.BrowsingMap;
};

// 取消導航，回到地標
const handleCancelNavigating = () => {
  currentStep.value =
    currentSelectedPark.value?.type === 'park'
      ? NavigatorStep.NavigatorPark
      : NavigatorStep.NavigatorYellowLine;
};

// 確認停車
const handleConfirmPark = () => {
  // TODO: pop up the parking timer card
  // if 7am to 7:57pm, set park timer to 3
  // else jump to park timer setting
  const now = new Date();
  if (
    (currentSelectedPark.value?.type == 'yellow_line' &&
      now.getHours() >= 7 &&
      now.getHours() < 19) ||
    (now.getHours() === 19 && now.getMinutes() < 57)
  ) {
    handleTimerSet(3, false, false, currentSelectedPark.value?.name ?? '');
    parkTimer.value = 3;
    currentStep.value = NavigatorStep.ParkTimer;
  } else {
    currentStep.value = NavigatorStep.ParkLocationMemo;
  }
};

// 標示為已停車
const handleMarkParked = () => {
  // TODO: back to the map, send the parking information to the server
  currentSelectedPark.value = null;
  currentStep.value = NavigatorStep.BrowsingMap;
};

// for DEMO: 直接抵達
const handleArrive = () => {
  currentStep.value = NavigatorStep.ParkConfirm;
};

const handleTimerSet = (value: number, leaveEarly: boolean, isPark: boolean, place: string) => {
  parkTimer.value = Math.max(0, value);
  currentStep.value = NavigatorStep.ParkTimer;

  const notifyInterval = leaveEarly ? 1 : 5;
  const durationSec = (value - notifyInterval) * 60;
  const type = isPark ? 'park' : 'yellowLine';

  var newDateObj = new Date(Date.now() + durationSec * 1000);

  useConnectionMessage(
    'timer_set',
    JSON.stringify({
      startTime: newDateObj,
      //   duration: durationSec,
      duration: 3,
      type: type,
      remainTime: notifyInterval * 60,
      place: place
    })
  );
};

const handleMemoSet = (value: string) => {
  parkMemo.value = value;
  currentStep.value = NavigatorStep.ParkSetTimer;
};

// 取消停車
const handleCancelPark = () => {
  // back to the point
  currentStep.value =
    currentSelectedPark.value?.type === 'park'
      ? NavigatorStep.NavigatorPark
      : NavigatorStep.NavigatorYellowLine;
};

// 開車閃人
const handleLeave = () => {
  // back to the map
  currentSelectedPark.value = null;
  currentStep.value = NavigatorStep.BrowsingMap;
};

const backClickHandler = ref(handleBackClick);
const goClickHandler = ref(handleGoClick);
const cancelNavigatingHandler = ref(handleCancelNavigating);
const confirmParkHandler = ref(handleConfirmPark);
const arriveHandler = ref(handleArrive);
const markParkedHandler = ref(handleMarkParked);
const timerSetHandler = ref(handleTimerSet);
const memoSetHandler = ref(handleMemoSet);
const cancelParkHandler = ref(handleCancelPark);
const leaveHandler = ref(handleLeave);
const pointClickHandler = ref(handleMapClick);
const isShowNavigatorCard = computed(() => currentSelectedPark.value !== null);

// Usage: <Map @point-click="pointClickHandler" />
</script>
<template>
  <div class="h-screen flex flex-col overflow-hidden relative">
    <div class="flex flex-1">
      <Map @point-click="pointClickHandler" :destPos />
    </div>
    <NavigatorCard
      v-show="isShowNavigatorCard"
      :parkName="currentSelectedPark?.name ?? null"
      :remainingSpace="currentSelectedPark?.remainingSpace ?? null"
      :price="currentSelectedPark?.price ?? null"
      :distance="currentSelectedPark?.distance ?? null"
      :display="currentStep"
      :timePassed="null"
      :maxTime="parkTimer"
      :leaveEarly="true"
      :billingTime="null"
      @button-back="backClickHandler"
      @button-go="goClickHandler"
      @button-cancel-navigating="cancelNavigatingHandler"
      @button-confirm-park="confirmParkHandler"
      @button-cancel-park="cancelParkHandler"
      @button-leave="leaveHandler"
      @button-mark-parked="markParkedHandler"
      @button-set-timer="timerSetHandler"
      @button-set-memo="memoSetHandler"
      @button-demo-directly-arrive="arriveHandler"
      :pos="{ lat: currentSelectedPark?.lat ?? 0, lng: currentSelectedPark?.lng ?? 0 }"
    />
  </div>
</template>
