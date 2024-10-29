<script lang="ts" setup>
import {useRouter} from "vue-router";
import {ref} from "vue";
import * as luxon from "luxon";
import {useAuthStore} from "@/store/AuthStore";
import AddTeamUserModal from "@/components/modals/teams/AddTeamUserModal.vue";
import {useToast} from "vue-toast-notification";
import {IUser} from "@/dto/user";
import {removeUserTeam} from "@/services/team";

const router = useRouter();
const auth = useAuthStore();

enum ModalType {
  AddUser,
  RemoveUser,
}

const toast = useToast();
const open = ref<undefined | ModalType>(undefined);

const {team, reload} = defineProps(['team', 'reload']);

const onClickDeleteUser = (user: IUser) => {
  removeUserTeam(auth.accessToken, team.id, {user_id: user.id}, (team, error) => {
    if (error) {
      toast.error("An error has occurred!");
    } else {
      toast.success("The user has been removed from your team");
      reload();
    }
  });
}

const onClickUserDashboard = (user: IUser) => {
  router.push({path: `/user/${user.id}/dashboard`});
}

const onUserAdded = () => {
  toast.success("Member(s) have been added to your team");
  open.value = undefined;
  reload();
}

const onDismiss = () => {
  open.value = undefined;
}

</script>

<template>
  <AddTeamUserModal :open="open === ModalType.AddUser" :on-success="onUserAdded" :on-dismiss="onDismiss" :team="team"/>
    <v-table fixed-header class="members-list">
      <thead>
      <tr>
        <th class="text-left">E-mail</th>
        <th class="text-left">First name</th>
        <th class="text-left">Last name</th>
        <th class="text-left">Creation date</th>
        <th class="text-left">Update date</th>
        <th class="text-left">Actions</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="(member, index) in [team.owner, ...team.members]" :key="index">
        <td>{{ member.email }} {{member.id === team.owner.id ? "👑" : ""}}</td>
        <td>{{ member.firstname }}</td>
        <td>{{ member.lastname }}</td>
        <td>{{ luxon.DateTime.fromISO(member.insert_at).toFormat("MM/dd/yyyy") }}</td>
        <td>{{ luxon.DateTime.fromISO(member.insert_at).toFormat("MM/dd/yyyy") }}</td>

        <td>
          <v-btn
              class="ma-2"
              variant="text"
              icon="mdi-monitor-dashboard"
              @click="() => onClickUserDashboard(member)"
              title="Dashboard"
              color="#6774ce"/>
          <v-btn
              class="ma-2"
              variant="text"
              icon="mdi-briefcase-clock-outline"
              @click="() => router.push({path: `/workingtimes/${member.id}`})"
              title="Working time"
              color="#6774ce"/>
          <v-btn
              class="ma-2"
              variant="text"
              icon="mdi-delete"
              @click="() => onClickDeleteUser(member)"
              title="Kick user"
              color="#6774ce"/>
        </td>
      </tr>
      </tbody>
    </v-table>
    <v-btn
      @click="open = ModalType.AddUser"
      prepend-icon="mdi-account-plus"
      color="info"
      >
        Add a user
    </v-btn>
</template>

<style scoped>
.members-list {
  margin-top: 20px;
  margin-bottom: 20px;
}
</style>