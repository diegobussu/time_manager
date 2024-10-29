<script lang="ts" setup>
import authService from "@/services/auth";
import { useAuthStore } from "@/store/AuthStore";
import { useRouter } from "vue-router";
import { ref } from "vue";
import { useToast } from "vue-toast-notification";
import AuthFooter from "@/components/AuthFooter.vue";
import { Vue3Lottie } from "vue3-lottie";
import welcome from "../../assets/welcome-screen.json";

const auth = useAuthStore();
const router = useRouter();
const toast = useToast();
const email = ref("");
const password = ref("");
const loading = ref(false);

const emailValid = ref(true);
const passwordValid = ref(true);

const validateEmail = () => {
  emailValid.value = !!email.value && /.+@.+\..+/.test(email.value);
  return emailValid.value;
};

const validatePassword = () => {
  passwordValid.value = !!password.value && password.value.length >= 8;
  return passwordValid.value;
};

const onSubmit = () => {
  if (!validateEmail() || !validatePassword()) {
    toast.error("Please fill in the form correctly.");
    return;
  }

  loading.value = true;
  authService

    .login(email.value, password.value)
    .then(({ access_token, user }) => {
      auth.login(access_token, user);
      router.push({ name: "home" });
    })
    .catch((err) => {
      if (err.response && err.response.data && err.response.data.error) {
        toast.error(err.response.data.error);
      } else {
        toast.error("An error has occurred");
      }
      loading.value = false;
    });
};
</script>

<template>
  <div class="flex w-full lg:flex-row flex-col items-center">
    <div
      class="md:w-[130%] lg:flex justify-center items-center bg-main hidden md:h-full"
    >
      <img
        src="@/assets/logo.png"
        alt="logo"
        class="max-w-full max-h-[400px]"
      />
    </div>
    <div class="flex flex-col lg:p-12 justify-center items-center w-full">
      <Vue3Lottie
        :animationData="welcome"
        :noMargin="true"
        :width="400"
        :height="400"
      />

      <form
        class="py-4 flex flex-col justify-center items-center gap-8"
        @submit.prevent="onSubmit"
      >
        <div class="flex flex-col gap-2">
          <span class="p-float-label">
            <InputText
              v-model="email"
              :disabled="loading"
              id="email"
              placeholder="Enter your email"
              class="w-80 p-input text-sm bg-white"
            />
          </span>
          <p v-if="!emailValid" class="text-red-500">Invalid email format</p>

          <span class="p-float-label">
            <Password
              v-model="password"
              :feedback="false"
              class="w-80 p-input text-sm !bg-white"
              inputClass="w-full bg-white"
              placeholder="Enter your password"
              toggleMask
            />
          </span>
          <p v-if="!passwordValid" class="text-red-500">
            Password must be at least 8 characters
          </p>
        </div>

        <Button
          label="Log in"
          class="w-full"
          :loading="loading"
          :disabled="!email || !password"
          type="submit"
          style="background-color: #c6cef1"
        />

        <div class="text-center">
          <router-link class="text-blue text-decoration-none" to="/register">
            <p class="text-main text-sm">Register</p>
            <i class="pi pi-chevron-right"></i>
          </router-link>
        </div>
      </form>

      <auth-footer />
    </div>
  </div>
</template>
