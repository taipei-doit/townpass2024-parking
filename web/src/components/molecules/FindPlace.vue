<script setup lang="ts">
import { ref, watch, computed } from 'vue';
import MessageModal from '@/components/molecules/MessageModal.vue';
import placeListJson from '../../../public/mock/place_list.json';

export interface Place {
  id: string;
  name: string;
  icon: string;
  agency: string;
  type: string;
  data_type?: 'api' | 'json' | 'csv';
  request_url: string;
  data_path: string;
  format_fields?: {
    id: string;
    name: string;
    area: string;
    address: string;
    lat: string;
    lng: string;
  };
  service_infos?: ServiceInfo[];
}

export interface ServiceInfo {
  title: string;
  value_fields?: ValueField[];
  value_field?: string;
}

export interface ValueField {
  title: string;
  value_field: string;
}

const emit = defineEmits(['onSearchChange', 'update:isExpand']);

const searchValue = ref('');

/** 搜尋紀錄列表 */
const searchHistoryList = ref<{ name: string; places: Place[] }[]>([
  {
    name: '搜尋紀錄',
    places: []
  }
]);
/** 服務列表 */
const placeList = ref(placeListJson);
const places = computed(() => placeList.value.list.map((category) => category.places).flat());
/** 服務列表下拉選單 */
const options = computed(() => {
  return placeList.value.list
    .map((category) => category.places) // 提取所有的places陣列
    .flat() // 將所有的places合併為一個陣列
    .map((place) => ({
      label: place.name,
      value: place.id
    }));
});

const expandList = ref<string[]>([]);
const expandListSet = computed(() => new Set(expandList.value.map((name) => name)));

/**
 * 是否顯示清空歷史搜尋紀錄通知
 */
let isShowClearHistory = ref(false);

const onPanelExpandClick = (name: string) => {
  if (expandListSet.value.has(name)) {
    const index = expandList.value.findIndex((el) => el === name);
    expandList.value.splice(index, 1);
  } else {
    expandList.value.push(name);
  }
};

const isExpand = ref(false);
const toggleExpand = () => {
  isExpand.value = !isExpand.value;
};

const clearHistoryListClick = (e: any) => {
  e.preventDefault();
  isShowClearHistory.value = false;
  searchHistoryList.value[0].places = [];
};

watch([isExpand, searchValue], ([newExpandValue, newSearchValue]) => {
  const selectedSearchData = places.value.find((place) => place.id === newSearchValue);
  emit('update:isExpand', newExpandValue);
  emit('onSearchChange', selectedSearchData);
});

const onSelect = (place: Place) => {
  searchValue.value = place.id;

  // 檢查是否已經存在具有相同 id 的 place
  const isPlaceExist = searchHistoryList.value[0].places.some((p) => p.id === place.id);
  // 如果不存在，才推入
  if (!isPlaceExist) {
    searchHistoryList.value[0].places.unshift(place);
  }

  toggleExpand();
};
</script>

<template>
  <section class="relative flex flex-col flex-1">
    <div class="py-5 pl-4 pr-2">
      <div class="base-select-wrapper" :class="{ expanded: isExpand }">
        <select
          v-bind="$attrs"
          id="findPlace"
          v-model="searchValue"
          class="base-select"
          @mousedown.prevent="toggleExpand"
        >
          <option value="" selected>請選擇要找的服務地圖</option>
          <option v-for="option in options" :key="option.value" :value="option.value">
            {{ option.label }}
          </option>
        </select>
      </div>
    </div>
    <template v-if="isExpand">
      <div class="w-full flex flex-col overflow-y-auto">
        <ul>
          <template v-if="searchHistoryList[0].places.length">
            <li
              class="text-primary-500 bg-primary-50"
              v-for="item in searchHistoryList"
              :key="item.name"
              :class="{
                'bg-grey-50 pt-4': expandListSet.has(item.name),
                'py-4': !expandListSet.has(item.name)
              }"
            >
              <button
                class="px-4 w-full flex justify-between items-center text-grey-700 font-bold"
                :class="{
                  'pb-4': expandListSet.has(item.name)
                }"
                @click="onPanelExpandClick(item.name)"
              >
                <span>{{ item.name }}</span>
                <div class="flex items-center">
                  <a
                    href="javascript:void(0)"
                    v-if="expandListSet.has(item.name)"
                    class="mr-2 underline text-primary-500"
                    @click="
                      (event: any) => {
                        event.stopPropagation();
                        isShowClearHistory = true;
                      }
                    "
                  >
                    清空
                  </a>
                  <img
                    src="@/assets/images/down-icon.svg"
                    class="transition-transform"
                    :class="{
                      'rotate-180': expandListSet.has(item.name)
                    }"
                  />
                </div>
              </button>
              <div
                class="grid grid-rows-[0fr] transition-all"
                :class="{
                  'grid-rows-[1fr]': expandListSet.has(item.name)
                }"
              >
                <ul class="overflow-hidden">
                  <li v-for="place in item.places" :key="place.name" class="px-4 bg-grey-50">
                    <div
                      class="flex items-center py-5 px-4 border-b border-grey-200"
                      @click="onSelect(place)"
                    >
                      <img src="@/assets/images/icon-history.svg" class="w-6 h-6 mr-2" />
                      <span class="text-grey-700">
                        {{ place.name }}
                      </span>
                    </div>
                  </li>
                </ul>
              </div>
            </li>
          </template>
          <li
            class="py-5 px-4 text-primary-500 bg-primary-50"
            v-if="!searchHistoryList[0].places.length"
          >
            無搜尋紀錄
          </li>
          <li class="py-5 px-4 bg-orange-100">防空避難設備</li>
          <li
            v-for="item in placeList.list"
            :key="item.name"
            :class="{
              'bg-grey-50 pt-4': expandListSet.has(item.name),
              'bg-white py-4': !expandListSet.has(item.name)
            }"
          >
            <button
              class="px-4 w-full flex justify-between items-center text-grey-700 font-bold"
              @click="onPanelExpandClick(item.name)"
            >
              <span>{{ item.name }}</span>
              <img
                src="@/assets/images/down-icon.svg"
                class="transition-transform"
                :class="{
                  'rotate-180': expandListSet.has(item.name)
                }"
              />
            </button>
            <div
              class="grid grid-rows-[0fr] transition-all"
              :class="{
                'grid-rows-[1fr]': expandListSet.has(item.name)
              }"
            >
              <ul class="overflow-hidden">
                <li v-for="place in item.places" :key="place.name" class="px-4">
                  <div
                    class="flex items-center py-5 px-4 border-b border-grey-200"
                    @click="onSelect(place)"
                  >
                    <img v-if="place.icon" :src="place.icon" class="w-6 h-6 mr-2" />
                    <span class="text-grey-700">
                      {{ place.name }}
                    </span>
                  </div>
                </li>
              </ul>
            </div>
          </li>
        </ul>
      </div>
    </template>
  </section>

  <!-- clear search history modal -->
  <MessageModal :is-show="isShowClearHistory">
    <template #header>
      <p>清空搜集紀錄</p>
    </template>
    <template #body>
      <p class="text-grey-700">清空您的歷史搜尋紀錄</p>
    </template>
    <template #footer>
      <button
        class="text-gray-500 px-7 py-2 w-full border-r border-t-gray-200"
        @click="isShowClearHistory = false"
      >
        取消
      </button>
      <button
        class="text-primary-500 px-7 py-2 w-full"
        @click="
          () => {
            isShowClearHistory = false;
            searchHistoryList[0].places = [];
          }
        "
      >
        確認
      </button>
    </template>
  </MessageModal>
</template>
<style lang="postcss" scoped>
.base-select-wrapper {
  @apply relative;
  @apply after:content-[''] after:w-6 after:h-6;
  @apply after:bg-[url('@/assets/images/down-icon.svg')] after:bg-cover after:bg-no-repeat;
  @apply after:block after:absolute after:top-1/2 after:-translate-y-1/2 after:right-2;

  &.expanded {
    @apply after:rotate-180;
  }
}
</style>
