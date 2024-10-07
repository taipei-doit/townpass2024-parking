import { ref } from 'vue';
import { defineStore } from 'pinia';

export const useFormStore = defineStore('form', () => {
  const formFormat = ref<any>();

  const fileList = ref<File[]>([]);

  const reset = () => {
    formFormat.value = undefined;
    fileList.value = [];
  };

  return { formFormat, fileList, reset };
});
