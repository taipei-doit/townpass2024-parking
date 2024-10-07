<script setup lang="ts">
import { ref, watch } from 'vue';

const props = defineProps<{
  required?: boolean;
  label?: string;
  triggerValidate?: boolean;
}>();

const inputValue = defineModel({ default: '' });

const isValidate = ref(true);

const validate = () => {
  isValidate.value = !!inputValue.value;
};

watch(
  () => props.triggerValidate,
  () => {
    validate();
  }
);
</script>

<template>
  <textarea
    v-model="inputValue"
    v-bind="$attrs"
    maxlength="4000"
    class="base-textarea"
    :class="{ 'base-textarea--warn': required && !isValidate }"
    @input="validate"
  />
  <p v-if="required && !isValidate" class="mt-2 text-right text-warn-200 text-sm">
    {{ props.label }}不能為空
  </p>
</template>

<style lang="postcss">
.base-textarea {
  @apply bg-gray-100 h-32;
  @apply p-3;
  @apply rounded-lg outline-none;
  @apply overflow-y-auto;

  &--warn {
    @apply border border-warn-200;
    @apply placeholder:text-warn-200;
  }
}
</style>
