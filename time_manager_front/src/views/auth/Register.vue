<script lang="ts" setup>
import authService from "@/services/auth";
import { ref } from "vue";
import { useAuthStore } from "@/store/AuthStore";
import { useRouter } from "vue-router";
import { useToast } from "vue-toast-notification";

import { Vue3Lottie } from "vue3-lottie";
import register from "../../assets/register.json";
import AuthFooter from "@/components/AuthFooter.vue";

import InputText from "primevue/inputtext";
import Password from "primevue/password";
import Button from "primevue/button";

const auth = useAuthStore();
const router = useRouter();
const toast = useToast();

const firstname = ref("");
const form = ref(false);
const lastname = ref("");
const email = ref("");
const password = ref("");
const show1 = ref(false);
const loading = ref(false);

const rules = {
  required: (value: string) => !!value || "This field is required",
  min: (v: string) => v.length >= 8 || "Minimum 8 characters",
  emailMatch: (v: string) => /.+@.+\..+/.test(v) || "The email must be valid!",
};

const onSubmit = () => {
  // Perform validation checks manually before submitting
  const isValid =
    rules.required(firstname.value) &&
    rules.required(lastname.value) &&
    rules.emailMatch(email.value) &&
    rules.min(password.value);

  if (!isValid) {
    form.value = false; // Form is invalid
    toast.error("Please fill in the required fields correctly.");
    return;
  }
  form.value = true; // Form is valid, proceed

  loading.value = true;
  const user = {
    firstname: firstname.value,
    lastname: lastname.value,
    password: password.value,
    email: email.value,
  };
  authService
    .register(user)
    .then((res) => {
      if (res) {
        router.push({ name: "login" });
        toast.success("Creation successful.\nPlease log in");
      } else {
        toast.error(`email ${email.value} is already in use`);
      }
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
  <div
    class="flex w-full lg:flex-row flex-col items-center justify-center lg:gap-36"
  >
    <div class="">
      <Vue3Lottie
        :animationData="register"
        :noMargin="true"
        :width="400"
        :height="400"
      />
    </div>
    <div class="flex flex-col items-center justify-center">
      <div
        class="md:w-[130%] flex -mt-20 lg:mt-0 justify-center items-center md:h-full mb-8"
      >
        <img
          src="@/assets/second-logo.png"
          alt="logo"
          class="max-w-full max-h-[100px]"
        />
      </div>
      <form @submit.prevent="onSubmit">
        <div class="mb-4">
          <FloatLabel variant="on">
            <InputText
              id="firstname"
              v-model="firstname"
              :class="{ 'p-invalid': !rules.required(firstname) }"
              class="w-80 p-input text-sm bg-white text-black"
            />
            <label for="firstname" class="text-grey bg-white">First Name</label>
          </FloatLabel>
          <small v-if="!rules.required(firstname)" class="p-error"
            >This field is required</small
          >
        </div>

        <div class="mb-4">
          <FloatLabel variant="on">
            <InputText
              id="lastname"
              v-model="lastname"
              :class="{ 'p-invalid': !rules.required(lastname) }"
              placeholder="Last Name"
              class="w-80 p-input text-sm bg-white"
            />
            <label for="lastname" class="text-grey bg-white">Last Name</label>
          </FloatLabel>
          <small v-if="!rules.required(lastname)" class="p-error"
            >This field is required</small
          >
        </div>

        <div class="mb-4">
          <FloatLabel variant="on">
            <InputText
              id="email"
              v-model="email"
              :class="{ 'p-invalid': !rules.emailMatch(email) }"
              placeholder="E-mail"
              class="w-80 p-input text-sm bg-white"
            />
            <label for="email" class="text-grey bg-white">E-mail</label>
          </FloatLabel>
          <small v-if="!rules.emailMatch(email)" class="p-error"
            >The email must be valid</small
          >
        </div>

        <div class="mb-4">
          <FloatLabel variant="on">
            <Password
              id="password"
              v-model="password"
              :toggleMask="true"
              :feedback="false"
              :class="{
                'p-invalid': !rules.required(password) || !rules.min(password),
              }"
              inputClass="w-full bg-white"
              placeholder="Password"
              class="w-80 p-input text-sm bg-white"
            />
            <label for="password" class="text-grey bg-white">Password</label>
          </FloatLabel>
          <small v-if="!rules.min(password)" class="p-error"
            >Minimum 8 characters</small
          >
        </div>

        <Button
          label="Register"
          type="submit"
          :loading="loading"
          style="background-color: #c6cef1"
          class="w-80"
        />

        <div class="text-center mt-3">
          <router-link class="text-blue text-decoration-none" to="login">
            <p class="text-main text-sm">Log in</p>
            <i class="pi pi-chevron-right"></i>
          </router-link>
        </div>

      </form>
      <auth-footer />
    </div>
  </div>
</template>

<style scoped>
.content {
  max-width: 500px;
}

.p-error {
  color: red;
  font-size: 0.75rem;
}

.mb-4 {
  margin-bottom: 1rem;
}
</style>
