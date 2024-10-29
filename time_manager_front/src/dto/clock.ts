import { IUser } from "./user";

export interface IClock {
    id: number;
    status: boolean;
    time: string;
    user: IUser;
}