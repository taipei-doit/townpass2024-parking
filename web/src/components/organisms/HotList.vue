<script setup lang="ts">
import { RouterLink } from 'vue-router';
import HotListItem from '@/components/molecules/HotListItem.vue';
import type { Ticket, Coupon } from '@/views/CouponView.vue';

const props = defineProps<{
  tab: string;
  list: Ticket[] | Coupon[] | [];
}>();
</script>

<template>
  <div class="flex justify-between items-end">
    <h3 class="text-lg font-bold">熱門</h3>
    <div class="flex">
      <RouterLink
        :to="{
          name: 'coupon-list',
          query: {
            tab: props.tab,
            isList: 'Y'
          }
        }"
        class="text-sm"
      >
        更多
      </RouterLink>
      <img src="@/assets/images/down-icon.svg" alt="更多" class="w-5 -rotate-90 ml-1" />
    </div>
  </div>
  <ul class="pt-2 pb-8 grid grid-cols-1 gap-y-3">
    <li v-for="item in props.list" :key="item.id" class="border border-gray-400 rounded-md">
      <HotListItem :item="item" />
    </li>
  </ul>
</template>
