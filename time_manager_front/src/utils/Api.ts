import axios from "axios";

export default axios.create({
  baseURL: `${import.meta.env.VITE_AXIOSBASEURL}`,
});

export const authorize = (accessToken: string): any => {
  return {
    headers: { authorization: accessToken },
  };
};
