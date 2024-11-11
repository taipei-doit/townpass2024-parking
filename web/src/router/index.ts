import { createRouter, createWebHistory } from 'vue-router';
import ParkingService from '@/views/ParkingService.vue';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: ParkingService
    }
  ]
});

export default router;
