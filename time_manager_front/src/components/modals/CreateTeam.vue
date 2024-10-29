<template>
  <div class="flex justify-center">
    <Button
      label="Create a team"
      @click="visible = true"
      style="background-color: #667add"
      class="text-white rounded-xl px-4"
    />
    <Dialog
      v-model:visible="visible"
      class="bg-white w-full justify-center border-none"
      modal
      :style="{ width: '30vw', border: 'none' }"
      ><template #header class="w-full">
        <div class="flex text-end w-full text-xl">Team Name</div></template
      >
      <div class="flex flex-col gap-8">
        <div class="flex flex-col gap-2">
          <p class="text-grey">Please specify the name of your team</p>
          <InputText
            label="Name"
            v-model="teamName"
            required
            style="background-color: #fff"
            class="text-black"
          ></InputText>
        </div>
        <Button
          @click="onClickCreated"
          color="success"
          text
          style="background-color: #667add"
          class="text-white rounded-xl px-4 w-20 self-center"
          >Create</Button
        >
      </div>
    </Dialog>
  </div>
</template>

<script lang="ts" setup>
import { useAuthStore } from "@/store/AuthStore";
import { createTeam } from "@/services/team";
import { ref } from "vue";
const props = defineProps(["open", "onSuccess", "onDismiss"]);
const visible = ref(false);
const teamName = ref("");
const auth = useAuthStore();

const onClickCreated = () => {
  createTeam(auth.accessToken, { name: teamName.value }, (team, error) => {
    if (error) {
    } else {
      props.onSuccess(team);
      visible.value = false;
    }
  });
};
</script>

<style scoped></style>
