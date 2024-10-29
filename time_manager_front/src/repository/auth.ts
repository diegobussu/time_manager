import { ICreateUser, IUser } from "@/dto/user";
import { IAuthLogin } from "@/dto/auth";
import Api from "@/utils/Api";

const authRepository = {
  login: async (email: string, password: string) => {
    const { data } = await Api.post<IAuthLogin>(`/auth/login`, {
      email,
      password,
    });
    return data;
  },
  register: async (createUser: ICreateUser) => {
    const { data } = await Api.post<IUser>("/auth/register", createUser);
    return data;
  },
};

export default authRepository;
