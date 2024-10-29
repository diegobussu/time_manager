<script setup lang="ts">
import { Line } from 'vue-chartjs';
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  LineElement,
  PointElement,
  TimeScale,
} from 'chart.js';
import 'chartjs-adapter-luxon';
import { ref, watch } from "vue";
import { DateTime } from "luxon";
import { convertHoursStringToDate, convertToHoursString } from "@/utils/Chart";

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, LineElement, PointElement, TimeScale);

const props = defineProps(['times', 'onPickerChange', 'startingDay', 'reload']);
const now = DateTime.now();
const date = ref([now.startOf("week").toJSDate(), now.endOf("week").toJSDate()]);

const chartData = ref({
  labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
  datasets: [
    {
      label: 'Online',
      fill: true,
      backgroundColor: '#f87979',
      data: [...Array.from({ length: 7 }, (v, k) => k + 1).map((day) => convertHoursStringToDate("00:00"))],
      tension: 0.2
    }
  ]
});

watch(() => props.times, (times) => {
  let connectedInSection = {};
  if (times.length > 0) {
    for (let i = 0; i < 7; i++) {
      connectedInSection[i] = convertHoursStringToDate(convertToHoursString(times.filter((wt) => DateTime.fromISO(wt.start).day % 7 === i).reduce((last, time) => last + DateTime.fromISO(time.end).diff(DateTime.fromISO(time.start), 'hours').toObject().hours, 0)));
    }
  } else {
    const a = convertHoursStringToDate("00:00");
    connectedInSection = { 0: a, 1: a, 2: a, 3: a, 4: a, 5: a, 6: a };
  }
  chartData.value = {
    labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
    datasets: [
      {
        label: 'Online',
        backgroundColor: '#41B883',
        fill: true,
        data: [...Array.from({ length: 7 }, (v, k) => k + 1).map((day) => {
          const section = Object.keys(connectedInSection).find((a) => a == day - 1);
          if (section == undefined)
            return convertHoursStringToDate("00:00");
          return connectedInSection[section];
        })],
        tension: 0.2
      }
    ]
  }
});

function resetWeek() {
  const currentWeekStart = DateTime.now().startOf("week").toJSDate();
  const currentWeekEnd = DateTime.now().endOf("week").toJSDate();
  date.value = [currentWeekStart, currentWeekEnd];
}

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: false,
    },
  },
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
}
</script>

<template>
  <div class="title">
    <div style="display: flex; flex-direction: row; gap: 10px; align-items: center">
      <h2>Weekly recap</h2>
      <v-btn
        size="x-small"
        class="ma-2"
        color="#6774ce"
        @click="() => { props.reload(); resetWeek(); }"
        icon="mdi-refresh"
      ></v-btn>
    </div>
    <Datepicker class="picker" v-model="date" week-picker :clearable="false" @update:modelValue="(v) => props.onPickerChange(v)"/>
  </div>
  <Line :chart-options="chartOptions" :chart-data="chartData" />
</template>

<style scoped>
.title {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}
.picker {
  width: 350px
}
</style>
