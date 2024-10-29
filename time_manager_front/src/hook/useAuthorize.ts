import { userRank } from "@/dto/user";
import { IsLogged, useAuthStore } from "@/store/AuthStore";
import { ref } from "vue";

export const useAuthorize = () => {
  const loading = ref(true);

  const isAuthorize = (rank: userRank | Array<userRank>): boolean => {
    const auth = useAuthStore();
    let user = auth.user;
    auth.$subscribe(
      (mutation, state) => {
        if (state.isLogged === IsLogged.Logged) user = state.user;
      },
      { detached: true }
    );

    if (Array.isArray(rank) && user) {
      return rank.includes(user?.rank);
    }

    return rank === user?.rank;
  };

  return { isAuthorize, loading };
};
