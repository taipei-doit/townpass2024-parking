<script setup lang="ts">
import { ref, reactive, onMounted, watch, computed } from 'vue';
import { storeToRefs } from 'pinia';
import BaseInput from '@/components/atoms/BaseInput.vue';
import BaseSelect from '@/components/atoms/BaseSelect.vue';
import BaseMultipleSelect from '@/components/atoms/BaseMultipleSelect.vue';
import BaseTextarea from '@/components/atoms/BaseTextarea.vue';
import BaseRadio from '@/components/atoms/BaseRadio.vue';
import BaseCheckbox from '@/components/atoms/BaseCheckbox.vue';
import DatePicker from '@/components/molecules/DatePicker.vue';
// import UploadSection from '@/components/molecules/UploadSection.vue';
import { useFormStore } from '@/stores/form';

const props = withDefaults(
  defineProps<{
    triggerValidate?: boolean;
  }>(),
  {
    triggerValidate: false
  }
);

const emit = defineEmits(['onFormChange']);

const store = useFormStore();

const { formFormat } = storeToRefs(store);

const isExpand = ref(true);

const formValidateFieldMap = computed(
  () =>
    new Map(
      formFormat.value.data.form_format.map((item: { field: any; required: any }) => [
        item.field,
        item.required
      ])
    )
);

const openMultipleModalList = ref<any>([]);

const form = reactive<any>({});

const insertOpenMultipleModal = (el: () => void, index: number) => {
  if (openMultipleModalList.value.length >= index + 1) {
    openMultipleModalList.value.splice(index, 1, el);
  } else {
    while (openMultipleModalList.value.length < index + 1) {
      openMultipleModalList.value.push(undefined);
    }

    openMultipleModalList.value.splice(index, 1, el);
  }
};

const onMultipleChangeClick = (index: number) => {
  openMultipleModalList.value[index]();
};

const handleForm = () => {
  formFormat.value.data.form_format.forEach((item: any) => {
    switch (item.type) {
      case 'input':
        form[item.field] = '';
        break;
      case 'select':
        form[item.field] = '';
        break;
      case 'multiple_select':
        form[item.field] = [];
        break;
      case 'radio_group':
        form[item.field] = '';
        break;
      case 'textarea':
        form[item.field] = '';
        break;
      case 'checkbox_group':
        form[item.field] = [];
        break;
      case 'date_picker':
        form[item.field] = undefined;
        break;
      // case 'upload':
      //   form[item.field] = [];
      //   break;
      default:
        form[item.field] = '';
    }
  });
};

onMounted(() => {
  handleForm();
});

watch(
  () => form,
  () => {
    const isValidate = Object.keys(form)
      .filter((key) => formValidateFieldMap.value.get(key))
      .every((key) => {
        const value = Array.isArray(form[key]) ? form[key].length : form[key];

        return !!value;
      });

    emit('onFormChange', {
      isValidate,
      form
    });
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
          <span class="text-primary-500 font-bold ml-2">申辦服務資料</span>
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
          <!-- 這邊開始透過 API 的 form format 來組成 -->
          <div v-for="(item, index) in formFormat.data.form_format" :key="index">
            <!-- type = input -->
            <div v-if="item.type === 'input'" class="flex flex-col">
              <label :for="item.field" class="field-label">
                {{ item.label }}
                <span v-if="item.required">*</span>
              </label>
              <BaseInput
                v-model="form[item.field]"
                :id="item.field"
                class="w-full"
                :label="item.label"
                :triggerValidate="props.triggerValidate"
                :required="true"
                :placeholder="`請輸入${item.label}`"
              />
            </div>
            <!-- type = select -->
            <div v-else-if="item.type === 'select'" class="flex flex-col">
              <label :for="item.field" class="field-label">
                {{ item.label }}
                <span v-if="item.required">*</span>
              </label>
              <BaseSelect
                v-model="form[item.field]"
                :selectId="item.field"
                :required="item.required"
                :options="item.options"
                :triggerValidate="props.triggerValidate"
                :default-selected="item.default_option"
                class="w-full"
              />
            </div>
            <!-- type = multiple_select -->
            <div v-else-if="item.type === 'multiple_select'" class="flex flex-col">
              <div class="flex items-center justify-between">
                <p class="field-label">
                  {{ item.label }}
                  <span v-if="item.required">*</span>
                </p>
                <button
                  v-show="form[item.field]?.length"
                  class="text-primary-500 underline decoration-primary-500 mb-2"
                  @click.prevent="onMultipleChangeClick(index)"
                >
                  變更
                </button>
              </div>

              <BaseMultipleSelect
                :selectOptions="item.options"
                :defaultText="`請選擇${item.label}`"
                :required="item.required"
                :triggerValidate="props.triggerValidate"
                @confirm="(el) => (form[item.field] = el)"
                @controlModal="(el) => insertOpenMultipleModal(el, index)"
              />
            </div>
            <!-- type = textarea -->
            <div v-else-if="item.type === 'textarea'" class="flex flex-col">
              <label :for="item.field" class="field-label">
                {{ item.label }}
                <span v-if="item.required">*</span>
              </label>
              <BaseTextarea
                v-model="form[item.field]"
                :id="item.field"
                :label="item.label"
                :required="item.required"
                :triggerValidate="props.triggerValidate"
                class="w-full"
                placeholder="人、事、時、地、物 4000字以內"
              />
            </div>
            <!-- type = radio_group -->
            <div v-else-if="item.type === 'radio_group'" class="flex flex-col">
              <p class="field-label">
                {{ item.label }}
                <span v-if="item.required">*</span>
              </p>
              <div class="flex flex-wrap gap-4">
                <BaseRadio
                  v-model="form[item.field]"
                  v-for="option in item.options"
                  :key="option.value"
                  :radioId="option.value"
                  :radioName="item.field"
                  :radioText="option.label"
                  :required="item.required"
                  :triggerValidate="props.triggerValidate"
                />
              </div>
            </div>
            <!-- type = checkbox_group -->
            <div v-else-if="item.type === 'checkbox_group'" class="flex flex-col">
              <p class="field-label">{{ item.label }}<span v-if="item.required">*</span></p>
              <div class="flex flex-wrap gap-1.5">
                <BaseCheckbox
                  v-for="option in item.options"
                  :key="option.value"
                  :option="option"
                  :required="item.required"
                  :triggerValidate="props.triggerValidate"
                  v-model="form[item.field]"
                />
              </div>
            </div>
            <!-- type = date_picker -->
            <div v-else-if="item.type === 'date_picker'" class="flex flex-col">
              <p class="field-label">{{ item.label }}<span v-if="item.required">*</span></p>
              <DatePicker
                v-model="form[item.field]"
                :required="item.required"
                :triggerValidate="props.triggerValidate"
              />
            </div>
            <!-- type = upload -->
            <!-- TODO: 等 API 再來決定要給 form 什麼 -->
            <!-- DOC: 上傳先拿掉 -->
            <!-- <UploadSection
              v-else-if="item.type === 'upload'"
              :file-max="item.upload_max_files"
              :title="item.label"
              :required="item.required"
              :triggerValidate="props.triggerValidate"
            /> -->
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
