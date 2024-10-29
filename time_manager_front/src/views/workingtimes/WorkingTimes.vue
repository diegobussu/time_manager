<script setup lang="ts">
import { IWorkingTime } from "@/dto/workingTime";
import {onMounted, reactive, ref, watch} from "vue";
import { useRoute, useRouter } from "vue-router";
import axios from "@/utils/Api";
import { Vue3Lottie } from 'vue3-lottie'

import noData from '../../assets/no-data.json'
import WorkingTime from "../../components/WorkingTime.vue";
import userService from "@/services/users";
import {IUser} from "@/dto/user";
import {useToast} from "vue-toast-notification";
import {useAuthStore} from "@/store/AuthStore";
import {useLoading} from "@/hook/useLoading";
import Loading from "@/components/Loading.vue";

const route = useRoute();
const router = useRouter();
const toast = useToast();

const userId = ref(route.params.userid);
const auth = useAuthStore();
const {loading, setLoading} = useLoading(true);
const workingTimes = ref<IWorkingTime[]>([]);
const user = ref<undefined | IUser>(undefined);

async function getWorkingtimes(): Promise<IWorkingTime[]> {
  let urlPrefix = '';
  if (userId.value === undefined) {
    urlPrefix = '/workingtimes/me/';
  } else {
    urlPrefix = `/workingtimes/user/${userId.value}`;
  }
  try {
    const { data } = await axios.get<IWorkingTime[]>(
        urlPrefix,
        {
        headers: {
          Authorization: localStorage.getItem("access_token"),
        },
      } as any
    );
    setLoading(false);
    return data as IWorkingTime[];
  } catch (error) {
    setLoading(false);
    router.push("/not-found");
    return [];
  }
}

onMounted(async () => {
  if (userId.value !== undefined) {
    userService.getUserById(userId.value as string).then(async (response) => {
      user.value = response as IUser;
    }).catch((err) => {
      if (err.response.status === 403) {
        toast.info("You don't have the right to access this page.");
      } else if (err.response.status === 400) {
        toast.error("User not found !");
      }
      router.push({path: '/'});
    });
  }
  workingTimes.value = await getWorkingtimes();
});

const onClickWT = (wt: WorkingTime) => {
  if (userId.value === undefined) {
    router.push(`/workingtimes/${auth.user?.id}/${wt.id}`);
  } else {
    router.push(`/workingtimes/${userId.value}/${wt.id}`);
  }
}

</script>

<template>

  <div v-if="loading">
    <Loading/>
  </div>
  <div v-else>
    <p class="text-2xl md:text-4xl mb-3">{{user !== undefined ? `${user.firstname} ${user.lastname.toUpperCase()}` : "My"}} working times</p>
    <div
        id="workingtimes__list"
        v-if="workingTimes !== null"
        v-for="workingTime in workingTimes"
    >
      <WorkingTime
          :workingTime="workingTime"
          @clicked="() => onClickWT(workingTime)"
      />
    </div>
    <div class="not-found" v-if="workingTimes !== null && workingTimes.length <= 0 && !loading">
      <h1>{{user?.firstname ?? auth?.user?.firstname}} {{user?.lastname?.toUpperCase() ?? auth?.user?.lastname?.toUpperCase()}} has no working time</h1>
      <Vue3Lottie :animationData="noData" style="max-width: 500px" />
    </div>
  </div>
</template>

<style scoped>

.not-found {
  display: flex;
  flex-direction: column;
  align-content: center;
  text-align: center;
}

#workingtimes__list {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin: 0 auto;
  width: 100%;
  max-width: 600px;
  gap: 1rem;
}
</style>
