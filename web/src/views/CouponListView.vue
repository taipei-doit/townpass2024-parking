<script setup lang="ts">
import { computed, onMounted, ref, watchEffect } from 'vue';
import { useRoute, RouterLink } from 'vue-router';
import { storeToRefs } from 'pinia';
import { useCouponStore } from '@/stores/coupon';
import BaseInput from '@/components/atoms/BaseInput.vue';
import CouponListResult from '@/components/organisms/CouponListResult.vue';
import HotSpotList from '@/components/organisms/HotSpotList.vue';
import type { Ticket, Coupon } from '@/views/CouponView.vue';

const route = useRoute();
const store = useCouponStore();
const { ticketList, couponList } = storeToRefs(store);

const isFirstRender = ref(true);

const searchText = ref('');

const activeList = computed(() => (route.query.tab === '1' ? ticketList.value : couponList.value));

const resultList = ref<(Ticket | Coupon)[]>();

watchEffect(() => {
  if (route.query?.isList === 'Y') {
    resultList.value = activeList.value;
    isFirstRender.value = false;
  }
});

const onSearchClick = () => {
  isFirstRender.value = false;

  if (!searchText.value) {
    resultList.value = activeList.value;
  } else {
    resultList.value = activeList.value?.filter((item) => item.name.includes(searchText.value));
  }
};

onMounted(() => {
  const searchInput: HTMLInputElement | null = document.querySelector('.base-input');

  if (route.query.isSearch === 'Y' && searchInput) {
    searchInput.focus();
  }
});
</script>

<template>
  <div class="py-2 px-4">
    <div class="flex justify-between">
      <RouterLink
        :to="{
          name: 'coupon',
          query: {
            tab: route.query?.tab
          }
        }"
      >
        <img src="@/assets/images/down-icon.svg" class="rotate-90" />
      </RouterLink>
      <h1 v-if="route.query?.isList === 'Y'" class="font-bold text-lg">
        {{ route.query?.tab === '1' ? '入場券' : '優惠券' }}列表
      </h1>
      <h1 v-else-if="route.query?.hotSpot === 'Y'" class="font-bold text-lg">熱門場館</h1>
      <h1 v-else-if="route.query?.isFilter === 'Y'" class="font-bold text-lg">優惠券篩選</h1>
      <h1 v-else class="font-bold text-lg">
        {{ route.query?.tab === '1' ? '入場券' : '優惠券' }}搜尋
      </h1>
      <div />
    </div>
    <section v-if="route.query?.hotSpot !== 'Y'" class="flex items-center mt-3">
      <BaseInput
        v-model="searchText"
        :placeholder="route.query.tab === '1' ? '搜尋票券或場館名稱' : '輸入店家名稱'"
        class="flex-grow"
      />
      <button class="search-button" @click="onSearchClick">
        <img src="@/assets/images/search-icon.svg" alt="搜尋" />
      </button>
    </section>
    <section class="py-4">
      <HotSpotList v-if="route.query?.hotSpot === 'Y'" />
      <CouponListResult v-else :activeList="resultList" :isFirstRender="isFirstRender" />
    </section>
  </div>
</template>
