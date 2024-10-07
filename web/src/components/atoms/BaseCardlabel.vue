<script lang="ts">
export enum CardLabelType {
  DISCOUNT = 'discount',
  VIP = 'vip'
}
</script>

<script setup lang="ts">
const props = defineProps<{
  labelType: CardLabelType;
  title: String;
}>();
</script>

<template>
  <div
    class="base-card-label"
    :class="{
      'base-card-label--discount': props.labelType === CardLabelType.DISCOUNT,
      'base-card-label--vip': props.labelType === CardLabelType.VIP
    }"
  >
    <span>{{ props.title }}</span>
  </div>
</template>

<style lang="postcss">
.base-card-label {
  @apply p-0.5 text-white text-sm;
  @apply after:content-[''] after:absolute after:-bottom-2 after:right-0;
  @apply after:border-t-4 after:border-b-4 after:border-l-4 after:border-r-4;
  @apply after:border-b-transparent after:border-r-transparent;

  &--discount {
    @apply bg-orange-500;
    @apply after:border-t-orange-800 after:border-l-orange-800;
  }

  &--vip {
    @apply bg-primary-500;
    @apply after:border-t-primary-800 after:border-l-primary-800;
  }
}
</style>

