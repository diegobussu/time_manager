<script lang="ts" setup>
import TeamCard from "@/components/teams/TeamCard.vue";

const props = defineProps(["teams"]);
</script>

<template>
  <div class="flex flex-wrap justify-start m-0 gap-8 px-4 w-full">
    <template v-for="(team, index) in props.teams" :key="index">
      <TeamCard :team="team" />
    </template>
  </div>
</template>
