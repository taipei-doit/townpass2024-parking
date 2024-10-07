<script setup lang="ts">
import BaseButton from '@/components/atoms/BaseButton.vue';
import { computed, ref, watch } from 'vue';
import BaseInput from '../atoms/BaseInput.vue';
import type { Point } from '@/views/ParkingService.vue';
const props = defineProps<{
  parkName: string | null;
  remainingSpace: number | null;
  pos: Point | null;
  price: string | null;
  distance: number | null;
  timePassed: number | null; // 單位：秒
  maxTime: number | null;
  leaveEarly: boolean | null;
  billingTime: string | null;
  display:
    | 'browsing_map'
    | 'navigator_park'
    | 'navigator_yellow_line'
    | 'navigating'
    | 'park_confirm'
    | 'park_location_memo'
    | 'park_set_timer'
    | 'park_timer';
}>();
const emit = defineEmits([
  'button-go',
  'button-back',
  'button-mark-parked',
  'button-cancel-park',
  'button-cancel-navigating',
  'button-set-memo',
  'button-set-timer',
  'button-skip-timer',
  'button-demo-directly-arrive',
  'button-confirm-park',
  'button-leave'
]);
const isNavigatorPark = computed(() => props.display === 'navigator_park');
const isNavigatorYellowLine = computed(() => props.display === 'navigator_yellow_line');
const isNavigating = computed(() => props.display === 'navigating');
const isParkConfirm = computed(() => props.display === 'park_confirm');
const isParkLocationMemo = computed(() => props.display === 'park_location_memo');
const isParkSetTimer = computed(() => props.display === 'park_set_timer');
const isParkTimer = computed(() => props.display === 'park_timer');
const warningThreshold = computed(() => (props.leaveEarly ? 1 : 5));
const pricePerHour = computed(() => {
  const tryPrice = parseFloat(props.price?.replace('元/', '') ?? '0');
  if (isNaN(tryPrice)) {
    return 0;
  }
  return tryPrice;
});

const parkTimer = ref(0);
const parkMemo = ref('');
const parkCountup = ref(props.timePassed || 0);
const counterHandler = ref(0);
watch(
  () => props.display,
  (newVal: string) => {
    if (newVal === 'park_timer' && counterHandler.value === 0) {
      counterHandler.value = setInterval(() => {
        parkCountup.value += 1;
      }, 1000);
    }
  }
);

const setParkTimer = (value: number) => {
  parkTimer.value = Math.max(0, value);
};

const timerTextColor = computed(() => {
  if (props.timePassed === null || props.maxTime === null) {
    return 'text-grey-500';
  }
  const timeLeft = props.maxTime - props.timePassed;
  if (timeLeft < 0) {
    return 'text-warn-100';
  } else if (timeLeft < warningThreshold.value) {
    return 'text-orange-500';
  } else {
    return 'text-primary-500';
  }
});

const formattedTime = (time: number) => {
  const hours = Math.floor(time / 60);
  const minutes = time % 60;
  return `${hours}時${minutes}分`;
};
</script>
<template>
  <div
    class="goto-card flex flex-col absolute bottom-0 bg-white rounded-lg p-4 mb-8"
    :class="{ show: props.display !== 'browsing_map' }"
  >
    <!-- 停車場 -->
    <div v-if="isNavigatorPark" class="container">
      <div class="text-2xl w-full text-center p-2">
        <span>{{ props.parkName }}</span>
        <span class="text-base text-gray-500"> (尚有{{ props.remainingSpace }}格)</span>
      </div>
      <div class="text-center min-w-48 pt-2 pb-4 m-auto">
        <!-- <div class="flex-row max-w-48 justify-between">
          <p>收費時段：</p>
          <p class="text-gray-500">{{ props.billingTime || '--' }}</p>
        </div> -->
        <div class="flex-row max-w-48 justify-between">
          <p>收費：</p>
          <p class="text-gray-500">{{ props.price }}</p>
        </div>
        <div class="flex-row max-w-48 justify-between">
          <p>距離：</p>
          <p class="text-gray-500">{{ props.distance }} 公里</p>
        </div>
      </div>
      <div class="button-set">
        <BaseButton class="button button-go" @click="$emit('button-go', props.pos)"
          >前往</BaseButton
        >
        <BaseButton outline class="button button-back" @click="$emit('button-back')">
          取消
        </BaseButton>
      </div>
    </div>
    <!-- 黃線停車 -->
    <div v-else-if="isNavigatorYellowLine" class="container">
      <h2 class="text-2xl w-full text-center p-2">黃線</h2>
      <div class="align-center text-center w-2x pt-2 pb-4">
        <p>距離：{{ props.distance }}公里</p>
      </div>
      <div class="button-set">
        <BaseButton class="button button-go" @click="$emit('button-go', props.pos)"
          >前往</BaseButton
        >
        <BaseButton outline class="button button-back" @click="$emit('button-back')">
          返回
        </BaseButton>
      </div>
    </div>
    <!-- 導航中 -->
    <div v-else-if="isNavigating" class="container">
      <h2 class="text-2xl w-full text-center p-2">導航中</h2>
      <div class="button-set p-2">
        <BaseButton outline class="button" @click="$emit('button-cancel-navigating')"
          >取消導航</BaseButton
        >
        <BaseButton class="button" @click="$emit('button-demo-directly-arrive')">到達</BaseButton>
      </div>
    </div>
    <!-- 停車確認 -->
    <div v-else-if="isParkConfirm" class="container">
      <h2 class="text-2xl w-full pb-6 pt-2 text-center">是否停好車了？</h2>
      <div class="button-set">
        <BaseButton class="button button-go" @click="$emit('button-confirm-park')">是</BaseButton>
        <BaseButton class="button button-back" @click="$emit('button-mark-parked')"
          >車位已有車</BaseButton
        >
        <BaseButton outline class="button button-back" @click="$emit('button-cancel-park')"
          >取消</BaseButton
        >
      </div>
    </div>
    <!-- 停車位置備註 -->
    <div v-else-if="isParkLocationMemo" class="container">
      <h2 class="text-2xl w-full p-2 text-center">停車位置備註</h2>
      <BaseInput v-model="parkMemo" class="memo-input" placeholder="ex. 車位號碼如 A123 等" />
      <div class="button-set">
        <BaseButton class="button" @click="$emit('button-set-memo', parkMemo)">確認</BaseButton>
        <BaseButton outline class="button" @click="$emit('button-set-memo', '')">跳過</BaseButton>
      </div>
    </div>
    <!-- 設定停車計時 -->
    <div v-else-if="isParkSetTimer" class="container">
      <h2 class="text-2xl w-full p-2 text-center">設定停車計時</h2>
      <div class="input-set">
        <BaseButton @click="setParkTimer(parkTimer - 30)">-</BaseButton>
        <span class="parking-timer-label">{{ (parkTimer / 60).toFixed(1) }} 小時</span>
        <BaseButton @click="setParkTimer(parkTimer + 30)">+</BaseButton>
      </div>
      <div class="button-set">
        <BaseButton
          class="button"
          @click="$emit('button-set-timer', parkTimer, false, true, props.parkName)"
          >確認</BaseButton
        >
        <BaseButton
          outline
          class="button"
          @click="$emit('button-set-timer', 0, false, false, props.parkName)"
          >跳過</BaseButton
        >
      </div>
    </div>
    <!-- 停車計時 -->
    <div v-else-if="isParkTimer" class="container">
      <h2 class="text-2xl w-full p-2 text-center">停車計時</h2>
      <div class="flex justify-center">
        <span :class="timerTextColor" class="text-xl font-bold pb-1">
          {{ formattedTime(Math.floor(parkCountup / 60)) /* 傳分鐘進去 */ }}
        </span>
        <span class="text-grey-500 text-xl font-bold"
          >/{{ formattedTime(props.maxTime ?? 0) }}</span
        >
      </div>
      <div class="text-center pb-2">
        <span class="text-lg text-center"
          >已累計金額：{{ pricePerHour * Math.ceil(parkCountup / 3600) }}元</span
        >
      </div>
      <div class="button-set">
        <BaseButton class="button button-go" @click="$emit('button-leave')">離開</BaseButton>
        <!-- <BaseButton class="button button-back" @click="$emit('button-back')">車位已停車</BaseButton> -->
        <!-- <BaseButton outline class="button button-back" @click="$emit('button-go')">取消</BaseButton> -->
      </div>
    </div>
  </div>
</template>
<style lang="postcss">
.goto-card {
  @apply flex;
  @apply flex-col;
  width: calc(100% - 32px);
  margin-left: 16px;
  margin-right: 16px;
  left: 100%;
  transition: left 0.5s;
}

.goto-card.show {
  left: 0;
}

.container {
  @apply flex;
  @apply flex-col;
}

.memo-input {
  @apply mx-2;
  @apply my-4;
}

.input-set {
  @apply flex;
  @apply justify-center;
  @apply w-full;
  @apply items-center;
  @apply gap-2;
  @apply pb-4;
}

.input-set button {
  width: 36px;
  height: 36px;
  padding: 8px;
}

.button-set {
  @apply flex;
  @apply justify-center;
  @apply w-full;
}

.button-set .button {
  @apply mx-2;
  @apply flex-1;
  max-width: 200px;
}
</style>
