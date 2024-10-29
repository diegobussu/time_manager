<script lang="ts" setup>
import userService from '@/services/users';
import userRepository from '@/repository/users';
import {ref} from 'vue';
import {useAuthStore} from "@/store/AuthStore";
import {IUser} from "@/dto/user";
import {useToast} from "vue-toast-notification";
import {useRouter, useRoute} from "vue-router";
import { useAuthorize } from "@/hook/useAuthorize";
import { userRank } from "@/dto/user";

const auth = useAuthStore();
const router = useRouter();
const toast = useToast();
const { isAuthorize } = useAuthorize();
const route = useRoute();

const items = ref([] as any);
const roles = ["employee", "manager"];
const selected = ref<string | number>('');
const isUser = ref(false);
const isEditing = ref(false);
const user = ref({
  id: 0,
  firstname: '',
  lastname: '',
  email: '',
  rank: ''
});
const updateUser = ref({
  firstname: '',
  lastname: '',
  email: '',
  rank: '',
});

if (
  !isAuthorize([userRank.manager, userRank.general_manager]) &&
  route.name === "users-management"
) {
  toast.info("You don't have the right to access this page");
  router.push({ path: "/" });
}


refreshUsers()

function refreshUsers() {
  userService.getAllUsers().then((response) => {
    items.value = []
    for (let i = 0; i < response.length; i++) {
      items.value.push({ 
        title: `${response[i].firstname} ${response[i].lastname}`, 
        icon: 'mdi-account', 
        route: 'users', 
        id: response[i].id 
      });
    }
  });
}


function searchUsers() {
   isUser.value = false;
   isEditing.value = false;
  if (selected.value !== 0) {
    userService.getUserById(selected.value as string).then((response) => {
      isUser.value = true;
      user.value.id = response.id;
      user.value.firstname = response.firstname;
      user.value.lastname = response.lastname;
      user.value.email = response.email;
      user.value.rank = response.rank;
      updateUser.value = user.value;
    });
  } else {
  }
}

function deleteUser() {
  if (selected.value !== 0) {
    userRepository.deleteUserById(selected.value as number).then((response) => {
      toast.success("User successfully deleted");
      selected.value = 0;
      isUser.value = false;
      refreshUsers();
    });
  } else {
    toast.success("An error has occurred");
  }
}


function saveUser() {
  if (selected.value !== 0) {
    userService.updateUser(auth.accessToken, selected.value as number, updateUser.value as IUser
    ).then((response) => {
      toast.success("User updated");
      isEditing.value = false;
      selected.value = '';
      refreshUsers();
    });
  } else {
    toast.error("An error has occurred");
  }
}


function resetPassword() {
  if (user.value.id) {
    router.push({ name: "reset-password-user", params: { id: user.value.id } });
  } else {
    toast.error("No user selected");
  }
}


</script>

<template>
  <p class="text-2xl md:text-4xl mb-3">All users</p>
  <v-autocomplete class="w-[300px]" dense filled rounded solo label="Select a user" :items="items" item-value="id" v-model="selected"
    menu-icon="" append-icon="mdi-account-search" @click:append="searchUsers" @update:modelValue="() => searchUsers()">
  </v-autocomplete>
  <div v-if="isUser" style="padding: 10px">
      <v-text-field class="w-[700px]" :disabled="!isEditing" label="Prénom" v-model="updateUser.firstname" :placeholder="user.firstname"></v-text-field>
      <v-text-field class="w-[700px]" :disabled="!isEditing" label="Nom" v-model="updateUser.lastname" :placeholder="user.lastname"></v-text-field>
      <v-text-field class="w-[700px]" :disabled="!isEditing" label="Email" v-model="updateUser.email" :placeholder="user.email"></v-text-field>
      <v-select class="w-[700px]" :disabled="!isEditing" label="Rôle" v-if="user.rank !== 'general_manager'" v-model="updateUser.rank" solo :items="roles" :value="user.rank" append-inner-icon=""></v-select>
      <v-select class="w-[700px]" label="Rôle" v-else v-model="updateUser.rank" solo :items="roles" :value="user.rank" append-inner-icon="" disabled></v-select>
      <div v-if="isEditing">
        <v-btn
            color="success"
            class="mr-4"
            prepend-icon="mdi-check-circle"
            @click="saveUser()">Update</v-btn>
        <v-btn color="error" prepend-icon="mdi-close-circle" @click="isEditing = !isEditing">Cancel</v-btn>
      </div>
      <div v-else>
        <v-btn
            v-if="user.rank !== 'general_manager'"
            color="success"
            class="mr-4"
            prepend-icon="mdi-account-edit"
            @click="isEditing = true">Edit</v-btn>
        <v-btn
            color="info"
            class="mr-4"
            prepend-icon="mdi-monitor-dashboard"
            @click="() => router.push({path: `/user/${updateUser.id}/dashboard`})">Dashboard</v-btn>

        <v-btn
            v-if="user.rank !== 'general_manager'"
            color="warning"
            class="mr-4"
            prepend-icon="mdi-lock-reset"
            @click="() => resetPassword()">Reset password</v-btn>

        <v-btn
            v-if="user.rank !== 'general_manager'"
            color="error"
            class="mr-4"
            prepend-icon="mdi-delete"
            @click="() => deleteUser()">Delete</v-btn>
      </div>
  </div>
</template>