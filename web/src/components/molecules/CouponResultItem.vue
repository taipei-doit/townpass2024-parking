<script setup lang="ts">
import { defineProps } from 'vue';
import type { Ticket, Coupon } from '@/views/CouponView.vue';

const props = defineProps<{
  item: Ticket | Coupon;
}>();
</script>

<template>
  <RouterLink
    :to="{
      name: 'type' in props.item ? 'ticket-detail' : 'coupon-detail',
      params: { id: props.item.id }
    }"
    class="grid grid-cols-3"
  >
    <img :src="props.item.img_url" :alt="props.item.name" class="w-full object-contain" />
    <div class="col-span-2 pl-3">
      <p
        v-if="'type' in props.item"
        class="font-bold text-ellipsis overflow-hidden whitespace-nowrap"
      >
        | {{ props.item.name }} | {{ props.item.type }}
      </p>
      <p v-else class="font-bold text-ellipsis overflow-hidden whitespace-nowrap">
        {{ props.item.name }}
      </p>
      <p class="text-ellipsis overflow-hidden whitespace-nowrap mt-1">{{ props.item.text }}</p>
      <p v-if="'deadline' in props.item" class="text-sm text-gray-400 mt-1">
        {{ props.item.deadline }} 截止
      </p>
      <p v-if="'price' in props.item && props.item.price" class="text-primary-500 text-sm mt-1">
        NT$ {{ props.item.price }} 起
      </p>
      <div class="text-xs mt-2 flex gap-x-2">
        <span
          v-if="props.item.vip_text"
          class="rounded text-white bg-primary-500 p-0.5 text-center"
        >
          {{ props.item.vip_text }}
        </span>
        <span
          v-if="props.item.discount_text"
          class="rounded text-white bg-orange-500 p-0.5 text-center"
        >
          {{ props.item.discount_text }}
        </span>
      </div>
    </div>
  </RouterLink>
</template>
