<script setup lang="ts">
import { computed } from 'vue';
import { ref } from 'vue';
import qnaListJson from '../../public/mock/qna_list.json';
import BaseButton from '@/components/atoms/BaseButton.vue';
import { useRouter } from 'vue-router';

const router = useRouter();

const topQnAList = computed(() => {
  const list = qnaListJson.data.flatMap((item) => item.list);
  return list.filter((item) => item.is_show_front_page);
});
const expandList = ref<string[]>([]);
const expandListSet = computed(() => new Set(expandList.value.map((name) => name)));

const onPanelExpandClick = (id: string) => {
  if (expandListSet.value.has(id)) {
    expandList.value = []; // 清空展開列表
  } else {
    expandList.value = [id]; // 只保留當前點擊的項目
  }
};
</script>

<template>
  <div class="p-5 qna-wrapper">
    <h5 class="text-primary-500 mb-10 text-[32px] font-bold title">Q & A • 常見問題</h5>
    <div class="w-full flex flex-col overflow-y-auto">
      <ul class="mb-6">
        <li
          class="text-primary-500 border-b border-gray-300"
          v-for="item in topQnAList"
          :key="item.id"
          :class="{
            'bg-grey-50 pt-4': expandListSet.has(item.name),
            'py-4': !expandListSet.has(item.name)
          }"
        >
          <button
            class="w-full flex justify-between items-start text-grey-700 font-bold text-left"
            :class="{
              'pb-4': expandListSet.has(item.id)
            }"
            @click="onPanelExpandClick(item.id)"
          >
            <img src="@/assets/images/icon-faq.svg" class="transition-transform mr-2" />
            <div class="flex-1 text-primary-500">{{ item.name + item.name_en }}</div>
            <img
              src="@/assets/images/down-icon.svg"
              class="transition-transform ml-2"
              :class="{
                'rotate-180': expandListSet.has(item.id)
              }"
            />
          </button>
          <div
            class="grid grid-rows-[0fr] transition-all"
            :class="{
              'grid-rows-[1fr]': expandListSet.has(item.id)
            }"
          >
            <div class="overflow-hidden text-grey-700 px-5">
              <p class="whitespace-pre-line" v-html="item.content"></p>
              <p class="whitespace-pre-line" v-html="item.content_en"></p>
            </div>
          </div>
        </li>
      </ul>
      <BaseButton shape="rounded" @click="router.push(`/qna/categories`)">
        <span>查看其他常見問題</span>
      </BaseButton>
    </div>
  </div>
</template>

<style lang="postcss">
.qna-wrapper {
  background-image: url('@/assets/images/bg-one.svg');
  background-size: 80%;
  background-position: -150% 0;
}

.title {
  position: relative;
  display: inline-block;
}

.title::after {
  content: '';
  display: block;
  width: 20%;
  height: 3px; /* 底線的粗細 */
  background-color: currentColor;
  position: absolute;
  left: 0;
  bottom: -5px; /* 根據需要調整底線與標題之間的距離 */
}
</style>
