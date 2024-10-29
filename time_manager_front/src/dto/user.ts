export enum userRank {
  "employee" = "employee",
  "manager" = "manager",
  "general_manager" = "general_manager",
}

export interface IUser {
  id: number;
  email: string;
  rank: userRank;
  lastname: string;
  firstname: string;
  insert_at: Date;
  updated_at: Date;
}

export interface IUpdateUser {
  email?: string;
  password?: string;
  rank?: userRank;
  lastname?: string;
  firstname?: string;
}

export interface ICreateUser {
  email: string;
  password: string;
  lastname?: string;
  firstname?: string;
}
