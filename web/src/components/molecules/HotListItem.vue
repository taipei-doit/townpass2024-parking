<script setup lang="ts">
import { computed } from 'vue';
import BaseCardlabel from '@/components/atoms/BaseCardlabel.vue';
import { CardLabelType } from '@/components/atoms/BaseCardlabel.vue';
import type { Ticket, Coupon } from '@/views/CouponView.vue';

const props = defineProps<{
  item: Ticket | Coupon;
}>();

const textContentMaxWidth = computed(() => (window ? window.innerWidth - 32 : '0'));
</script>

<template>
  <RouterLink
    :to="{
      name: 'type' in props.item ? 'ticket-detail' : 'coupon-detail',
      params: { id: props.item.id },
      query: { tab: 'type' in props.item ? '1' : '2' }
    }"
    class="block"
  >
    <div
      class="hot-list-item-image-block"
      :style="{
        'background-image': `url(
                    ${props.item.img_url}
                  )`
      }"
    >
      <p v-if="'type' in props.item && props.item.type" class="text-white">
        | {{ props.item.name }} | {{ props.item.type }}
      </p>
      <p v-else class="text-white">{{ props.item.name }}</p>
      <BaseCardlabel
        v-if="props.item.vip_text"
        :title="props.item.vip_text"
        :label-type="CardLabelType.VIP"
        class="absolute top-3 -right-2"
      />
      <BaseCardlabel
        v-if="props.item.discount_text"
        :title="props.item.discount_text"
        :label-type="CardLabelType.DISCOUNT"
        class="absolute top-10 -right-2"
        :class="{ 'top-3': !props.item.vip_text }"
      />
    </div>
    <div class="p-2 text-sm" :style="{ maxWidth: `${textContentMaxWidth}px` }">
      <p class="text-ellipsis overflow-hidden whitespace-nowrap">
        {{ props.item.text }}
      </p>
      <p v-if="'price' in props.item && props.item.price" class="text-primary-500 font-bold">
        NT$ {{ props.item.price }}起
      </p>
      <div v-else-if="'deadline' in props.item" class="text-gray-400 text-sm mt-2">
        <span> {{ props.item.deadline }} 截止 </span>
        <span v-if="props.item.remaining">| 剩餘張數:{{ props.item.remaining }}份</span>
      </div>
    </div>
  </RouterLink>
</template>

<style lang="postcss">
.hot-list-item-image-block {
  @apply relative;
  @apply bg-cover bg-no-repeat bg-center;
  @apply h-32 rounded-t-md;
  @apply flex items-end;
  @apply px-4 py-2;
  @apply font-bold;
}
</style>
