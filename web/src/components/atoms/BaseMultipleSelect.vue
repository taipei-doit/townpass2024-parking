<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import BaseInput from '@/components/atoms/BaseInput.vue';
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue';
import type { Option } from '@/components/atoms/BaseSelect.vue';

const props = defineProps<{
  defaultText: string;
  selectOptions?: Option[];
  required?: boolean;
  triggerValidate?: boolean;
}>();

const emit = defineEmits<{
  confirm: [checkedList: string[] | number[]];
  controlModal: [openModal: () => void];
}>();

const isOpen = ref(false);

const checkedList = ref<string[] | number[]>([]);

const selectOptionsMap = computed(
  () => new Map(props.selectOptions?.map((option) => [option.value, option.label]))
);

const openModal = () => {
  isOpen.value = true;
};

const onConfirmClick = () => {
  isOpen.value = false;
  emit('confirm', checkedList.value);
  emit('controlModal', openModal);
};

const isValidate = ref(true);

const validate = () => {
  isValidate.value = !!checkedList.value.length;
};

watch(
  () => props.triggerValidate,
  () => {
    validate();
  }
);
</script>

<template>
  <div
    v-show="!checkedList.length"
    class="base-select-wrapper base-multiple-select-wrapper"
    @click="isOpen = true"
  >
    <BaseInput
      v-bind:model-value="props.defaultText"
      readonly
      class="w-full"
      :class="{ 'base-input--warn': required && !isValidate }"
    ></BaseInput>
  </div>
  <div v-show="checkedList.length" class="flex flex-wrap">
    <p v-for="(value, index) in checkedList" :key="value">
      {{ selectOptionsMap.get(value.toString()) }}
      <span v-if="index !== checkedList.length - 1">,</span>
    </p>
  </div>
  <TransitionRoot appear :show="isOpen" as="template">
    <Dialog as="div" @close="isOpen = false" class="relative z-30">
      <div class="fixed inset-0">
        <div class="min-h-full">
          <TransitionChild
            as="template"
            enter="duration-300 ease-out"
            enter-from="opacity-0 scale-95"
            enter-to="opacity-100 scale-100"
            leave="duration-200 ease-in"
            leave-from="opacity-100 scale-100"
            leave-to="opacity-0 scale-95"
          >
            <DialogPanel
              class="w-full h-screen max-w-screen-md flex flex-col transform overflow-y-auto bg-white transition-all"
            >
              <div class="p-3 bg-grey-50">
                <DialogTitle as="p" class="font-bold text-grey-500"> 申訴項目(可多選) </DialogTitle>
              </div>

              <div class="mt-5 px-3 flex flex-col gap-3">
                <label
                  v-for="option in props.selectOptions"
                  :key="option.value"
                  :for="option.value"
                  class="flex justify-between"
                >
                  <input
                    v-model="checkedList"
                    type="checkbox"
                    :name="option.label"
                    :id="option.value"
                    :value="option.value"
                    class="multiple-checkbox"
                  />
                  <span class="font-semibold">{{ option.label }}</span>
                  <div class="relative">
                    <img src="@/assets/images/checkbox-default.svg" class="w-7 h-7" />
                    <img
                      src="@/assets/images/checkbox-checked.svg"
                      class="w-7 h-7 absolute inset-0 opacity-0"
                    />
                  </div>
                </label>
              </div>

              <div class="mt-auto bg-grey-50 p-2">
                <button
                  type="button"
                  class="flex justify-center rounded-md bg-primary-500 text-white font-bold w-full py-3"
                  @click="onConfirmClick"
                >
                  確認
                </button>
              </div>
            </DialogPanel>
          </TransitionChild>
        </div>
      </div>
    </Dialog>
  </TransitionRoot>
</template>

<style lang="postcss">
.base-multiple-select-wrapper {
  @apply after:-rotate-90;
}

.multiple-checkbox {
  @apply w-0 h-0 opacity-0 absolute;

  &:checked {
    & + span {
      @apply text-primary-500;
    }

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
