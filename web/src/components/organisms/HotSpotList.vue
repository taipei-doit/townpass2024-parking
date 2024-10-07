<script setup lang="ts">
import { RouterLink } from 'vue-router';
import { storeToRefs } from 'pinia';
import { useCouponStore } from '@/stores/coupon';
import HotSpotItem from '@/components/molecules/HotSpotItem.vue';

const store = useCouponStore();
const { hotSpotList } = storeToRefs(store);
</script>

<template>
  <ul class="grid grid-cols-1 gap-y-3">
    <li v-for="item in hotSpotList" :key="item.id" class="border-gray-200 border-b pb-2">
      <RouterLink :to="{ name: 'hotspot', params: { id: item.id } }">
        <HotSpotItem
          :name="item.name"
          :img_url="item.img_url"
          :introduce="item.introduce"
          :business_hours="item.business_hours"
        />
      </RouterLink>
    </li>
  </ul>
</template>
