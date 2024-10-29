<script setup lang="ts">
import { Doughnut } from "vue-chartjs";
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  ArcElement,
  CoreChartOptions,
} from "chart.js";
import { ref, watch } from "vue";
import { DateTime } from "luxon";
import { IWorkingTime } from "@/dto/workingTime";

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  ArcElement
);

const props = defineProps(["times", 'reload']);

const chartData = ref({
  labels: ["Online", "Offline"],
  datasets: [
    { data: [0, 0], backgroundColor: ["#41B883", "rgba(140,140,140,0.49)"] },
  ],
});

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: false,
    },
    tooltip: {
      enabled: true,
      callbacks: {
        label: (context: any) => {
          const label = context.label;
          const value = context.parsed;
          return `${label}: ${value}h`;
        },
      },
    },
  },
};

watch(
  () => props.times,
  (times) => {
    let connectedInSection = 0;
    for (let wt: IWorkingTime of times) {
      const end = DateTime.fromISO(wt.end);
      const start = DateTime.fromISO(wt.start);
      const diff = end.diff(start, "hours");
      connectedInSection += diff.toObject().hours ?? 0;
    }
    connectedInSection = parseFloat(connectedInSection.toFixed(1));
    const labels =
      connectedInSection > 7 ? ["Overtime", "Online"] : ["Online", "Offline"];

    const data =
      connectedInSection > 7
        ? [connectedInSection, (7 - connectedInSection) * -1]
        : [connectedInSection, 7 - connectedInSection];

    chartData.value = {
      labels,
      datasets: [
        {
          data,
          backgroundColor: [
            connectedInSection > 7 ? "#E42538" : "#41B883",
            connectedInSection > 7 ? "#41B883" : "rgba(140,140,140,0.49)",
          ],
        },
      ],
    };
  }
);
</script>

<template>
  <div style="display: flex; flex-direction: row; gap: 10px; align-items: center">
    <h2>Daily</h2>
    <v-btn size="x-small" class="ma-2" color="#6774ce" @click="() => props.reload()" icon="mdi-refresh"></v-btn>
  </div>
  <Doughnut :chart-options="chartOptions" :chart-data="chartData" />
</template>
