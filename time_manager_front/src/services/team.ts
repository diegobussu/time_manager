import {ICreateTeam, IEditTeam, ITeam, IUserTeam} from "@/dto/team";
import Api, {authorize} from "@/utils/Api";

export const createTeam = (accessToken: string, body: ICreateTeam, callback: (team?: ITeam, error?: string) => void) => {
  Api.post<ITeam>('/teams/', body, authorize(accessToken)).then((response) => {
    return callback(response.data);
  }).catch((err) => {
    return callback(undefined, "An error has occurred");
  });
}

export const getTeams = (accessToken: string, callback: (teams: ITeam[], error?: string) => void) => {
  Api.get<ITeam[]>('/teams/', authorize(accessToken)).then((response) => {
    return callback(response.data);
  }).catch((err) => {
    return callback([], "An error has occurred");
  });
}

export const getTeam = (accessToken: string, teamId: string, callback: (team?: ITeam, error?: string) => void) => {
  Api.get<ITeam>(`/teams/${teamId}`, authorize(accessToken)).then((response) => {
    return callback(response.data);
  }).catch((err) => {
    return callback(undefined, "An error has occurred");
  });
}

export const editTeam = (accessToken: string, teamId: string, body: IEditTeam, callback: (team?: ITeam, error?: string) => void) => {
  Api.patch<ITeam>(`/teams/${teamId}`, body, authorize(accessToken)).then((response) => {
    return callback(response.data);
  }).catch((err) => {
    return callback(undefined, "An error has occurred");
  });
}

export const deleteTeam = (accessToken: string, teamId: string, callback: (team?: ITeam, error?: string) => void) => {
  Api.delete<ITeam>(`/teams/${teamId}`, authorize(accessToken)).then((response) => {
    return callback(response.data);
  }).catch((err) => {
    return callback(undefined, "An error has occurred");
  });
}

export const addUserTeam = async (accessToken: string, teamId: string, body: IUserTeam) => {
  return await Api.post<ITeam>(`/teams/${teamId}/members/add`, body, authorize(accessToken));
}

export const removeUserTeam = (accessToken: string, teamId: string, body: IUserTeam, callback: (team?: ITeam, error?: string) => void) => {
  Api.post<ITeam>(`/teams/${teamId}/members/remove`, body, authorize(accessToken)).then((response) => {
    return callback(response.data);
  }).catch((err) => {
    return callback(undefined, "An error has occurred");
  });
}