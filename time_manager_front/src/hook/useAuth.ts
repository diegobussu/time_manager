import {useAuthStore} from "@/store/AuthStore";

export function useAuth() {

  const auth = useAuthStore();

  let isLogged = false;

  return {
    isLogged,
    ...auth,
  }

}