import { IUser, IUpdateUser } from "@/dto/user";
import userRepository from "@/repository/users";

const getUserById = async (id: string) => {
  const user = await userRepository.getUserById(id);
  return user;
};
const getAllUsers = async () => {
  const users = await userRepository.getAllUsers();
  return users;
};
// const createUser = async (user: ICreateUser): Promise<IUser> => {
//   const created_user = await userRepository.CreateUser(user);
//   return created_user;
// };
const updateMyUser = async (accessToken: string, user: IUpdateUser) => {
  const updatedUser = await userRepository.updateMyUser(accessToken, user);
  return updatedUser;
};
const updateUser = async (
  accessToken: string,
  id: number,
  user: IUpdateUser
) => {
  await userRepository.updateUser(accessToken, id, user);
};
const deleteUser = async (accessToken: string) => {
  await userRepository.deleteUser(accessToken);
};

const resetMyPassword = async (
  accessToken: string,
  new_password: string,
  last_password: string
) => {
  await userRepository.resetMyPassword(
    accessToken,
    new_password,
    last_password
  );
};

const resetPassword = async (
  accessToken: string,
  id: string,
  new_password: string
) => {
  await userRepository.resetPassword(
    accessToken,
    id,
    new_password
  );
};

const userService = {
  getUserById,
  getAllUsers,
  updateMyUser,
  updateUser,
  deleteUser,
  resetMyPassword,
  resetPassword,
};

export default userService;
