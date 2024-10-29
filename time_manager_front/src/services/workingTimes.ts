import {
  ICreateWorkingTime,
  IUpdateWorkingTime,
  IWorkingTime,
} from "@/dto/workingTime";
import workingTimeRepository from "@/repository/workingTimes";

const getWorkingTimes = async (userId: number, start: string, end: string) => {
  const workingTimes =
    await workingTimeRepository.getWorkingTimesByUserByPeriod(
      userId,
      start,
      end
    );
  return workingTimes;
};

const getTeamWorkingTimes = (
  id: string,
  callback: (workingTimes: IWorkingTime[]) => void
) => {
  return workingTimeRepository.getTeamWorkingTime(id, callback);
};

const getTeamWorkingTimesByPeriod = (
  id: string,
  start: string,
  end: string,
  callback: (workingTimes: IWorkingTime[]) => void
) => {
  return workingTimeRepository.getTeamWorkingTimeByPeriod(
    id,
    start,
    end,
    callback
  );
};

const createWorkingTime = async (
  userId: number,
  workingTime: ICreateWorkingTime
) => {
  const createdWorkingTime = await workingTimeRepository.createWorkingTime(
    userId,
    workingTime
  );
  return createdWorkingTime;
};

const updateWorkingTime = async (
  workingTimeId: number,
  workingTime: IUpdateWorkingTime
) => {
  const updatedWorkingTime = await workingTimeRepository.updateWorkingTime(
    workingTimeId,
    workingTime
  );
  return updatedWorkingTime;
};

const deleteWorkingTime = async (workingTimeId: number) => {
  const deletedWorkingTime = await workingTimeRepository.deleteWorkingTime(
    workingTimeId
  );
  return deletedWorkingTime;
};

const workingTimeService = {
  getWorkingTimes,
  createWorkingTime,
  updateWorkingTime,
  deleteWorkingTime,
  getTeamWorkingTimes,
  getTeamWorkingTimesByPeriod,
};

export default workingTimeService;
