<script setup lang="ts">
import CouponResultItem from '@/components/molecules/CouponResultItem.vue';
import type { Ticket, Coupon } from '@/views/CouponView.vue';

const props = defineProps<{
  activeList: (Ticket | Coupon)[] | undefined;
  isFirstRender: boolean;
}>();
</script>

<template>
  <ul
    v-if="
      props.isFirstRender || (!props.isFirstRender && props.activeList && props.activeList.length)
    "
    class="grid grid-cols-1 gap-y-3"
  >
    <li v-for="item in props.activeList" :key="item.id" class="border-b border-b-gray-300 pb-2">
      <CouponResultItem :item="item" />
    </li>
  </ul>
  <div v-else class="flex flex-col justify-center items-center pt-40">
    <img src="@/assets/images/img-info.svg" class="w-36" />
    <p class="text-primary-500 font-semibold text-2xl">無符合搜尋結果</p>
    <p class="text-gray-400 text-sm mt-2 font-semibold">請試試其他關鍵字或篩選分類</p>
  </div>
</template>
