import { defineStore } from "pinia";
import { IUser } from "@/dto/user";
import userRepository from "@/repository/users";

const TOKEN_STORAGE_KEY = "access_token";

export enum IsLogged {
  Logged,
  Loading,
  NotLogged,
}

type AuthStoreType = {
  user?: IUser;
  isLogged: IsLogged;
  accessToken: string;
};

export const useAuthStore = defineStore("auth", {
  state: () =>
    ({
      user: undefined,
      isLogged: IsLogged.Loading,
      accessToken: "",
    } as AuthStoreType),
  actions: {
    login(accessToken: string, user: IUser) {
      this.$patch({
        user,
        accessToken,
        isLogged: IsLogged.Logged,
      });
      localStorage.setItem(TOKEN_STORAGE_KEY, accessToken);
    },
     loginFromStorage() {
      const token = localStorage.getItem(TOKEN_STORAGE_KEY);
      if (token != null) {
        this.$patch({
          accessToken: token,
          isLogged: IsLogged.Logged,
        });
        userRepository.getMe(token, (user, error) => {
          if (user !== undefined) {
            this.$patch({ user: user, isLogged: IsLogged.Logged });
          } else if (error) {
            this.$patch({ isLogged: IsLogged.NotLogged });
          }
        });
      }
    },
    logoutUser() {
      localStorage.removeItem(TOKEN_STORAGE_KEY);
      this.$patch({
        user: undefined,
        isLogged: IsLogged.NotLogged,
        accessToken: "",
      });
    },
  },
});
