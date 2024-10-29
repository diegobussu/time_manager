<script setup lang="ts">
import DailyChart from "@/components/charts/DailyChart.vue";
import { IsLogged, useAuthStore } from "@/store/AuthStore";
import workingTimeService from "@/services/workingTimes";
import WeeklyChart from "@/components/charts/WeeklyChart.vue";
import MonthlyChart from "@/components/charts/MonthlyChart.vue";
import { IWorkingTime } from "@/dto/workingTime";
import { onMounted, ref } from "vue";
import { DateTime } from "luxon";
import {useToast} from "vue-toast-notification";
import { Toast } from '@capacitor/toast';
import {LocalNotifications} from "@capacitor/local-notifications";

const auth = useAuthStore();
const toast = useToast();
const dailyWorkingTimes = ref<IWorkingTime[]>([]);
const monthlyWorkingTimes = ref<IWorkingTime[]>([]);
const weeklyWorkingTimes = ref<IWorkingTime[]>([]);
const selectedWindowDays = ref(30);
const startingDay = ref(0);
const workedToday = ref(0);
const workedWeekly = ref(0);
const toWork = ref(35);

auth.$subscribe(
  (mutation, state) => {
    loadWorkingTimes();
  },
  { deep: true }
);

const loadMonthly = () => {
  const now = DateTime.now().setLocale("fr");
  const monthStart = now.startOf("month");
  const monthEnd = now.endOf("month");
  selectedWindowDays.value = monthEnd.day;
  workingTimeService
      .getWorkingTimes(
          auth.user?.id!,
          `${monthStart.toFormat("yyyy-MM-dd")} 00:00:00`,
          `${monthEnd.toFormat("yyyy-MM-dd")} 00:00:00`
      )
      .then((response) => {
        monthlyWorkingTimes.value = response as IWorkingTime[];
      });
}

const loadDaily = () => {
  const now = DateTime.now().setLocale("fr");
  workingTimeService
      .getWorkingTimes(
          auth.user?.id!,
          `${now.toFormat("yyyy-MM-dd")} 00:00:00`,
          `${now.plus({ day: 1 }).toFormat("yyyy-MM-dd")} 00:00:00`
      )
      .then((response) => {
        dailyWorkingTimes.value = response as IWorkingTime[];

         workedToday.value = dailyWorkingTimes.value.reduce((total, wt) => {
          const start = DateTime.fromISO(wt.start);
          const end = DateTime.fromISO(wt.end);
          const diffInHours = end.diff(start, "hours").hours || 0;
          return total + diffInHours;
        }, 0);
        
        workedToday.value = parseFloat(workedToday.value.toFixed(1));
      });
}

const loadWeekly = () => {
  const now = DateTime.now().setLocale("fr");
  const weekStart = now.startOf("week");
  const weekEnd = now.endOf("week");
  startingDay.value = weekStart.day;
  workingTimeService
      .getWorkingTimes(
          auth.user?.id!,
          `${weekStart.toFormat("yyyy-MM-dd")} 00:00:00`,
          `${weekEnd.toFormat("yyyy-MM-dd")} 00:00:00`
      )
      .then((response) => {
        weeklyWorkingTimes.value = response as IWorkingTime[];

        workedWeekly.value = weeklyWorkingTimes.value.reduce((total, wt) => {
          const start = DateTime.fromISO(wt.start);
          const end = DateTime.fromISO(wt.end);
          const diffInHours = end.diff(start, "hours").hours || 0;
          return total + diffInHours;
        }, 0);
        
        workedWeekly.value = parseFloat(workedWeekly.value.toFixed(1));
      });
}

const loadWorkingTimes = () => {
  loadDaily();
  loadWeekly();
  loadMonthly();
};

onMounted( async () => {
  try {
    loadToday();

    const notifs = await LocalNotifications.schedule({
      notifications: [
        {
          title: 'Title',
          body: 'Body',
          id: 1,
          schedule: { at: new Date(Date.now() + 1000) },
          actionTypeId: '',
          extra: null,
        },
      ],
    });
  } catch (er) {
    await Toast.show({
      text: 'An error has occurred',
    });
  }

  if (auth.isLogged === IsLogged.Logged) {
    loadWorkingTimes();
  }
});

const onMonthChange = (event) => {
  const now = DateTime.now().set({ month: event.month + 1, year: event.year });
  const monthStart = now.startOf("month");
  const monthEnd = now.endOf("month");
  selectedWindowDays.value = monthEnd.day;
  workingTimeService.getWorkingTimes(auth.user?.id!, `${monthStart.toFormat('yyyy-MM-dd')} 00:00:00`, `${monthEnd.toFormat('yyyy-MM-dd')} 00:00:00`).then((response) => {
    monthlyWorkingTimes.value = response as IWorkingTime[];
  });
}

const onWeekChange = (event) => {
  const d1 = DateTime.fromJSDate(event[0])
  const d2 = DateTime.fromJSDate(event[1])
  startingDay.value = d1.day;
  workingTimeService.getWorkingTimes(auth.user?.id!, `${d1.toFormat('yyyy-MM-dd')} 00:00:00`, `${d2.toFormat('yyyy-MM-dd')} 00:00:00`).then((response) => {
    weeklyWorkingTimes.value = response as IWorkingTime[];
  });
}

const onReloadMonthly = () => {
  loadMonthly();
  toast.success("Updated data");
}

const onReloadDaily = () => {
  loadDaily();
  toast.success("Updated data");
}

const onReloadWeekly = () => {
  loadWeekly();
  toast.success("Updated data");
}

</script>

<template>
  <p class="text-2xl md:text-4xl mb-3" :style="{ color: '#4B547D'}">Welcome {{auth.user?.firstname}}</p>

  <v-row no-gutters style="margin-top: 20px;" class="sm:justify-between sm:items-center justify-center mt:2">
    <v-col lg="8" cols="12">
      <WeeklyChart 
        :times="weeklyWorkingTimes" 
        :on-picker-change="onWeekChange" 
        :starting-day="startingDay" 
        :reload="onReloadWeekly"
      />
    </v-col>
  
    <div class="info-container text-white text-center font-weight-bold">
      <p class="mb-4">Total</p>
      <p class="mb-1">{{ `Worked today : ${workedToday} H` }}</p>
      <p class="mb-1">{{ `Worked this week : ${workedWeekly} H` }}</p>
      <p class="mb-1">{{ `Total to complete : ${toWork} H` }}</p>
      <p class="mb-1">{{ `Left to work : ${toWork - workedWeekly} H` }}</p>
    </div>
  </v-row>

  <v-row no-gutters style="margin-top: 50px;" class="sm:justify-between sm:items-center justify-center mt:2">
    <v-col lg="4" cols="12">
      <DailyChart :times="dailyWorkingTimes" :reload="onReloadDaily"/>
    </v-col>
    <v-col lg="8" cols="12">
      <MonthlyChart :times="monthlyWorkingTimes" :on-picker-change="onMonthChange" :number-of-days="selectedWindowDays" :reload="onReloadMonthly"/>
    </v-col>
  </v-row>
</template>

<style scoped>
.picker {
  width: 200px;
}

.table-container {
  flex: 0 0 auto;
}

.info-container {
  background-color: #6774ce;
  border-radius: 10px;
  padding: 20px;
  margin: 50px;
}

.not-active {
  background-color: rgba(255, 0, 0, 0.1);
  padding: 5px;
  border-radius: 4px;
}

.active {
  background-color: rgba(0, 255, 0, 0.1);
  padding: 5px;
  border-radius: 4px;
}

.rounded-table {
  border-radius: 10px;
  overflow: hidden;
}

.rounded-table th, 
.rounded-table td {
  border: none;
  padding: 10px;
}
</style>
