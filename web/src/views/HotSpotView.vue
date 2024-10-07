<script setup lang="ts">
import { computed, ref } from 'vue';
import { RouterLink, useRoute, useRouter } from 'vue-router';
import { storeToRefs } from 'pinia';
import { useCouponStore } from '@/stores/coupon';
import { useConnectionMessage } from '@/composables/useConnectionMessage';
import { useHandleConnectionData } from '@/composables/useHandleConnectionData';
import BaseDialog from '@/components/atoms/BaseDialog.vue';
import CouponResultItem from '@/components/molecules/CouponResultItem.vue';

const store = useCouponStore();
const route = useRoute();
const router = useRouter();

const { ticketListMap, hotSpotListMap } = storeToRefs(store);

const activeItem = computed(() => hotSpotListMap.value.get(route.params.id as string));

const ticketItem = computed(() =>
  activeItem.value?.is_sell_ticket ? ticketListMap.value.get(activeItem.value.id) : null
);

if (!activeItem.value?.id) {
  router.push({
    name: 'coupon'
  });
}

const isMapDialogOpen = ref(false);

const handleLaunchMap = (event: { data: string }) => {
  const result: { name: string; data: boolean } = JSON.parse(event.data);

  if (!result.data) {
    window.open(activeItem.value?.address.map, '_blank', 'noopener,noreferrer');
  }
};

useHandleConnectionData(handleLaunchMap);

const onMapOpenClick = () => {
  useConnectionMessage('launch_map', activeItem.value?.address.map);
};

const isIntroduceExpand = ref(false);
</script>

<template>
  <div class="py-2 px-4">
    <div class="flex justify-between">
      <RouterLink
        :to="{
          name: 'coupon-list',
          query: {
            tab: '1',
            hotSpot: 'Y'
          }
        }"
      >
        <img src="@/assets/images/down-icon.svg" class="rotate-90" />
      </RouterLink>
      <h2 class="font-bold text-lg">{{ activeItem?.name }}</h2>
      <div />
    </div>
    <img
      :src="activeItem?.img_url"
      :alt="activeItem?.name"
      class="rounded-md w-full h-48 mt-3 object-cover"
    />
    <h1 class="font-bold text-2xl mt-2 mb-4">{{ activeItem?.name }}</h1>
    <section>
      <div class="grid grid-cols-9">
        <img src="@/assets/images/location-icon.svg" />
        <a
          :href="activeItem?.address.map"
          class="col-span-8 underline"
          @click.prevent="isMapDialogOpen = true"
        >
          {{ activeItem?.address.text }}
        </a>
      </div>
      <div class="grid grid-cols-9 my-2">
        <img src="@/assets/images/calendar-icon.svg" />
        <div class="col-span-8">
          <p class="font-bold">開放時間</p>
          <p v-for="text in activeItem?.business_hours" :key="text">{{ text }}</p>
        </div>
      </div>
      <div class="grid grid-cols-9">
        <img src="@/assets/images/introduce-icon.svg" />
        <div class="col-span-8">
          <div class="flex justify-between">
            <span class="font-bold">場館說明</span>
            <button @click="isIntroduceExpand = !isIntroduceExpand">
              <img
                src="@/assets/images/down-icon.svg"
                class="transition-transform"
                :class="{
                  'rotate-180': isIntroduceExpand
                }"
              />
            </button>
          </div>
          <div
            class="grid grid-rows-[0fr] transition-all"
            :class="{
              'grid-rows-[1fr]': isIntroduceExpand
            }"
          >
            <p class="overflow-hidden">{{ activeItem?.introduce }}</p>
          </div>
        </div>
      </div>
    </section>
    <section v-if="ticketItem && activeItem?.is_sell_ticket" class="mt-4">
      <h3 class="font-bold text-2xl">熱門票券</h3>
      <div class="mt-2 pb-2 border-b border-b-gray-300">
        <CouponResultItem :item="ticketItem" />
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
  </div>
</template>
