<script lang="ts" setup>
import { IsLogged, useAuthStore } from "@/store/AuthStore";
import { storeToRefs } from "pinia";
import { useLoading } from "@/hook/useLoading.tsx";
import ClockManager from "@/components/ClockManager.vue";
import { useRouter } from "vue-router";
import { ref, watch } from "vue";
import Loading from "@/components/Loading.vue";

const auth = useAuthStore();
const { user } = storeToRefs(auth);
const router = useRouter();
const { loading } = useLoading();
const drawer = ref(window.innerWidth > 1284);
const mobile = ref<boolean>(isMobile());


auth.$subscribe(
  (mutation, state) => {
    if (state.isLogged == IsLogged.NotLogged) {
      router.push({ name: "login" });
    }
  },
  { detached: true }
);

window.addEventListener("resize", () => {
  mobile.value = isMobile();
});

function isMobile() {
  return window.innerWidth <= 1284;
}

function logout() {
  auth.logoutUser();
  router.push("Login");
}

watch(mobile, (value) => {
  if (value) {
    drawer.value = false;
  } else {
    drawer.value = true;
  }
});
</script>

<template>
  <v-app>
    <v-app-bar app color="deep-grey-lighten-5" dark v-if="mobile">
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <div class="d-flex align-center w-100">
        <v-toolbar-title style="text-align: center"
          >Time Manager</v-toolbar-title
        >
      </div>
      <v-btn icon @click="logout">
        <v-icon>mdi-export</v-icon>
      </v-btn>
    </v-app-bar>
    <v-navigation-drawer
      fixed
      floating
      app
      v-model="drawer"
      touchless
      class="drawer text-white"
      style="background-color: #6774ce;"
    >
      <v-container class="container">
        <v-row class="top">
          <v-list class="w-100">
            <v-list-item
              class="py-2 mb-2"
              @click="() => router.push({ name: 'myProfile', params: { id: user?.id } })"
              prepend-icon="mdi-account-circle"
              :title="`${user?.firstname ?? 'Chargement ...'} ${user?.lastname ?? ''}`"
              :subtitle="user?.email ?? 'Chargement ...'"
              value="myProfile"
            ></v-list-item>
            <v-divider></v-divider>
            <v-list-item
              prepend-icon="mdi-monitor-dashboard"
              title="Dashboard"
              value="dashboard"
              @click="router.push({ name: 'home' })"
            ></v-list-item>
            <v-list-item
              prepend-icon="mdi-calendar-blank-multiple"
              title="Workingtimes"
              value="workingtimes"
              @click="router.push({ path: `/workingtimes/` })"
            ></v-list-item>
            <v-list-item
              v-if="
                user?.rank === 'manager' || user?.rank === 'general_manager'
              "
              prepend-icon="mdi-account-group"
              title="Teams"
              value="teams"
              @click="router.push({ name: 'teams' })"
            >
            </v-list-item>
            <v-list-item
              v-if="user?.rank === 'general_manager'"
              prepend-icon="mdi-account-multiple-outline"
              title="Users"
              value="users"
              @click="router.push({ name: 'users-management' })"
            ></v-list-item>
          </v-list>
        </v-row>
        <v-row class="bottom">
          <ClockManager />
        </v-row>
      </v-container>
    </v-navigation-drawer>
    <v-main>
      <v-container fluid>
        <router-view v-if="!loading" />
        <div v-if="loading">
          <Loading />
        </div>
      </v-container>
    </v-main>
  </v-app>
</template>

<style scoped>
.container {
  height: 100vh;
  min-height: fit-content;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.top {
  flex: 0 0 auto;
}

.bottom {
  flex: 0 0 auto;
  padding: 1em 0;
}
</style>
