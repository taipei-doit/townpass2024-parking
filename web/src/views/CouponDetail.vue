<script setup lang="ts">
import { ref, computed } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { storeToRefs } from 'pinia';
import { useCouponStore } from '@/stores/coupon';
import { useConnectionMessage } from '@/composables/useConnectionMessage';
import { useHandleConnectionData } from '@/composables/useHandleConnectionData';
import ServiceTabsView from '@/components/organisms/ServiceTabsView.vue';
import BaseDialog from '@/components/atoms/BaseDialog.vue';
import BaseButton from '@/components/atoms/BaseButton.vue';

const router = useRouter();
const route = useRoute();

const store = useCouponStore();
const { couponListMap } = storeToRefs(store);

const couponItem = computed(() => couponListMap.value.get(route.params.id as string));

const tabList = [
  {
    id: 1,
    title: '優惠說明'
  },
  {
    id: 2,
    title: '店家資訊'
  }
];

const activeTab = ref(0);

const onBackButtonClick = () => {
  if (route.query.tab) {
    router.push({ name: 'coupon', query: { tab: route.query.tab } });
  } else {
    router.back();
  }
};

const isMapDialogOpen = ref(false);
const isUseDialogOpen = ref(false);
const isExchangeDialogOpen = ref(false);

const handleLaunchMap = (event: { data: string }) => {
  const result: { name: string; data: boolean } = JSON.parse(event.data);

  if (!result.data) {
    window.open(couponItem.value?.store_info.address.map, '_blank', 'noopener,noreferrer');
  }
};

useHandleConnectionData(handleLaunchMap);

const onMapOpenClick = () => {
  useConnectionMessage('launch_map', couponItem.value?.store_info.address.map);
};
</script>

<template>
  <div class="px-4 pt-10">
    <section class="fixed top-0 left-0 z-10 w-screen bg-white p-4 flex justify-between">
      <button @click="onBackButtonClick">
        <img src="@/assets/images/down-icon.svg" class="rotate-90" />
      </button>
      <span class="font-bold text-gray-700">優惠券</span>
      <div />
    </section>
    <section v-if="couponItem">
      <div
        class="bg-cover bg-no-repeat bg-center h-[200px] rounded-[10px] my-4"
        :style="`background-image: url(${couponItem.img_url})`"
      ></div>
      <h1 class="text-lg text-gray-800 font-semibold mb-4">{{ couponItem.name }}</h1>
      <ServiceTabsView v-model="activeTab" :tab-list="tabList" :contentType="true">
        <template #tab0>
          <ul class="py-6 flex flex-col gap-y-4 text-grey-800">
            <li class="grid grid-cols-9">
              <img src="@/assets/images/calendar-icon.svg" />
              <div class="col-span-8">
                <p class="font-bold">活動日期</p>
                <p>{{ couponItem.activity_date }}</p>
              </div>
            </li>
            <li class="grid grid-cols-9">
              <img src="@/assets/images/rule-icon.svg" />
              <div class="col-span-8">
                <p class="font-bold">領取規則</p>
                <p>{{ couponItem.rule || '無領取限制' }}</p>
              </div>
            </li>
            <li v-if="couponItem.remaining" class="grid grid-cols-9">
              <img src="@/assets/images/ticket-icon.svg" />
              <div class="col-span-8">
                <p class="font-bold">票券數量</p>
                <p>剩餘{{ couponItem.remaining }}份</p>
              </div>
            </li>
            <li class="grid grid-cols-9">
              <img src="@/assets/images/introduce-icon.svg" />
              <div class="col-span-8">
                <p class="font-bold">優惠說明</p>
                <p class="whitespace-pre-line">{{ couponItem.coupon_illustrate }}</p>
              </div>
            </li>
          </ul>
        </template>
        <template #tab1>
          <div class="flex justify-center py-4">
            <img
              :src="couponItem.store_info.img_url"
              :alt="couponItem.store_info.name"
              class="w-20 h-20 rounded-full object-cover"
            />
          </div>
          <h2 class="text-lg text-gray-800 font-semibold text-center mb-5">
            {{ couponItem.store_info.name }}
          </h2>
          <div>
            <p v-for="(text, index) in couponItem.store_info.introduce" :key="index" class="mb-5">
              {{ text }}
            </p>
          </div>
          <div class="grid grid-cols-9">
            <img src="@/assets/images/location-icon.svg" />
            <a
              :href="couponItem?.store_info.address.map"
              class="col-span-8 underline"
              @click.prevent="isMapDialogOpen = true"
            >
              {{ couponItem?.store_info.address.text }}
            </a>
          </div>
        </template>
      </ServiceTabsView>
      <div class="flex justify-center -mx-4 py-4 shadow-[0_0_6px_0_rgba(0,0,0,0.1)] mt-3">
        <BaseButton class="w-3/4" @click="isUseDialogOpen = true">立即使用</BaseButton>
      </div>
    </section>
    <BaseDialog
      v-model="isMapDialogOpen"
      title="是否要開啟 Google Map"
      content="開啟 Google Maps APP 導航?"
      :isAlert="true"
      positiveText="開啟"
      negativeText="取消"
      @onPositiveClick="onMapOpenClick"
    />
    <BaseDialog
      v-model="isUseDialogOpen"
      title="確認使用本優惠?"
      content="注意！點選使用立即進行兌換"
      :isAlert="true"
      positiveText="使用"
      negativeText="取消"
      @onPositiveClick="isExchangeDialogOpen = true"
    />
    <BaseDialog
      v-model="isExchangeDialogOpen"
      title="優惠已兌換"
      content=""
      :is-check="true"
      positiveText="確定"
    />
  </div>
</template>
