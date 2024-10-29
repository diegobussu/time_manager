<script setup lang="ts">
import { Vue3Lottie } from 'vue3-lottie'
import 'vue3-lottie/dist/style.css'

import notFound from '../assets/not-found.json'

</script>

<template>
  <h1>Not found</h1>
  <Vue3Lottie :animationData="notFound" :height="400" :width="500" />
</template>