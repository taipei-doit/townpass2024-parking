import { ref } from 'vue';
import { defineStore } from 'pinia';

export interface User {
  id: string;
  account: string;
  username: string;
  realName: string;
  idNo: string;
  email: string;
  phoneNo: string;
  birthday: string;
  memberType: string;
  verifyLevel: string;
  addresses: {
    zip3: number;
    city: string;
    town: string;
    village: string;
    street: string;
  }[];
  residentAddress: string;
  citizen: boolean;
  nativePeople: boolean;
  cityInternetUid: string;
}

export const useUserStore = defineStore('user', () => {
  const user = ref<User>();

  return { user };
});
