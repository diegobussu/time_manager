<script setup lang="ts">
import { Line } from 'vue-chartjs'
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
} from 'chart.js'
import 'chartjs-adapter-luxon'
import { ref, watch } from "vue";
import { DateTime } from "luxon";
import { convertHoursStringToDate, convertToHoursString } from "@/utils/Chart";

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, LineElement, PointElement, TimeScale)

const props = defineProps(['times', 'onPickerChange', 'numberOfDays', 'reload']);

const now = DateTime.now();
const date = ref({ month: now.month - 1, year: now.year });

const resetToCurrentMonth = () => {
  const current = DateTime.now();
  date.value = { month: current.month - 1, year: current.year };
  props.reload();
};

const chartData = ref({
  labels: [...Array.from({ length: props.numberOfDays }, (v, k) => k + 1)],
  datasets: [
    {
      label: 'Online',
      backgroundColor: '#41B883',
      data: [...Array.from({ length: props.numberOfDays }, (v, k) => k + 1).map((day) => convertHoursStringToDate("00:00"))],
      tension: 0.2
    }
  ]
});

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
};

watch(() => props.times, (times) => {
  let connectedInSection = {};
  if (times.length > 0) {
    for (let i = 0; i < props.numberOfDays; i++) {
      connectedInSection[i] = convertHoursStringToDate(convertToHoursString(times.filter((wt) => DateTime.fromISO(wt.start).day === i).reduce((last, time) => last + DateTime.fromISO(time.end).diff(DateTime.fromISO(time.start), 'hours').toObject().hours, 0)));
    }
  } else {
    connectedInSection = [...Array.from({ length: props.numberOfDays }, (v, k) => k + 1).map((day) => convertHoursStringToDate("00:00"))];
  }
  chartData.value = {
    labels: [...Array.from({ length: props.numberOfDays }, (v, k) => k + 1)],
    datasets: [
      {
        label: 'Online',
        backgroundColor: '#41B883',
        data: [...Array.from({ length: DateTime.now().endOf("month").day }, (v, k) => k + 1).map((day) => {
          const section = Object.keys(connectedInSection).find((a) => a == day);
          if (section == undefined)
            return convertHoursStringToDate("00:00");
          return connectedInSection[section];
        })],
        tension: 0.2
      },
    ]
  };
});

const onMonthChange = (event) => {
  props.onPickerChange(event);
};

</script>

<template>
  <div class="title">
    <div style="display: flex; flex-direction: row; gap: 10px; align-items: center">
      <h2>Monthly recap</h2>
      <v-btn
          size="x-small"
          class="ma-2"
          color="#6774ce"
          icon="mdi-refresh"
          @click="resetToCurrentMonth"
      ></v-btn>
    </div>
    <Datepicker class="picker" v-model="date" :clearable="false" :month-picker="true" @update:modelValue="onMonthChange"/>
  </div>
  <Line :chart-options="chartOptions" :chart-data="chartData" />
</template>

<style scoped>
.title {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}
</style>
