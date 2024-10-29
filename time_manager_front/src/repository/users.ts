import { IUpdateUser, IUser } from "@/dto/user";
import Api, { authorize } from "@/utils/Api";

const getUserById = async (id: string) => {
  const { data } = await Api.get<IUser>(`/users/${id}`, {
    headers: {
      Authorization: `${localStorage.getItem("access_token")}`,
    },
  } as any);
  return data;
};

const getMe = async (
  accessToken: string,
  callback: (user?: IUser, error?: string) => void
) => {
  await Api.get<IUser>(`/users/me`, authorize(accessToken))
    .then((response) => {
      callback(response.data);
    })
    .catch((err) => {
      callback(
        undefined,
        "An error occurred while retrieving your data!"
      );
    });
};

const deleteUser = async (accessToken: string) => {
  await Api.delete<IUser>(`/users/me`, authorize(accessToken));
};

const deleteUsers = async (accessToken: string, userId: string) => {
  await Api.delete<IUser>(`/users/${userId}`, authorize(accessToken));
};

const deleteUserById = async (id: number) => {
  const { data } = await Api.delete<IUser[]>(`/users/${id}`, {
    headers: {
      Authorization: `${localStorage.getItem("access_token")}`,
    },
  });
  return data;
};

const getAllUsers = async () => {
  const { data } = await Api.get<IUser[]>("/users", {
    headers: {
      Authorization: `${localStorage.getItem("access_token")}`,
    },
  });
  return data;
};

const updateUser = async (
  accessToken: string,
  id: number,
  updateUser: IUpdateUser
) => {
  const { data } = await Api.put<IUser>(
    `/users/${id}`,
    {
      user: updateUser,
    },
    authorize(accessToken)
  );
  return data;
};

const updateMyUser = async (accessToken: string, updateUser: IUpdateUser) => {
  const { data } = await Api.put<IUser>(
    `/users/me`,
    { user: updateUser },
    authorize(accessToken)
  );
  return data;
};

const resetMyPassword = (
  accessToken: string,
  new_password: string,
  last_password: string
) => {
  return Api.post(
    "/users/reset-password",
    { new_password, last_password },
    authorize(accessToken)
  );
};

const resetPassword = (
  accessToken: string,
  id: string,
  new_password: string
) => {
  return Api.post(
    `/users/${id}/reset-password`,
    { new_password },
    authorize(accessToken)
  );
};

const userRepository = {
  getMe,
  getUserById,
  getAllUsers,
  updateMyUser,
  updateUser,
  deleteUser,
  resetMyPassword,
  deleteUsers,
  deleteUserById,
  resetPassword,
};

export default userRepository;
