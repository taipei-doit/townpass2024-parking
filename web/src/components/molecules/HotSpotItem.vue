<script setup lang="ts">
import { defineProps } from 'vue';

const props = defineProps<{
  name: string;
  introduce: string;
  img_url: string;
  business_hours: string[];
}>();
</script>

<template>
  <div class="grid grid-cols-4">
    <img :src="props.img_url" :alt="props.name" class="rounded-full w-20 h-20 object-cover" />
    <div class="col-span-3 pl-1">
      <p class="font-bold">{{ props.name }}</p>
      <p class="text-ellipsis overflow-hidden whitespace-nowrap">{{ props.introduce }}</p>
      <p class="text-ellipsis overflow-hidden whitespace-nowrap text-gray-500 text-sm mt-2">
        {{ props.business_hours[0] }}
      </p>
    </div>
  </div>
</template>
