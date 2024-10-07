<script setup lang="ts">
import { ref, watch } from 'vue';
import { storeToRefs } from 'pinia';
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue';
import { useFormStore } from '@/stores/form';

const props = withDefaults(
  defineProps<{
    fileMax?: number;
    title?: string;
    required?: boolean;
    triggerValidate?: boolean;
  }>(),
  {
    fileMax: 1
  }
);

const store = useFormStore();

const { fileList } = storeToRefs(store);

const isOpen = ref(false);

const isShowSizeError = ref(false);

const bytesToMB = (bytes: number) => {
  const megabytes = bytes / (1024 * 1024);
  return parseFloat(megabytes.toFixed(2));
};

const createImgPreviewUrl = (img: File) => {
  return URL.createObjectURL(img);
};

const onFileUpload = (event: Event) => {
  const files = (event.target as HTMLInputElement).files;

  if (files?.length) {
    const file = files[0];

    const sizeMB = bytesToMB(file.size);

    if (sizeMB > 20) {
      isShowSizeError.value = true;
    } else {
      isShowSizeError.value = false;
      fileList.value.push(file);
      validate();
      // TODO: 將 file 傳給 API，並將 API 的 response 向外拋出給外面表單提交，API 可能會回傳檔案編號之類
    }
  }
};

const onCancelClick = (count: number) => {
  fileList.value.splice(count - 1, 1);
  validate();
};

const isValidate = ref(true);

const validate = () => {
  isValidate.value = !!fileList.value.length;
};

watch(
  () => props.triggerValidate,
  () => {
    validate();
  }
);
</script>

<template>
  <div>
    <div class="flex justify-between">
      <div>
        <p class="font-bold text-gray-800">{{ props.title || '新增附件' }}</p>
        <p class="text-sm text-gray-500">
          容量限制為20MB
          <span v-if="props.fileMax > 1">，最多{{ props.fileMax }}個檔案</span>
        </p>
      </div>
      <button @click.prevent="isOpen = true">
        <img src="@/assets/images/info-icon.svg" />
      </button>
    </div>

    <div class="flex flex-wrap gap-x-4 gap-y-2">
      <div v-for="count in props.fileMax" :key="count" class="mt-2">
        <label
          v-show="fileList.length === count - 1"
          :for="`upload-file-${count}`"
          class="upload-box"
          :class="{ 'upload-box--warn': required && !isValidate }"
        >
          <img src="@/assets/images/add-icon.svg" class="w-6 h-6" />

          <template v-if="props.fileMax > 1">
            <p>最多上傳</p>
            <p>{{ props.fileMax }}個檔案</p>
          </template>

          <p v-else class="mt-3">上傳附件</p>

          <input
            type="file"
            name="photo"
            :id="`upload-file-${count}`"
            accept=".jpg, .jpeg, .gif, .bmp, .png, .tif, .tiff, .doc, .docx, .xls, .xlsx, .txt, .pdf, .odf, .odg, .odp, .ods, .odt"
            class="absolute opacity-0 -z-10"
            @change="onFileUpload"
          />
        </label>

        <div v-show="fileList.length >= count" class="preview-box">
          <button class="absolute -top-3 -right-3" @click.prevent="onCancelClick(count)">
            <img src="@/assets/images/cancel-icon.svg" />
          </button>
          <img
            v-if="fileList[count - 1]?.type.includes('image')"
            :src="createImgPreviewUrl(fileList[count - 1])"
            class="w-24 h-24 object-cover"
          />
          <div v-else class="h-full flex justify-center items-center px-2">
            <p class="text-sm">{{ fileList[count - 1]?.name }}</p>
          </div>
        </div>
      </div>
    </div>
    <p v-show="isShowSizeError" class="text-warn-200 text-sm mt-2">檔案大小超過限制</p>
  </div>

  <TransitionRoot appear :show="isOpen" as="template">
    <Dialog as="div" @close="isOpen = false" class="relative z-30">
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
              <DialogTitle class="text-lg text-center font-extrabold">
                上傳檔案格式限制
              </DialogTitle>

              <div class="px-4 text-sm my-5">
                <p class="text-center font-bold">jpg,jpeg,gif,bmp,png,tif,tiff,doc,</p>
                <p class="text-center font-bold">docx,xls,xlsx,txt,pdf,odf,odg,odp,ods,odt</p>
                <p class="text-center font-extrabold">檔案大小：20MB</p>
              </div>

              <div class="mt-auto py-1 border-t-gray-200 border-t">
                <button
                  type="button"
                  class="flex justify-center text-primary-500 font-bold w-full py-1 outline-none"
                  @click="isOpen = false"
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
.upload-box {
  @apply flex flex-col items-center;
  @apply w-24 h-24 p-4;
  @apply rounded bg-gray-100;
  @apply text-sm font-semibold;

  &--warn {
    @apply border border-warn-200;
  }
}

.preview-box {
  @apply relative;
  @apply flex flex-col items-center;
  @apply w-24 h-24;
  @apply rounded bg-gray-100;
  @apply text-sm font-semibold;
}
</style>
