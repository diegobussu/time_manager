<template>
  <p class="text-2xl md:text-4xl mb-3">Reset password</p>
  <v-form class="forms">
    <v-text-field
      v-model="newPassword"
      variant="outlined"
      :append-icon="showNewPassword ? 'mdi-eye' : 'mdi-eye-off'"
      :type="showNewPassword ? 'text' : 'password'"
      name="input-10-2"
      label="New password"
      hint="Minimum 8 characters"
      :rules="[rules.required, rules.min]"
      @click:append="showNewPassword = !showNewPassword"
    ></v-text-field>
  </v-form>
  <div class="actions">
    <v-btn color="error" prepend-icon="mdi-close-circle" @click="onClickCancel">Cancel</v-btn>
    <v-btn color="success" prepend-icon="mdi-check-circle" @click="onClickValidate">Confirm</v-btn>
  </div>
</template>

<script lang="ts">
import { useRouter } from "vue-router";
import { useAuthStore } from "@/store/AuthStore";
import servicesUser from "@/services/users";
import { useRoute } from "vue-router";
import { useAuthorize } from "@/hook/useAuthorize";
import { userRank } from "@/dto/user";
import { useToast } from "vue-toast-notification";


export default {
  name: "ChangePasswordPage",
  setup() {
    const router = useRouter();
    const auth = useAuthStore();
    const route = useRoute();
    const { isAuthorize } = useAuthorize();
    const toast = useToast();
    

    if (!isAuthorize(userRank.general_manager)) {
      toast.info("You don't have the right to access this page");
      router.push({ name: "home" });
    }

    return {
      router,
      auth,
      userId: route.params.id,
    };
  },
  data() {
    return {
      newPassword: "",
      showNewPassword: false,
      rules: {
        required: (value) => !!value || "Required.",
        min: (v) => v.length >= 8 || "Minimum 8 characters",
      },
    };
  },
  methods: {
    onClickCancel() {
      this.router.push({ name: "myProfile" });
    },
    onClickValidate() {
      servicesUser
        .resetPassword(
          this.auth.accessToken,
          this.userId,
          this.newPassword
        )
        .then((res) => {
          this.router.push({ name: "users-management" });
          this.$toast.success("Changed password");
        })
        .catch((err) => {
          if (err.response && err.response.data && err.response.data.error) {
            this.$toast.error(err.response.data.error);
          } else {
            this.$toast.error("An unknown error occurred");
          }
        });
    },
  },
};
</script>

<style scoped>
.forms {
  margin-top: 40px;
}
.actions {
  margin-top: 16px;
  display: flex;
  gap: 20px;
}
</style>
