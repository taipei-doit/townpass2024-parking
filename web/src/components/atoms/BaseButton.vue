<script setup lang="ts">
import { RouterLink } from 'vue-router';
import type { RouteLocationRaw } from 'vue-router';
import { defineProps, defineEmits } from 'vue';

const props = withDefaults(
  defineProps<{
    outline?: boolean;
    link?: boolean;
    routeInfo?: RouteLocationRaw;
    disabled?: boolean;
    shape?: 'rounded' | 'rectangular';
  }>(),
  {
    shape: 'rectangular'
  }
);

const emit = defineEmits({
  click: null
});
</script>

<template>
  <RouterLink
    v-if="props.link && props.routeInfo"
    :to="props.routeInfo"
    :disabled="props.disabled"
    class="base-button text-center"
    :class="{ 'base-button--outline': props.outline, 'base-button--disabled': props.disabled }"
  >
    <slot />
  </RouterLink>
  <button
    v-else
    :disabled="props.disabled"
    class="base-button"
    :class="{
      'base-button--outline': props.outline,
      'base-button--disabled': props.disabled,
      'base-button--rounded': props.shape === 'rounded',
      'base-button--rectangular': props.shape === 'rectangular'
    }"
    @click.prevent="() => emit('click')"
  >
    <slot />
  </button>
</template>

<style lang="postcss">
.base-button {
  @apply outline-none;
  @apply rounded-lg;
  @apply bg-primary-500 text-white;
  @apply p-3;

  &--outline {
    @apply border border-primary-500;
    @apply bg-transparent text-primary-500;
  }

  &--disabled {
    @apply text-black bg-gray-300;
  }

  &--rounded {
    @apply rounded-full;
  }

  &--rectangular {
    @apply rounded-lg;
  }
}
</style>
