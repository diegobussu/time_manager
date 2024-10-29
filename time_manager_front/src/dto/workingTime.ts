import { IUser } from "./user";

export interface IWorkingTime {
    id: number;
    start: string;
    end: string;
    user: IUser;
}

export interface ICreateWorkingTime {
    start: string;
    end: string;
}

export interface IUpdateWorkingTime {
    start?: string;
    end?: string;
}