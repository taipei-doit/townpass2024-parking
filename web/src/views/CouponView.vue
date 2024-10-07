<script setup lang="ts">
import { computed, ref } from 'vue';
import { storeToRefs } from 'pinia';
import { useRoute, RouterLink } from 'vue-router';
import BaseInput from '@/components/atoms/BaseInput.vue';
import ServiceTabsView from '@/components/organisms/ServiceTabsView.vue';
import HotList from '@/components/organisms/HotList.vue';
import { useCouponStore } from '@/stores/coupon';
import couponDataJson from '../../public/mock/coupon_data.json';

export interface HotSpot {
  id: string;
  name: string;
  introduce: string;
  business_hours: string[];
  address: {
    text: string;
    map: string;
  };
  is_sell_ticket: boolean;
  img_url: string;
}

export interface Ticket {
  id: string;
  name: string;
  type: string;
  text: string;
  price: number;
  vip_text: string;
  discount_text: string;
  is_hot: boolean;
  img_url: string;
  detail_price: string[];
  address: {
    text: string;
    map: string;
  };
  activity_date: string;
  ticket_illustrate: string[];
  spot_introduce: string;
  instructions: string[];
  purchase_link: string;
}

export interface Coupon {
  id: string;
  name: string;
  text: string;
  vip_text: string;
  discount_text: string;
  deadline: string;
  remaining: string;
  is_hot: boolean;
  img_url: string;
  activity_date: string;
  rule: string;
  coupon_illustrate: string;
  store_info: {
    img_url: string;
    name: string;
    introduce: string[];
    address: {
      text: string;
      map: string;
    };
  };
}

const route = useRoute();

const store = useCouponStore();

const { ticketList, couponList, hotSpotList } = storeToRefs(store);

ticketList.value = couponDataJson.data.ticket_list;
couponList.value = couponDataJson.data.coupon_list;
hotSpotList.value = couponDataJson.data.hot_spot_list;

const activeTab = ref(0);

if (route.query?.tab === '2') {
  activeTab.value = 1;
}

const tabList = [
  {
    id: 1,
    title: '入場券'
  },
  {
    id: 2,
    title: '優惠券'
  }
];

const hotTicketList = computed(() => ticketList.value?.filter((item) => item.is_hot) ?? []);
const hotCouponList = computed(() => couponList.value?.filter((item) => item.is_hot) ?? []);
</script>

<template>
  <div>
    <ServiceTabsView v-model="activeTab" :tab-list="tabList">
      <template #tab0>
        <section class="flex items-center p-4">
          <RouterLink
            :to="{
              name: 'coupon-list',
              query: {
                tab: '1',
                isSearch: 'Y'
              }
            }"
            class="flex-grow"
          >
            <BaseInput placeholder="搜尋票券或場館名稱" readonly class="w-full" />
          </RouterLink>
          <RouterLink
            :to="{
              name: 'coupon-list',
              query: {
                tab: '1',
                isSearch: 'Y'
              }
            }"
            class="search-button"
          >
            <img src="@/assets/images/search-icon.svg" alt="搜尋" />
          </RouterLink>
        </section>
        <section class="px-4 grid grid-cols-2 gap-x-3">
          <RouterLink
            :to="{
              name: 'coupon-list',
              query: {
                tab: '1',
                isList: 'Y'
              }
            }"
            class="ticket-hot-button"
          >
            <span class="text-lg font-bold">人氣特展</span>
            <br />
            <span>廣受好評的票券</span>
            <img src="@/assets/images/award-icon.svg" />
          </RouterLink>
          <RouterLink
            :to="{
              name: 'coupon-list',
              query: {
                tab: '1',
                hotSpot: 'Y'
              }
            }"
            class="ticket-hot-button"
          >
            <span class="text-lg font-bold">熱門場館</span>
            <br />
            <span>熱門景點</span>
            <img src="@/assets/images/gondola-icon.svg" />
          </RouterLink>
        </section>
        <section class="px-4 mt-5">
          <HotList tab="1" :list="hotTicketList" />
        </section>
      </template>
      <template #tab1>
        <section class="flex items-center p-4">
          <RouterLink
            :to="{
              name: 'coupon-list',
              query: {
                tab: '2',
                isSearch: 'Y'
              }
            }"
            class="flex-grow"
          >
            <BaseInput placeholder="輸入店家名稱" readonly class="w-full" />
          </RouterLink>
          <RouterLink
            :to="{
              name: 'coupon-list',
              query: {
                tab: '2',
                isSearch: 'Y'
              }
            }"
            class="search-button"
          >
            <img src="@/assets/images/search-icon.svg" alt="搜尋" />
          </RouterLink>
        </section>
        <section class="px-4 mt-5">
          <HotList tab="2" :list="hotCouponList" />
        </section>
      </template>
    </ServiceTabsView>
  </div>
</template>

<style lang="postcss">
.ticket-hot-button {
  @apply rounded-md shadow-md relative;
  @apply bg-primary-100;
  @apply p-4;

  & > img {
    @apply absolute top-0 right-2;
  }
}
</style>
