<template>
  <v-app>
    <main class="flex h-full w-[100%]">
      <router-view class="flex h-full w-[100%]" />
    </main>
  </v-app>
</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  name: "App",

  data() {
    return {
      //
    };
  },
});
</script>
