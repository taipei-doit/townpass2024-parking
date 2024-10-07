<script setup lang="ts">
import { computed } from 'vue';

const props = withDefaults(defineProps<{ stepCount?: number; activeStep: number }>(), {
  stepCount: 2,
  activeStep: 1
});

const connetcLineWidth = computed(() =>
  window ? (window.innerWidth - 32 - 56) / (props.stepCount - 1) : 0
);
</script>

<template>
  <div class="relative flex justify-between">
    <div
      v-for="step in props.stepCount"
      :key="step"
      class="step"
      :class="{ 'step--active': props.activeStep >= step }"
    >
      <span>{{ step }}</span>
      <div
        v-if="step !== props.stepCount"
        class="connect-line"
        :class="{ 'connect-line--active': step <= activeStep - 1 }"
        :style="{ width: `${connetcLineWidth}px` }"
      />
    </div>
  </div>
</template>

<style lang="postcss">
.step {
  @apply relative;
  @apply text-white;
  @apply bg-grey-700;
  @apply rounded-full;
  @apply w-7 h-7;
  @apply flex justify-center items-center;
  @apply z-20;

  &--active {
    @apply bg-primary-500;
  }
}

.connect-line {
  @apply absolute top-1/2 -translate-y-1/2 left-7;
  @apply h-0.5;
  @apply bg-grey-100;
  @apply z-10;

  &--active {
    @apply bg-primary-500;
  }
}
</style>
