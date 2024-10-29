<script setup lang="ts">
import { Line } from "vue-chartjs";
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, LineElement, PointElement, TimeScale } from "chart.js";
import 'chartjs-adapter-luxon'
import { ref, watch } from "vue";
import { IWorkingTime } from "@/dto/workingTime";
import { DateTime } from "luxon";
import { convertHoursStringToDate, convertToHoursString } from '@/utils/Chart';

export type UserWorkingTime = {
  user: User;
  times: IWorkingTime[];
};

const colors = ["#0aecf3", "#3498db", "#9b59b6", "#e74c3c", "#e67e22", "#f1c40f", "#34495e"];

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, LineElement, PointElement, TimeScale);

const props = defineProps([
  "times",
  "numberOfMonths",
  "onMonthChange",
  "reload",
  "average",
]);

const now = DateTime.now();
const date = ref({ month: now.month - 1, year: now.year });

function refreshDate() {
  const currentDate = DateTime.now();
  date.value = { month: currentDate.month - 1, year: currentDate.year };
  props.onMonthChange(date.value); // Emitting the updated date to the parent component
  props.reload(); // Triggering the reload function
}

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  scales: {
    y: {
      adapters: {
        date: {
          locale: 'fr'
        }
      },
      type: 'time',
      distribution: 'series',
      min: convertHoursStringToDate("00:00"),
      max: convertHoursStringToDate("12:00"),
      time: {
        unit: 'hour',
        tooltipFormat: 'HH:mm',
      },
    }
  }
};

const chartData = ref({
  labels: [
    ...Array.from({ length: props.numberOfMonths }, (v, k) => `${k + 1}`),
  ],
  tension: 0.3,
  datasets: [
    {
      label: 'Nicolas',
      data: [...Array.from({ length: props.numberOfMonths }, (v, k) => k + 1).map((day) => convertHoursStringToDate("01:00"))],
      tension: 0.2,
      borderColor: "#c45850",
      fill: false,
    },
    {
      label: 'Hugo',
      data: [...Array.from({ length: props.numberOfMonths }, (v, k) => k + 1).map((day) => convertHoursStringToDate("02:00"))],
      tension: 0.2,
      borderColor: "#5079c4",
      fill: false,
    },
  ],
});

watch(() => props.times, (times: UserWorkingTime[]) => {
  const data = times.map((t, index) => {
    let connectedInSection = {};
    if (t.times.length > 0) {
      for (let i = 0; i < props.numberOfMonths; i++) {
        connectedInSection[i] = convertHoursStringToDate(convertToHoursString(t.times.filter((wt) => DateTime.fromISO(wt.start).day === i).reduce((last, time) => last + DateTime.fromISO(time.end).diff(DateTime.fromISO(time.start), 'hours').toObject().hours, 0)));
      }
    } else {
      const a = convertHoursStringToDate("00:00");
      connectedInSection = { 0: a, 1: a, 2: a, 3: a, 4: a, 5: a, 6: a };
    }
    return {
      label: `${t.user.firstname.charAt(0).toUpperCase()}${t.user.firstname.slice(1).toLowerCase()} ${t.user.lastname.charAt(0).toUpperCase()}${t.user.lastname.slice(1, 3).toLowerCase()}.`,
      tension: 0.2,
      borderColor: colors[index % colors.length],
      fill: false,
      data: [
        ...Array.from({ length: props.numberOfMonths }, (v, k) => k + 1).map(
          (day) => {
            const section = Object.keys(connectedInSection).find(
              (a) => a == day
            );
            if (section == undefined) return convertHoursStringToDate("00:00");
            return connectedInSection[section];
          }
        ),
      ],
    };
  });

  let averageDatasets = {
    label: "Average",
    tension: 0.2,
    borderColor: "#00ff58",
    borderWidth: 5,
    data: [
      ...Array.from({ length: props.numberOfMonths }, (v, k) => k + 1).map(
        (day) =>
        convertHoursStringToDate(convertToHoursString(data
            .map((user) => user.data[day - 1])
            .reduce((acc, currentValue) => {
              return acc + (DateTime.fromJSDate(currentValue).diff(DateTime.fromJSDate(currentValue).startOf("day"), 'hours').toObject().hours ?? 0);
            }, 0) / times.length))
      ),
    ],
  };

  chartData.value = {
    labels: [
      ...Array.from({ length: props.numberOfMonths }, (v, k) => `${k + 1}`),
    ],
    tension: 0.3,
    datasets: props.average ? [...data, averageDatasets] : [...data],
  };
});

</script>

<template>
  <div class="root">
    <div class="title">
      <div style="display: flex; flex-direction: row; gap: 10px; align-items: center">
        <h2>Monthly Login Report</h2>
        <v-btn size="x-small" class="ma-2" color="#6774ce" @click="refreshDate" icon="mdi-refresh"></v-btn>
      </div>
      <Datepicker :clearable="false" class="picker" v-model="date" month-picker @update:modelValue="props.onMonthChange" />
    </div>
    <Line :chart-options="chartOptions" :chart-data="chartData" />
  </div>
</template>

<style scoped>
.title {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}

.picker {
  width: 350px;
}

.root {
  margin-top: 20px;
  margin-bottom: 20px;
}
</style>
