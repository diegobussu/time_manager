<script lang="ts" setup>
import { useRouter } from "vue-router";
import * as luxon from "luxon";

const props = defineProps(["team"]);
const router = useRouter();

const onClickTeam = () => {
  router.push({ path: `teams/${props.team.id}` });
};
</script>

<template>
  <Card @click="onClickTeam" class="w-80 bg-white" outlined>
    <template #title>{{ team.name }}</template>
    <template #content>
      <p>{{ team.members.length }} member(s)</p>
      <p>Owned by {{ team.owner.lastname }} {{ team.owner.firstname }}</p>
      <p>Updated on {{ luxon.DateTime.fromISO(team.updated_at).toFormat("MM/dd/yyyy") }}</p>
    </template>
  </Card>
</template>

<style scoped>
.team-card {
  padding: 10px;
  margin: 10px;
}
</style>
