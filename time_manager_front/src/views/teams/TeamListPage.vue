<script lang="ts" setup>
import { useRouter } from "vue-router";
import { ref, onMounted } from "vue";
import { useAuthStore } from "@/store/AuthStore";
import { getTeams } from "@/services/team";
import TeamList from "@/components/teams/TeamList.vue";
import { useAuthorize } from "@/hook/useAuthorize";
import { userRank } from "@/dto/user";
import { useToast } from "vue-toast-notification";
import CreateTeam from "@/components/modals/CreateTeam.vue";

const router = useRouter();
const auth = useAuthStore();

const teams = ref([]);
const { isAuthorize } = useAuthorize();
const toast = useToast();

if (!isAuthorize([userRank.manager, userRank.general_manager])) {
  toast.info("You don't have the right to access this page.");
  router.push({ name: "home" });
}

onMounted(() => {
  loadTeams();
});

const loadTeams = () => {
  getTeams(auth.accessToken, (team, error) => {
    if (error) {
    } else {
      teams.value = team;
    }
  });
};

const onCloseModal = () => {
  open.value = false;
};

const onSuccess = (team) => {
  open.value = false;
  loadTeams();
};
</script>

<template>
  <div class="flex w-full justify-between items-center px-4 md:mb-12">
    <p class="text-2xl md:text-4xl mb-3">Teams</p>
    <CreateTeam
      :open="open"
      :on-success="onSuccess"
      :on-dismiss="onCloseModal"
    />
  </div>
  <div class="w-full">
    <TeamList :teams="teams" class="w-full" style="cursor: pointer;" title="See more infos"/>
  </div>
</template>
