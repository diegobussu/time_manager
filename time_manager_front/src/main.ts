import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";
import vuetify from "./plugins/vuetify";
import { loadFonts } from "./plugins/webfontloader";
import { createPinia } from "pinia";
import ToastPlugin from "vue-toast-notification";
import "vue-toast-notification/dist/theme-sugar.css";
import "vue3-lottie/dist/style.css";
import Vue3Lottie from "vue3-lottie";
import Datepicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";
import { useAuthStore } from "@/store/AuthStore";
import PrimeVue from "primevue/config";
import Aura from "@primevue/themes/aura";
import Button from "primevue/button";
import InputText from "primevue/inputtext";
import Password from "primevue/password";
import FloatLabel from "primevue/floatlabel";
import Card from "primevue/card";
import Dialog from "primevue/dialog";

import "./assets/css/main.css";
import { definePreset } from "@primevue/themes";

const Noir = definePreset(Aura, {
  semantic: {
    primary: {
      50: "{surface.50}",
      100: "{surface.100}",
      200: "{surface.200}",
      300: "{surface.300}",
      400: "{surface.400}",
      500: "{surface.500}",
      600: "{surface.600}",
      700: "{surface.700}",
      800: "{surface.800}",
      900: "{surface.900}",
      950: "{surface.950}",
    },
    colorScheme: {
      light: {
        primary: {
          color: "{primary.950}",
          contrastColor: "#ffffff",
          hoverColor: "{primary.900}",
          activeColor: "{primary.800}",
        },
        highlight: {
          background: "{primary.950}",
          focusBackground: "{primary.700}",
          color: "#ffffff",
          focusColor: "#ffffff",
        },
      },
      dark: {
        primary: {
          color: "{primary.50}",
          contrastColor: "{primary.950}",
          hoverColor: "{primary.100}",
          activeColor: "{primary.200}",
        },
        highlight: {
          background: "{primary.50}",
          focusBackground: "{primary.300}",
          color: "{primary.950}",
          focusColor: "{primary.950}",
        },
      },
    },
  },
});

// Fix Property 'env' does not exist on type 'ImportMeta'.
declare global {
  interface ImportMeta {
    env: {
      VITE_AXIOSBASEURL: string;
    };
  }
}

loadFonts();

const pinia = createPinia();

const app = createApp(App);

app.use(pinia);
app.use((app, options) => {
  const auth = useAuthStore();
  auth.loginFromStorage();
});
app.use(router);
app.use(vuetify);
app.use(Vue3Lottie);
app.component("Datepicker", Datepicker);
app.use(ToastPlugin, { position: "bottom-right" });
app.use(PrimeVue, {
  theme: {
    preset: Noir,
  },
});

app.component("Button", Button);
app.component("InputText", InputText);
app.component("Password", Password);
app.component("FloatLabel", FloatLabel);
app.component("FloatLabel", FloatLabel);
app.component("Card", Card);
app.component("Dialog", Dialog);
router.beforeEach((to, from, next) => {
  const defaultTitle = "ShiftSync"; // Titre par défaut
  document.title = to.meta.title || defaultTitle;
  next();
});

app.mount("#app");
