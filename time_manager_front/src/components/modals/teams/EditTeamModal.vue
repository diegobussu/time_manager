<script setup lang="ts">
  import {ref} from "vue";
  import {editTeam} from "@/services/team";
  import {useAuthStore} from "@/store/AuthStore";
  import {useToast} from "vue-toast-notification";

  const auth = useAuthStore();
  const toast = useToast();

  const props = defineProps(['open', 'onDismiss', 'onSuccess', 'team']);
  const newName = ref(props.team.name ?? '');

  const onClickEdit = () => {
    editTeam(auth.accessToken, props.team.id, {name: newName.value}, (team, error) => {
      if (error) {
        toast.error("An error has occurred!");
      } else {
        props.onSuccess();
      }
    });
  }
</script>

<template>
  <v-dialog
      v-model="props.open"
      @close="props.onDismiss"
      @click:outside="props.onDismiss"
      width="500">
    <v-card>
      <v-card-title class="text-h5 grey lighten-2">
        Edit team {{team.name}}
      </v-card-title>
      <v-card-text>
        <v-text-field
            label="Team name"
            v-model="newName"
            required/>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn
            @click="onClickEdit"
            color="success"
            text>
          Confirm
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<style scoped>

</style>