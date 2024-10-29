import {ref} from "vue";
import {IsLogged, useAuthStore} from "@/store/AuthStore";
import {storeToRefs} from "pinia";

export function useLoading(defaultValue?: boolean) {

  const auth = useAuthStore();
  const {user} = storeToRefs(auth);
  const loading = ref<boolean>(defaultValue ?? true);

  const init = () => {
    if (defaultValue === undefined) {
      if (user?.value !== undefined) {
        loading.value = false;
      }
    }
  }

  init();

  const setLoading = (value: boolean) => {
    loading.value = value;
  }

  const toggleLoading = () => {
    loading.value = !loading.value;
  }

  auth.$subscribe((mutation, state) => {
    if (defaultValue === undefined && state.user !== undefined && state.isLogged !== IsLogged.Loading) {
      loading.value = false;
    }
  });

  return {
    loading,
    setLoading,
    toggleLoading,
  }

}