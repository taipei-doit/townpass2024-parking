<script setup lang="ts">
import { ref, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { storeToRefs } from 'pinia';
import { useCouponStore } from '@/stores/coupon';
import { useConnectionMessage } from '@/composables/useConnectionMessage';
import { useHandleConnectionData } from '@/composables/useHandleConnectionData';
import BaseCardlabel from '@/components/atoms/BaseCardlabel.vue';
import { CardLabelType } from '@/components/atoms/BaseCardlabel.vue';
import BaseDialog from '@/components/atoms/BaseDialog.vue';
import BaseButton from '@/components/atoms/BaseButton.vue';

const route = useRoute();
const router = useRouter();
const store = useCouponStore();
const { ticketListMap } = storeToRefs(store);

const ticketItem = computed(() => ticketListMap.value.get(route.params.id as string));

const isMapDialogOpen = ref(false);

const isIntroduceExpand = ref(false);
const isIllustrateExpand = ref(false);

const handleLaunchMap = (event: { data: string }) => {
  const result: { name: string; data: boolean } = JSON.parse(event.data);

  if (!result.data) {
    window.open(ticketItem.value?.address.map, '_blank', 'noopener,noreferrer');
  }
};

useHandleConnectionData(handleLaunchMap);

const onMapOpenClick = () => {
  useConnectionMessage('launch_map', ticketItem.value?.address.map);
};

const onPurchaseClick = () => {
  useConnectionMessage('open_link', ticketItem.value?.purchase_link);
};
</script>

<template>
  <div class="px-4 pt-10">
    <section class="fixed top-0 left-0 z-10 w-screen bg-white p-4 flex justify-between">
      <button @click="router.back()">
        <img src="@/assets/images/down-icon.svg" class="rotate-90" />
      </button>
      <span class="font-bold text-gray-700">入場券</span>
      <div />
    </section>
    <section v-if="ticketItem">
      <div
        class="relative bg-cover bg-no-repeat bg-center h-[200px] rounded-[10px] my-4"
        :style="`background-image: url(${ticketItem.img_url})`"
      >
        <BaseCardlabel
          v-if="ticketItem.vip_text"
          :title="ticketItem.vip_text"
          :label-type="CardLabelType.VIP"
          class="absolute top-0 -right-2 !p-1.5"
        />
        <BaseCardlabel
          v-if="ticketItem.discount_text"
          :title="ticketItem.discount_text"
          :label-type="CardLabelType.DISCOUNT"
          class="absolute top-10 -right-2 !p-1.5"
          :class="{ '!top-0': !ticketItem.vip_text }"
        />
      </div>
      <h1 class="text-gray-800 text-lg font-bold">
        | {{ ticketItem.name }} | {{ ticketItem.type }}
      </h1>
      <div class="text-primary-500 p-4 bg-primary-50 mt-5">
        <h2 class="font-semibold text-xl">票券價格</h2>
        <ul class="pl-5 mt-2 flex flex-col gap-y-1">
          <li v-for="text in ticketItem.detail_price" :key="text" class="list-disc">
            <p>{{ text }}</p>
          </li>
        </ul>
      </div>
      <div class="mt-4">
        <div class="grid grid-cols-9">
          <img src="@/assets/images/location-icon.svg" />
          <a
            :href="ticketItem?.address.map"
            class="col-span-8 underline"
            @click.prevent="isMapDialogOpen = true"
          >
            {{ ticketItem?.address.text }}
          </a>
        </div>
        <div class="grid grid-cols-9 my-2">
          <img src="@/assets/images/calendar-icon.svg" />
          <div class="col-span-8">
            <p class="font-bold">活動日期</p>
            <p>{{ ticketItem.activity_date }}</p>
          </div>
        </div>
        <div class="grid grid-cols-9 mb-2">
          <img src="@/assets/images/ticket-content-icon.svg" />
          <div class="col-span-8">
            <div class="flex justify-between">
              <span class="font-bold">票券說明</span>
              <button @click="isIllustrateExpand = !isIllustrateExpand">
                <img
                  src="@/assets/images/down-icon.svg"
                  class="transition-transform"
                  :class="{
                    'rotate-180': isIllustrateExpand
                  }"
                />
              </button>
            </div>
            <div
              class="grid grid-rows-[0fr] transition-all mt-2"
              :class="{
                'grid-rows-[1fr]': isIllustrateExpand
              }"
            >
              <div class="overflow-hidden">
                <ul class="text-sm">
                  <li v-for="text in ticketItem.ticket_illustrate" :key="text" class="list-disc">
                    {{ text }}
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <div class="grid grid-cols-9">
          <img src="@/assets/images/site-icon.svg" />
          <div class="col-span-8">
            <div class="flex justify-between">
              <span class="font-bold">場館簡介</span>
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
              class="grid grid-rows-[0fr] transition-all mt-2"
              :class="{
                'grid-rows-[1fr]': isIntroduceExpand
              }"
            >
              <div class="overflow-hidden">
                <p class="text-sm">
                  {{ ticketItem.spot_introduce }}
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="p-4 bg-gray-100 mt-2 -mx-4 mb-20 border-b-2 border-b-gray-300">
        <p class="font-bold">使用說明</p>
        <ul class="pl-4 mt-2 flex flex-col gap-y-1">
          <li v-for="text in ticketItem.instructions" :key="text" class="list-decimal text-sm">
            {{ text }}
          </li>
        </ul>
      </div>
    </section>
    <div class="fixed bottom-0 left-0 w-screen p-4 bg-white flex justify-center">
      <BaseButton :disabled="!ticketItem?.purchase_link" class="w-full" @click="onPurchaseClick">
        立即購票
      </BaseButton>
    </div>
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
