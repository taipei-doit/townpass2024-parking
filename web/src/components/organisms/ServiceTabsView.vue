<script setup lang="ts">
import ServiceTabs from '@/components/molecules/ServiceTabs.vue';
import type { TabsProps } from '@/components/molecules/ServiceTabs.vue';

const props = withDefaults(defineProps<TabsProps>(), {
  tabList: () => [
    {
      id: 1,
      title: '申辦'
    },
    {
      id: 2,
      title: '查詢'
    }
  ],
  contentType: false
});

const activeTab = defineModel({ default: 0 });
</script>

<template>
  <ServiceTabs v-model="activeTab" :tab-list="props.tabList" :contentType="props.contentType" />
  <section class="tab-view-container">
    <div
      v-for="(item, index) in props.tabList"
      :key="item.id"
      class="tab-view"
      :style="{ transform: `translate(calc(-100%*${activeTab}))` }"
    >
      <slot :name="`tab${index}`"> tab {{ item.title }} </slot>
    </div>
  </section>
</template>

<style lang="postcss">
.tab-view-container {
  @apply flex flex-nowrap overflow-x-hidden;
}

.tab-view {
  @apply flex-[0_0_100%];
  @apply transition-transform duration-300;
}
</style>
