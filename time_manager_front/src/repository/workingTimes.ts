import {
  ICreateWorkingTime,
  IUpdateWorkingTime,
  IWorkingTime,
} from "@/dto/workingTime";
import Api, { authorize } from "@/utils/Api";

// User Routes

const getAllWorkingTimesByUser = async (userId: number) => {
  const { data } = await Api.get<IWorkingTime[]>(
    `/workingtimes/user/${userId}`,
    authorize(localStorage.getItem("access_token") ?? "")
  );
  return data;
};

const getWorkingTimesByUserByPeriod = async (
  userId: number,
  start: string,
  end: string
) => {
  const { data } = await Api.get<IWorkingTime[]>(
    `/workingtimes/user/${userId}?start=${start}&end=${end}`,
    authorize(localStorage.getItem("access_token") ?? "")
  );
  return data;
};

const getWorkingTimeByUserById = async (
  userId: number,
  workingTimeId: number
) => {
  const { data } = await Api.get<IWorkingTime>(
    `/workingtimes/user/${userId}/${workingTimeId}`,
    authorize(localStorage.getItem("access_token") ?? "")
  );
  return data;
};

const createWorkingTime = async (
  userId: number,
  workingTime: ICreateWorkingTime
) => {
  const { data } = await Api.post<IWorkingTime>(
    `/workingtimes/user/${userId}`,
    workingTime,
    authorize(localStorage.getItem("access_token") ?? "")
  );
  return data;
};

// Manager Routes

const getWorkingTimeById = async (workingTimeId: number) => {
  const { data } = await Api.get<IWorkingTime>(
    `/workingtimes/entry/${workingTimeId}`,
    {
      headers: {
        Authorization: `${localStorage.getItem("token")}`,
      },
    } as any
  );
  return data;
};

const updateWorkingTime = async (
  workingTimeId: number,
  workingTime: IUpdateWorkingTime
) => {
  const { data } = await Api.patch<IWorkingTime>(
    `/workingtimes/entry/${workingTimeId}`,
    workingTime,
    {
      headers: {
        Authorization: `${localStorage.getItem("token")}`,
      },
    } as any
  );
  return data;
};

const deleteWorkingTime = async (workingTimeId: number) => {
  const { data } = await Api.delete<IWorkingTime>(
    `/workingtimes/entry/${workingTimeId}`,
    {
      headers: {
        Authorization: `${localStorage.getItem("token")}`,
      },
    } as any
  );
  return data;
};

const getTeamWorkingTime = async (
  teamId: string,
  callback: (workingTimes: IWorkingTime[]) => void
) => {
  Api.get<IWorkingTime[]>(
    `/workingtimes/team/${teamId}`,
    authorize(localStorage.getItem("access_token") ?? "")
  )
    .then((value) => {
      return callback(value.data);
    })
    .catch((err) => {
      return callback([]);
    });
};

const getTeamWorkingTimeByPeriod = async (
  teamId: string,
  start: string,
  end: string,
  callback: (workingTimes: IWorkingTime[]) => void
) => {
  Api.get<IWorkingTime[]>(
    `/workingtimes/team/${teamId}?start=${start}&end=${end}`,
    authorize(localStorage.getItem("access_token") ?? "")
  )
    .then((value) => {
      return callback(value.data);
    })
    .catch((err) => {
      return callback([]);
    });
};

const getUserWorkingTime = async (callback: (workingTimes: IWorkingTime[]) => void) => {
  Api.get<IWorkingTime[]>(
    `/workingtimes/me`,
    authorize(localStorage.getItem("access_token") ?? "")
  )
    .then((value) => {
      return callback(value.data);
    })
    .catch((err) => {
      return callback([]);
    });
}

const workingTimeRepository = {
  getAllWorkingTimesByUser,
  getTeamWorkingTime,
  getTeamWorkingTimeByPeriod,
  getWorkingTimesByUserByPeriod,
  getWorkingTimeByUserById,
  createWorkingTime,
  getWorkingTimeById,
  updateWorkingTime,
  deleteWorkingTime,
};

export default workingTimeRepository;
