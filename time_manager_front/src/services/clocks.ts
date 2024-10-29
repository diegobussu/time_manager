import clockRepository from "@/repository/clocks";

const getClock = async () => {
    const clock = await clockRepository.getClock();
    return clock;
}

const createClock = async () => {
    const createdClock = await clockRepository.createClock();
    return createdClock;
}

