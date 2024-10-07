<script setup lang="ts">
import FindPlace, { type Place } from '@/components/molecules/FindPlace.vue';
import { useGoogleMapsStore } from '@/stores/googleMaps';
import axios from 'axios';
import { onMounted, ref, watch } from 'vue';
import BaseButton from '@/components/atoms/BaseButton.vue';
import type { Spot } from '@/views/SurroundingServiceView.vue';

const props = defineProps<{
  selectedSearchData: Place;
  filteredSpotList: Spot[];
}>();
const emit = defineEmits(['update:isExpandList', 'update:selectedSpot']);

const scrollToTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  });
};
</script>

<template>
  <div class="pb-8 h-screen flex flex-col">
    <!-- title -->
    <div class="p-5">
      <div class="flex items-center mb-2">
        <span class="font-bold text-xl mr-2">{{ selectedSearchData.name }}</span>
        <div class="text-primary-500 border border-primary-500 rounded-full px-2">
          {{ filteredSpotList.length }}筆結果
        </div>
      </div>
      <p class="text-grey-500 text-sm">{{ selectedSearchData.agency }}</p>
    </div>
    <!-- list -->
    <div
      v-for="spot in filteredSpotList"
      :key="spot.id"
      class="mx-5 py-4 border-b border-grey-200"
      @click="
        emit('update:isExpandList', false);
        emit('update:selectedSpot', spot);
      "
    >
      <p class="underline font-bold mb-2">{{ spot.name }}</p>
      <div class="flex mb-2">
        <img src="@/assets/images/icon-geo.svg" alt="" />
        <span>{{ spot.address }}</span>
      </div>
      <!-- custom template -->
      <div class="flex text-grey-500">
        <span>{{ spot.distance }}公里</span>
        <!-- <span class="mx-2">|</span>
        <span class="flex">
          <template v-if="spot.available_rent_bikes !== 0 && spot.available_return_bikes !== 0">
            <img src="/public/images/map/youbike/icon-info-ubike-green.svg" alt="" />
            <span class="ml-1 text-[#76A732]">正常租借</span>
          </template>
          <template v-if="spot.available_rent_bikes === 0">
            <img src="/public/images/map/youbike/icon-info-ubike-yellow.svg" alt="" />
            <span class="ml-1 text-secondary-500">無車可借</span>
          </template>
          <template v-if="spot.available_return_bikes === 0">
            <img src="/public/images/map/youbike/icon-info-ubike-red.svg" alt="" />
            <span class="ml-1 text-[#E5464B]"> 車位滿載</span>
          </template>
        </span>
        <span class="mx-2">|</span>
        <span>
          <span class="text-grey-500 mr-1">可借</span>
          <span
            class="mr-1"
            :class="spot.available_rent_bikes === 0 ? 'text-secondary-500' : 'text-[#76A732]'"
          >
            {{ spot.available_rent_bikes }}
          </span>
          <span class="text-grey-500 mr-1">可停</span>
          <span :class="spot.available_return_bikes === 0 ? 'text-[#E5464B]' : 'text-grey-950'">
            {{ spot.available_return_bikes }}
          </span>
        </span> -->
      </div>
    </div>
    <div v-if="!filteredSpotList.length" class="flex-1 flex justify-center items-center">
      <div class="text-center">
        <img src="@/assets/images/img-maplost.svg" class="mx-auto mb-2" alt="" />
        <p class="text-primary-500 font-bold text-xl mb-2">無符合搜尋結果</p>
        <p class="text-grey-500 text-sm">請試試其篩選分類</p>
      </div>
    </div>

    <!-- 浮動按鈕 -->
    <BaseButton
      shape="rounded"
      class="fixed bottom-10 left-[50%] translate-x-[-50%] h-[56px]"
      @click="emit('update:isExpandList', false)"
    >
      <div class="flex px-2">
        <img src="@/assets/images/icon-map.svg" class="mr-2" width="24" alt="" />
        <span>地圖</span>
      </div>
    </BaseButton>
    <BaseButton
      shape="rounded"
      v-if="filteredSpotList.length"
      class="fixed bottom-10 right-6 w-[56px] h-[56px]"
      @click="scrollToTop"
    >
      TOP
    </BaseButton>
  </div>
</template>

<style lang="postcss" scoped></style>
