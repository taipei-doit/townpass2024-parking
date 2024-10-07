<script setup lang="ts">
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue';

const props = defineProps<{
  title?: string;
  content: string;
  negativeText?: string;
  positiveText?: string;
  isAlert?: boolean;
  isCheck?: boolean;
}>();

const emit = defineEmits(['onPositiveClick', 'onNegativeClick']);

const isOpen = defineModel({ default: false });

const setIsOpen = () => {
  isOpen.value = true;
};

const onPositiveClick = () => {
  isOpen.value = false;
  emit('onPositiveClick');
};

const onNegativeClick = () => {
  isOpen.value = false;
  emit('onNegativeClick');
};
</script>

<template>
  <TransitionRoot appear :show="isOpen" as="template">
    <Dialog as="div" :open="isOpen" @close="setIsOpen" class="relative z-30">
      <div class="fixed inset-0 bg-black/25">
        <div class="min-h-full flex justify-center items-center">
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
              class="w-4/5 max-w-screen-md flex flex-col transform overflow-y-auto bg-white transition-all rounded pt-4"
            >
              <div v-if="props.isAlert" class="flex justify-center">
                <img src="@/assets/images/alert-icon.svg" class="w-24" />
              </div>
              <div v-else-if="props.isCheck" class="flex justify-center">
                <img src="@/assets/images/check-icon.svg" class="w-24" />
              </div>
              <DialogTitle v-if="props.title" class="text-xl text-center font-extrabold">
                {{ title }}
              </DialogTitle>

              <div class="px-4 my-5">
                <p class="text-center font-bold">{{ props.content }}</p>
              </div>

              <div
                class="mt-auto py-1 border-t-gray-200 border-t"
                :class="{ 'grid grid-cols-2': negativeText }"
              >
                <button
                  v-if="props.negativeText"
                  type="button"
                  class="flex justify-center text-gray-500 font-bold w-full py-1 outline-none"
                  @click="onNegativeClick"
                >
                  {{ negativeText }}
                </button>
                <button
                  type="button"
                  class="flex justify-center text-primary-500 font-bold w-full py-1 outline-none"
                  @click="onPositiveClick"
                >
                  {{ positiveText || '確認' }}
                </button>
              </div>
            </DialogPanel>
          </TransitionChild>
        </div>
      </div>
    </Dialog>
  </TransitionRoot>
</template>
