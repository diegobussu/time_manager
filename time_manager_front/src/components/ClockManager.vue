<script lang="ts" setup>
import clockRepository from "@/repository/clocks";
import ShiftSyncLogo from "@/assets/third-logo.png";
import { ref } from "vue";
import * as luxon from "luxon";
import { useToast } from "vue-toast-notification";

const isCounting = ref(false);
const durationTime = ref("--:--:--");
const startingTime = ref("-");
const startingTimeFormated = ref("-");
const toast = useToast();

getClock();

async function clockIn() {
  toast.success(isCounting.value ? `You finished` : "You have pointed");
  const clock = await clockRepository.createClock();
  getClock();
}
async function getClock() {
  const clock = await clockRepository.getClock();
  const status = clock.status;
  if (status === undefined || status === false) {
    isCounting.value = false;
    startingTime.value = "-";
    startingTimeFormated.value = "00:00:00";
    durationTime.value = "00:00:00";
  } else {
    isCounting.value = status;
    startingTime.value = clock.time;
    startingTimeFormated.value = luxon.DateTime.fromISO(clock.time).toFormat(
      "HH:mm:ss"
    );
    updateDurationTime();
  }
}

function getDurationTime() {
  if (isCounting.value !== false) {
    const now = luxon.DateTime.local();
    const diff = now.diff(luxon.DateTime.fromISO(startingTime.value));
    durationTime.value = diff.toFormat("hh:mm:ss");
  }
}

function updateDurationTime() {
  if (isCounting.value === true) {
    getDurationTime();
    setTimeout(updateDurationTime, 1000);
  }
}
</script>

<template>
  <div class="clock-comp flex flex-col items-center bg-transparent mx-auto">
    <h1 class="text-4xl font-bold mb-4">ShiftSync</h1>
    <img :src="ShiftSyncLogo" alt="clock logo" class="w-[100px] h-[100px]" />
    <p class="time text-5xl font-semibold my-6" v-text="durationTime"></p>
    <v-btn
      class="counter-button mt-2 text-white"
      :style="{ backgroundColor: 'white' }"
      @click="clockIn()"
    >
      <v-icon left :style="{ color: '#6774ce' }">{{ isCounting ? 'mdi-stop' : 'mdi-play' }}</v-icon>
      <p class="text-lg font-medium" :style="{ color: '#6774ce' }">{{ isCounting ? 'Stop' : 'Start' }}</p>
    </v-btn>
    <p class="last-clock text-lg my-6">Start time : {{ startingTimeFormated }}</p>
  </div>
</template>


