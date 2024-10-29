<script setup lang="ts">
import { IWorkingTime } from "@/dto/workingTime";
import { onMounted, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import axios from "@/utils/Api";
import * as luxon from "luxon";
import { useAuthStore } from "@/store/AuthStore";
import { storeToRefs } from "pinia";
import { userRank } from "@/dto/user";
import WorkingTime from "../../components/WorkingTime.vue";
import userService from "@/services/users";
import { IUser } from "@/dto/user";
import { useToast } from "vue-toast-notification";
import { useLoading } from "@/hook/useLoading";
import Loading from "@/components/Loading.vue";

const route = useRoute();
const router = useRouter();
const toast = useToast();

const userId = ref(route.params.userid);
const workingTimeId = ref(route.params.workingtimeid);
const workingTime = ref<IWorkingTime>();
const authStore = useAuthStore();
const { isLogged, user } = storeToRefs(authStore);
const { loading, setLoading } = useLoading(true);

async function getWorkingtime() {
  try {
    const { data } = await axios.get<IWorkingTime>(
      `/workingtimes/user/${userId.value}/${workingTimeId.value}`,
      {
        headers: {
          Authorization: localStorage.getItem("access_token"),
        },
      } as any
    );
    if (data) {
      workingTime.value = data;
    } else {
      router.push("/workingtimes/" + userId.value);
    }
  } catch (error) {
    console.error(error);
    router.push("/not-found");
  }
}


watch([userId, workingTimeId], () => {
  getWorkingtime();
}, { immediate: true });


async function onSubmit() {
  const startUtc = luxon.DateTime.fromISO(start.value, { zone: 'local' }).toUTC().toISO();
  const endUtc = luxon.DateTime.fromISO(end.value, { zone: 'local' }).toUTC().toISO();


  try {
    await axios.put(
      `/workingtimes/entry/${workingTimeId.value}`,
      {
        start: startUtc,
        end: endUtc,
      },
      {
        headers: {
          Authorization: localStorage.getItem("access_token"),
        },
      } as any
    );
    getWorkingtime();
  } catch (error) {
    console.error(error);
  }
}


async function onDelete() {
  try {
    await axios.delete(`/workingtimes/entry/${workingTimeId.value}`, {
      headers: {
        Authorization: localStorage.getItem("access_token"),
      },
    } as any);
    router.push("/workingtimes/" + userId.value);
  } catch (error) {
    console.error(error);
  }
}


onMounted(async () => {
  if (userId.value !== undefined) {
    userService.getUserById(userId.value as string)
      .then(async (response) => {
        user.value = response as IUser;
      })
      .catch((err) => {
        if (err.response.status === 403) {
          toast.info("You don't have the right to access this page.");
        } else if (err.response.status === 400) {
          toast.error("User not found!");
        }
        router.push({ path: '/' });
      });
  }
  getWorkingtime();
});


const start = ref(
  luxon.DateTime.now().startOf("minute").toISO({ includeOffset: false })
);
const end = ref(
  luxon.DateTime.now().startOf("minute").toISO({ includeOffset: false })
);

watch([workingTime], () => {
  if (workingTime.value) {
    start.value = luxon.DateTime.fromISO(workingTime.value.start)
      .startOf("minute")
      .toISO({ includeOffset: false });
    end.value = luxon.DateTime.fromISO(workingTime.value.end)
      .startOf("minute")
      .toISO({ includeOffset: false });
  }
}, { immediate: true });
</script>

<template>
  <v-btn
    class="mb-4"
    icon="mdi-chevron-left"
    color="#6774ce"
    @click="() => router.back()"
  ></v-btn>
  <div>
    <WorkingTime v-if="workingTime" :workingTime="workingTime" />
    <div id="edit" v-if="user?.rank === userRank.general_manager || user.rank === userRank.manager" class="mt-8">
      <p class="text-2xl font-semibold text-center mb-4">Edit Working Time</p>
      <form @submit.prevent class="flex flex-wrap gap-4">
        <div class="flex flex-col gap-2 flex-grow">
          <label for="start" class="text-sl text-center font-semibold">Start</label>
          <input
            type="datetime-local"
            id="start"
            v-model="start"
            required
            class="p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400"
          />
        </div>
        <div class="flex flex-col gap-2 flex-grow">
          <label for="end" class="text-sl text-center font-semibold">End</label>
          <input
            type="datetime-local"
            id="end"
            v-model="end"
            required
            class="p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400"
          />
        </div>
        <div class="flex w-full justify-center gap-4 mt-4">
          <button
            type="submit"
            @click="() => onSubmit()"
            class="w-full bg-blue-500 text-white font-semibold py-2 rounded-md hover:bg-blue-600 active:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-400"
          >
            Save
          </button>
          <button
            type="button"
            prepend-icon="mdi-check-circle"
            @click="onDelete"
            class="w-full bg-red-500 text-white font-semibold py-2 rounded-md hover:bg-red-600 active:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-400"
          >
            Delete
          </button>
        </div>
      </form>
    </div>
  </div>
</template>


