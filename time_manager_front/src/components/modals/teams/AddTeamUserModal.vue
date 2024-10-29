<script setup lang="ts">
  import { onMounted, ref } from "vue";
  import { useAuthStore } from "@/store/AuthStore";
  import userService from "@/services/users";
  import { IUser } from "@/dto/user";
  import { addUserTeam } from "@/services/team";

  const auth = useAuthStore();
  const props = defineProps<{
    open: boolean,
    onDismiss: () => void,
    onSuccess: () => void,
    team: {
      id: number,
      members: { id: number }[],
      owner: { id: number }
    }
  }>();

  const users = ref<IUser[]>([]);
  const selectedUsers = ref<string[]>([]);

  const onClickAdd = async () => {
    const selectedUsersValue = users.value.filter((user) =>
      selectedUsers.value.includes(user.email)
    );

    for (const user of selectedUsersValue) {
      await addUserTeam(auth.accessToken, props.team.id, { user_id: user.id });
    }
    props.onSuccess();
  };

  onMounted(() => {
    userService.getAllUsers().then((response) => {
      users.value = (response as IUser[])
        .filter((user) => 
          user.rank === "employee" && 
          !props.team.members.some((mu) => mu.id === user.id) && 
          props.team.owner.id !== user.id
        );
    });
  });
</script>


<template>
  <v-dialog
      v-model="props.open"
      @close="props.onDismiss"
      @click:outside="props.onDismiss"
      width="700">
    <v-card>
      <v-card-title class="text-h5 grey lighten-2">
        Add a user
      </v-card-title>
      <v-card-text>
        <v-combobox
            v-if="users.length > 0"
            multiple
            v-model="selectedUsers"
            :items="users.map((u) => u.email)"
        ></v-combobox>
        <p v-else>No members can join your team</p>
      </v-card-text>
      <v-divider></v-divider>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn
            @click="onClickAdd"
            color="success"
            :disabled="users.length <= 0"
            >
          Add
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

