<script setup lang="ts">
import BaseButton from '@/components/atoms/BaseButton.vue';
import type { Spot } from '@/views/SurroundingServiceView.vue';
import type { Place } from '../molecules/FindPlace.vue';

const props = defineProps<{
  selectedSearchData: Place;
  selectedSpot: Spot;
}>();
const emit = defineEmits(['update:isExpandDetail']);
</script>

<template>
  <div class="pb-8 h-screen flex flex-col bg-grey-50">
    <div class="p-5 bg-white mb-4">
      <!-- title -->
      <div class="flex items-center mb-2">
        <img
          src="@/assets/images/down-icon.svg"
          class="rotate-90 mr-2"
          @click="emit('update:isExpandDetail', false)"
          alt=""
        />
        <span class="font-bold text-xl">{{ selectedSpot.name }}</span>
      </div>
      <p class="text-grey-500 text-sm">{{ selectedSpot.agency }}</p>
      <!-- custom template -->
      <div class="flex text-grey-500 mb-2">
        <span>{{ selectedSpot.distance }}公里</span>
        <!-- <span class="mx-2">|</span>
        <span class="flex">
          <template
            v-if="
              selectedSpot.available_rent_bikes !== 0 && selectedSpot.available_return_bikes !== 0
            "
          >
            <img src="/public/images/map/youbike/icon-info-ubike-green.svg" alt="" />
            <span class="ml-1 text-[#76A732]">正常租借</span>
          </template>
          <template v-if="selectedSpot.available_rent_bikes === 0">
            <img src="/public/images/map/youbike/icon-info-ubike-yellow.svg" alt="" />
            <span class="ml-1 text-secondary-500">無車可借</span>
          </template>
          <template v-if="selectedSpot.available_return_bikes === 0">
            <img src="/public/images/map/youbike/icon-info-ubike-red.svg" alt="" />
            <span class="ml-1 text-[#E5464B]"> 車位滿載</span>
          </template>
        </span>
        <span class="mx-2">|</span>
        <span>
          <span class="text-grey-500 mr-1">可借</span>
          <span
            class="mr-1"
            :class="
              selectedSpot.available_rent_bikes === 0 ? 'text-secondary-500' : 'text-[#76A732]'
            "
          >
            {{ selectedSpot.available_rent_bikes }}
          </span>
          <span class="text-grey-500 mr-1">可停</span>
          <span
            :class="
              selectedSpot.available_return_bikes === 0 ? 'text-[#E5464B]' : 'text-grey-950'
            "
          >
            {{ selectedSpot.available_return_bikes }}
          </span>
        </span> -->
      </div>
      <!-- address -->
      <div class="flex mb-2">
        <img src="@/assets/images/icon-geo.svg" alt="" />
        <span class="underline">{{ selectedSpot.address }}</span>
      </div>
    </div>
    <div class="p-5 bg-white">
      <p class="text-grey-500 mb-2">服務資訊</p>
      <!-- custom template -->
      <div>
        <template v-for="(info, index) in selectedSpot.serviceInfos" :key="index">
          <p>{{ info.title }}</p>
          <template v-if="Array.isArray(info.value_fields)">
            <ul class="mb-2" v-for="(subInfo, subIndex) in info.value_fields" :key="subIndex">
              <li>- {{ subInfo.title }}：{{ subInfo.value }}</li>
            </ul>
          </template>
          <template v-else>
            <ul class="mb-2">
              <li>- {{ info.value }}</li>
            </ul>
          </template>
        </template>

        <!-- <p>備註</p>
        <ul class="mb-2">
          <li>-可借車輛：{{ selectedSpot.available_rent_bikes }} 輛</li>
          <li>-可停空位：{{ selectedSpot.available_return_bikes }} 輛</li>
        </ul>
        <p>更新時間</p>
        <ul>
          <li>-{{ selectedSpot.updateTime }}</li>
        </ul> -->
      </div>
    </div>
  </div>
</template>

<style lang="postcss" scoped></style>
