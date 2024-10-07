<script setup lang="ts">
import { ref, computed, reactive, watch } from 'vue';
import BaseInput from '@/components/atoms/BaseInput.vue';
import BaseSelect from '@/components/atoms/BaseSelect.vue';
import { city } from '@/zipcode/city';
import { county } from '@/zipcode/county';

export interface BasicForm {
  mail: string;
  city: string;
  county: string;
  address: string;
}

const props = withDefaults(
  defineProps<{
    triggerValidate?: boolean;
  }>(),
  {
    triggerValidate: false
  }
);

const emit = defineEmits(['onFormChange']);

const isExpand = ref(true);

const form = reactive<BasicForm>({
  mail: '',
  county: '',
  city: '',
  address: ''
});

watch(
  () => form,
  () => {
    const isValidate = Object.keys(form).every((key) => {
      const value = form[key as keyof BasicForm];

      return !!value;
    });

    emit('onFormChange', {
      isValidate,
      form
    });
  },
  { deep: true }
);

const countyOptions = computed(() => county.map((item) => ({ label: item.name, value: item.id })));

const cityOptions = computed(() =>
  form.county
    ? city
        .filter((item) => item.county === form.county)
        .map((item) => ({ label: item.city, value: item.city }))
    : []
);

watch(
  () => form.county,
  () => {
    form.city = '';
  },
  { deep: true }
);
</script>

<template>
  <section>
    <div class="py-5 px-4">
      <button
        class="w-full flex justify-between items-center"
        @click.prevent="isExpand = !isExpand"
      >
        <div class="flex items-end">
          <img src="@/assets/images/person-icon.svg" class="transition-transform" />
          <span class="text-primary-500 font-bold ml-2">基本資料</span>
        </div>
        <img
          src="@/assets/images/down-icon-primary.svg"
          class="transition-transform"
          :class="{
            'rotate-180': isExpand
          }"
        />
      </button>
      <div
        class="grid grid-rows-[0fr] transition-all"
        :class="{
          'grid-rows-[1fr]': isExpand
        }"
      >
        <div class="overflow-hidden flex flex-col gap-4 pt-5">
          <div class="flex flex-col">
            <label for="mail" class="field-label">
              電子信箱
              <span>*</span>
            </label>
            <BaseInput
              id="mail"
              class="w-full"
              placeholder="請輸入電子信箱"
              :required="true"
              :triggerValidate="props.triggerValidate"
              label="電子信箱"
              v-model="form.mail"
            />
          </div>
          <div class="flex flex-col">
            <label for="county" class="field-label">
              縣市
              <span>*</span>
            </label>
            <BaseSelect
              selectId="county"
              :options="countyOptions"
              :required="true"
              :triggerValidate="props.triggerValidate"
              default-selected="請選擇縣市"
              class="w-full"
              v-model="form.county"
            />
          </div>
          <div class="flex flex-col">
            <label for="city" class="field-label">
              鄉鎮(市)區
              <span>*</span>
            </label>
            <BaseSelect
              selectId="city"
              :options="cityOptions"
              :required="true"
              :triggerValidate="props.triggerValidate"
              default-selected="請選擇鄉鎮區"
              class="w-full"
              v-model="form.city"
            />
          </div>
          <div class="flex flex-col">
            <label for="address" class="field-label">
              通訊地址
              <span>*</span>
            </label>
            <BaseInput
              id="address"
              class="w-full"
              placeholder="請輸入通訊地址"
              :required="true"
              :triggerValidate="props.triggerValidate"
              label="通訊地址"
              v-model="form.address"
            />
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style lang="postcss">
.field-label {
  @apply text-grey-700 font-bold;
  @apply mb-2;

  & > span {
    @apply text-primary-500;
  }
}
</style>
