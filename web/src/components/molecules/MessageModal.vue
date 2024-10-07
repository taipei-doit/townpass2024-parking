<template>
  <transition name="modal">
    <div class="modal-mask" v-if="isShow">
      <div class="modal-wrapper">
        <div class="modal-container">
          <div class="modal-header">
            <slot name="header"> default header </slot>
          </div>

          <div class="modal-body">
            <slot name="body"> default body </slot>
          </div>

          <div class="modal-footer">
            <slot name="footer">
              <!-- <Button @click="$emit('confirm')"> 確認 </Button> -->
            </slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script setup lang="ts">
import { defineComponent } from 'vue';

const props = defineProps({
  isShow: {
    type: Boolean,
    default: false
  }
});

defineComponent({
  name: 'MessageModalComponent'
});
</script>

<style lang="postcss" scoped>
.modal-mask {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: table;
  transition: opacity 0.3s ease;
}

.modal-wrapper {
  display: table-cell;
  vertical-align: middle;
}

.modal-container {
  width: 300px;
  margin: 0px auto;
  background-color: #fff;
  border-radius: 6px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
  transition: all 0.3s ease;
}

.modal-body {
  margin: 20px 30px;
}

.modal-header {
  @apply text-primary-500;
  @apply text-xl;
  @apply font-bold;
  padding: 20px 30px 0;
}

.modal-header,
.modal-body,
.modal-footer {
  text-align: center;
}

.modal-footer {
  @apply border-t border-t-gray-200;
  display: flex;
  justify-content: space-around;
}

/*
 * The following styles are auto-applied to elements with
 * transition="modal" when their visibility is toggled
 * by Vue.js.
 *
 * You can easily play with the modal transition by editing
 * these styles.
 */

.modal-enter {
  opacity: 0;
}

.modal-leave-active {
  opacity: 0;
}

.modal-enter .modal-container,
.modal-leave-active .modal-container {
  -webkit-transform: scale(1.1);
  transform: scale(1.1);
}
</style>
