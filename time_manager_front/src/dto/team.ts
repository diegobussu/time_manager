import {IUser} from "@/dto/user";

export interface ICreateTeam {
  name: string;
}

export interface IEditTeam {
  name: string;
}

export interface IUserTeam {
  user_id: string | number;
}

export interface ITeam {
  id: string;
  owner: IUser;
  members: IUser[];
  name: string;
  created_at: Date;
  updated_at: Date;
}