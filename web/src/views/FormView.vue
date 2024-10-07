<script setup lang="ts">
import { ref, watch } from 'vue';
import { storeToRefs } from 'pinia';
import ServiceStep from '@/components/molecules/ServiceStep.vue';
import GeneralInfoForm from '@/components/molecules/GeneralInfoForm.vue';
import ApplyServiceInfoForm from '@/components/molecules/ApplyServiceInfoForm.vue';
import BaseButton from '@/components/atoms/BaseButton.vue';
import FormPreview from '@/components/organisms/FormPreview.vue';
import type { BasicForm } from '@/components/molecules/GeneralInfoForm.vue';
import { useFormStore } from '@/stores/form';
import { useUserStore } from '@/stores/user';
import formJSON from '../../public/mock/form.json';

const triggerValidate = ref(false);

const store = useFormStore();

const { formFormat } = storeToRefs(store);

formFormat.value = formJSON;

const userStore = useUserStore();

const { user } = storeToRefs(userStore);

const basicForm = ref<{
  form: BasicForm;
  isValidate: boolean;
}>();

const applyServiceForm = ref<{
  form: any;
  isValidate: boolean;
}>();

const activeStep = ref(1);

const submitForm = ref();

const onSubmitClick = () => {
  triggerValidate.value = true;

  if (basicForm.value?.isValidate && applyServiceForm.value?.isValidate) {
    submitForm.value = Object.assign(basicForm.value.form, applyServiceForm.value.form);
    activeStep.value = 2;
  }
};

watch(activeStep, () => {
  if (window) {
    window.scrollTo({
      top: 0
    });
  }
});
</script>

<template>
  <div class="pb-8">
    <section class="bg-grey-50 px-4 pt-5 pb-4">
      <ServiceStep :activeStep="activeStep" />
      <p v-show="activeStep === 1" class="font-bold mt-4">
        Hi {{ user?.username }}，請填寫以下申辦資料
      </p>
    </section>
    <form v-show="activeStep === 1" @submit.stop="">
      <GeneralInfoForm
        :triggerValidate="triggerValidate"
        @onFormChange="(value) => (basicForm = value)"
      />
      <div class="w-full h-2 bg-grey-50"></div>
      <ApplyServiceInfoForm
        :triggerValidate="triggerValidate"
        @onFormChange="(value) => (applyServiceForm = value)"
      />
      <div class="grid grid-cols-2 gap-x-2 px-2">
        <BaseButton outline link :routeInfo="{ name: 'home' }">上一步</BaseButton>
        <BaseButton @click="onSubmitClick">下一步</BaseButton>
      </div>
    </form>
    <FormPreview v-if="activeStep === 2" :submit-form="submitForm" @onModify="activeStep = 1" />
  </div>
</template>
