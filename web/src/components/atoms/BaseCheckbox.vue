<script setup lang="ts">
import { ref, watch } from 'vue';
import type { Option } from '@/components/atoms/BaseSelect.vue';

const props = defineProps<{
  option: Option;
  required?: boolean;
  triggerValidate?: boolean;
}>();

const inputValue = defineModel({ default: [] });

const isValidate = ref(true);

const validate = () => {
  isValidate.value = !!inputValue.value.length;
};

watch(
  () => props.triggerValidate,
  () => {
    validate();
  }
);

const isInit = ref(false);

watch(
  () => inputValue.value,
  () => {
    if (!isInit.value) {
      isInit.value = true;
    } else {
      validate();
    }
  }
);
</script>

<template>
  <label :for="props.option.label" class="flex items-center">
    <input
      type="checkbox"
      name=""
      :id="props.option.value"
      :value="props.option.value"
      class="base-checkbox"
      v-model="inputValue"
    />
    <div class="relative mr-1">
      <img v-if="required && !isValidate" src="@/assets/images/checkbox-warn.svg" class="w-5 h-5" />
      <template v-else>
        <img src="@/assets/images/checkbox-default.svg" class="w-5 h-5" />
        <img
          src="@/assets/images/checkbox-checked.svg"
          class="w-5 h-5 absolute inset-0 opacity-0"
        />
      </template>
    </div>
    <span>{{ props.option.label }}</span>
  </label>
</template>

<style lang="postcss">
.base-checkbox {
  @apply w-0 h-0 opacity-0 absolute;

  &:checked {
    & ~ div {
      & > img {
        &:first-child {
          @apply opacity-0;
          @apply transition-opacity;
        }

        &:last-child {
          @apply opacity-100;
          @apply transition-opacity;
        }
      }
    }
  }
}
</style>
