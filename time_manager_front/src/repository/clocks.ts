import { IClock } from "@/dto/clock";
import Api from "@/utils/Api";

const getClock = async () => {
    const { data } = await Api.get<IClock>('/clocks', {
        headers: {
            Authorization: `${localStorage.getItem("access_token")}`,
        },
    });
    return data;
}

const createClock = async () => {
    const { data } = await Api.post<IClock>('/clocks', {}, {
        headers: {
            Authorization: `${localStorage.getItem("access_token")}`,
        },
    });
    return data;
}

const clockRepository = {
    getClock,
    createClock
}

export default clockRepository;