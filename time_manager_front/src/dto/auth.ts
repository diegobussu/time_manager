import {IUser} from "@/dto/user";

export interface IAuthLogin {
  user: IUser;
  access_token: string;
}