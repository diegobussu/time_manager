<template>
  <DeleteUserModal
    :open="this.openDeleteDialog"
    :on-dismiss="onCloseModal"
    :on-success="this.onUserDeleted"
  />
  <p class="text-2xl md:text-4xl mb-3">
    {{ user?.id === currentUser.id ? 'My profile' : `Profile of ${user?.firstname} ${user?.lastname}` }}
  </p> 
  <v-form class="forms" lazy-validation>
    <v-text-field v-model="firstname" label="First name" required></v-text-field>
    <v-text-field v-model="lastname" label="Last name" required></v-text-field>
    <v-text-field v-model="email" label="E-mail" required></v-text-field>
  </v-form>
  <v-container>
    <v-btn
      class="actions-button"
      color="success"
      prepend-icon="mdi-account-edit"
      @click="onClickUpdate"
      >Update</v-btn
    >
    <v-btn
      class="actions-button"
      color="warning"
      prepend-icon="mdi-lock-reset"
      @click="onClickChangePassword"
      v-if="!id || currentUser?.rank === 'general_manager'"
      >Change password</v-btn
    >
    <v-btn
      class="actions-button"
      color="info"
      prepend-icon="mdi-logout"
      @click="onClickLogout"
      v-if="!id || id === currentUser.id"
      >Log out</v-btn
    >
    <v-btn
      class="actions-button"
      color="error"
      prepend-icon="mdi-delete"
      @click="onClickDelete"
      >Delete</v-btn
    >
  </v-container>
</template>

<script lang="ts">
import DeleteUserModal from "@/components/modals/DeleteUserModal.vue";
import { useAuthStore } from "@/store/AuthStore";
import { storeToRefs } from "pinia";
import { useRoute, useRouter } from "vue-router";
import userService from "@/services/users";
import { useToast } from "vue-toast-notification";
import { ref } from "vue";
import { IUpdateUser, userRank } from "@/dto/user";
import { useAuthorize } from "@/hook/useAuthorize";

export default {
  name: "ProfilePage",
  components: {
    DeleteUserModal,
  },
  setup() {
    const auth = useAuthStore();
    const router = useRouter();
    const route = useRoute();
    const toast = useToast();
    const { user: currentUser, isLogged, accessToken } = storeToRefs(auth);
    const id = Number(route.params.id);
    const user = ref(id ? null : storeToRefs(auth).user);
    const { isAuthorize } = useAuthorize();

    if (
      !isAuthorize([userRank.manager, userRank.general_manager]) &&
      route.name === "profile"
    ) {
      toast.info("You don't have the right to access this page.");
      router.push({ path: "/" });
    }

    return {
      auth,
      user,
      accessToken,
      isLogged,
      router,
      id,
      currentUser,
    };
  },
  data() {
    return {
      email: this.user?.email ?? "",
      lastname: this.user?.lastname ?? "",
      firstname: this.user?.firstname ?? "",
      openDeleteDialog: false,
      toast: useToast(),
    };
  },
  mounted() {
    userService.getUserById(Number(this.id)).then((res) => {
      this.user = res;
      this.email = res.email;
      this.firstname = res.firstname;
      this.lastname = res.lastname;
    });
  },
  methods: {
    updateUser() {
      const accessToken = this.auth.accessToken;
      const newValue: IUpdateUser = {
        email: this.email,
        lastname: this.lastname,
        firstname: this.firstname,
      };

      if (this.id) {
        return userService.updateUser(accessToken, Number(this.id), newValue);
      } else {
        return userService.updateMyUser(accessToken, newValue);
      }
    },
    onClickUpdate() {
      if (this.user?.id) {
        this.updateUser()
          .then(() => this.toast.success("Updated profile"))
          .catch((err) => this.toast.error(err));
      } else {
        this.toast.error("Unable to update profile");
      }
    },
    onClickDelete() {
      this.openDeleteDialog = true;
    },
    onClickChangePassword() {
      this.router.push({ name: "reset-password" });
    },
    onCloseModal() {
      this.openDeleteDialog = false;
    },
    onUserDeleted() {
      this.openDeleteDialog = false;
      this.auth.logoutUser();
    },
    onClickLogout() {
      this.auth.logoutUser();
      this.router.push("Login");
    },
  },
};
</script>

<style scoped>
.title {
  font-weight: bold;
}
.forms {
  margin-top: 40px;
}

.actions-button {
  margin-right: 10px;
  margin-bottom: 10px;
}
</style>
