import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import NavigationDrawer from "@/components/NavigationDrawer.vue";
import { IsLogged, useAuthStore } from "@/store/AuthStore";
import TeamListPage from "@/views/teams/TeamListPage.vue";
import TeamPage from "@/views/teams/TeamPage.vue";
import ProfilePage from "@/views/users/ProfilePage.vue";
import NotFoundPage from "@/views/NotFoundPage.vue";
import UsersManagement from "@/views/users/UsersManagement.vue";
import ChangePasswordPage from "@/views/users/ChangePasswordPage.vue";
import ResetPasswordPage from "@/views/users/ResetPasswordPage.vue";
import DashboardUser from "@/views/DashboardUser.vue";
import WorkingTimes from "@/views/workingtimes/WorkingTimes.vue";
import WorkingTime from "@/views/workingtimes/WorkingTime.vue";
import Login from "@/views/auth/Login.vue";
import Register from "@/views/auth/Register.vue";

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: "/login",
      name: "login",
      component: Login,
      meta: { title: "ShiftSync - Log in" },
    },
    {
      path: "/register",
      name: "register",
      component: Register,
      meta: { title: "ShiftSync - Register" },
    },
    {
      path: "/",
      component: NavigationDrawer,
      children: [
        {
          path: "/",
          component: HomeView,
          name: "home",
          meta: { title: "ShiftSync - Dashboard" },
        },
        {
          path: "/workingtimes/:userid/:workingtimeid",
          name: "workingtime",
          component: WorkingTime,
          meta: { title: "ShiftSync - Working time" },

        },
        {
          strict: true,
          path: "/workingtimes/",
          name: "workingtimesMe",
          component: WorkingTimes,
          meta: { title: "ShiftSync - Working times" },
        },
        {
          path: "/workingtimes/:userid",
          name: "workingtimes",
          component: WorkingTimes,
          meta: { title: "ShiftSync - Working times" },
        },
        {
          path: "/teams",
          children: [
            {
              path: "",
              name: "teams",
              component: TeamListPage,
              meta: { title: "ShiftSync - Teams" },
            },
            {
              path: ":id",
              name: "team",
              component: TeamPage,
              meta: { title: "ShiftSync - Team dashboard" },
            },
          ],
        },
        {
          path: "/user/profile",
          name: "myProfile",
          component: ProfilePage,
          meta: { title: "ShiftSync - My Profile" },
        },
        {
          path: "/user/:id/profile",
          name: "profile",
          component: ProfilePage,
          meta: { title: "ShiftSync - User profile" },
        },
        {
          path: "/user/:id/dashboard",
          name: "dashboard",
          component: DashboardUser,
          meta: { title: "ShiftSync - User dashboard" },
        },
        {
          path: "/user/reset-password",
          name: "reset-password",
          component: ChangePasswordPage,
          meta: { title: "ShiftSync - Change password" },
        },
        {
          path: "/user/:id/reset-password",
          name: "reset-password-user",
          component: ResetPasswordPage,
          meta: { title: "ShiftSync - Reset password" },
        },
        {
          path: "/users-management",
          name: "users-management",
          component: UsersManagement,
          meta: { title: "ShiftSync - Users" },
        },
        {
          path: "/:catchAll(.*)",
          component: NotFoundPage,
          meta: { title: "ShiftSync - Not found" },
        },
      ],
    },
    {
      path: "/:pathMatch(.*)*",
      name: "not-found",
      component: NotFoundPage,
      meta: { title: "ShiftSync - Not found" },
    },
  ],
});

router.beforeEach((to) => {
  const { isLogged, user } = useAuthStore();

  if (
    to.name !== "register" &&
    to.name !== "login" &&
    isLogged !== IsLogged.Logged
  ) {
    return { name: "login" };
  }
});

export default router;
