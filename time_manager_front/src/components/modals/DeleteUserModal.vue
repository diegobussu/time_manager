<script setup lang="ts">
import userRepository from "@/repository/users";
import { useAuthStore } from "@/store/AuthStore";
import { useToast } from "vue-toast-notification";

const auth = useAuthStore();
const props = defineProps(["open", "onDismiss", "onSuccess", "deleteUser"]);
const $Toast = useToast();

const onClickDelete = () => {
  if (props.deleteUser) {
    userRepository
      .deleteUsers(auth.accessToken, props.deleteUser)
      .then(() => {
        $Toast.success(
          `Account with id ${props.deleteUser.id} has been deleted`
        );
        props.onSuccess();
      })
      .catch((err) => {
        $Toast.error(err);
        props.onDismiss();
      });
  } else {
    userRepository
      .deleteUser(auth.accessToken)
      .then(() => {
        $Toast.success(`Account deleted`);
        props.onSuccess();
      })
      .catch((err) => {
        $Toast.error(err);
        props.onDismiss();
      });
  }
};
</script>

<template>
  <v-dialog
    v-model="props.open"
    @close="props.onDismiss"
    @click:outside="props.onDismiss"
    width="500"
  >
    <v-card>
      <v-card-title class="text-h5 grey lighten-2">
        Delete {{ props.deleteUser !== undefined ? "this" : "my" }} account ?
      </v-card-title>
      <v-card-text>
        Do you want to delete
        {{ props.deleteUser !== undefined ? "this" : "your" }} account ? Once this operation is carried out, it is no longer possible to recover the account.
        compte.
      </v-card-text>
      <v-divider></v-divider>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn @click="onClickDelete" color="error" text> Delete </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<style scoped></style>
