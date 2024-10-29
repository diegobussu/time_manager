import { DateTime } from "luxon";


export function convertHoursStringToDate(hoursString: string) {
    return(DateTime.fromFormat(hoursString, "HH:mm").toJSDate());
}
  
export function convertToHoursString(hours: number) {
    const hoursString = Math.floor(hours).toString().padStart(2, "0");
    const minutesString = Math.floor((hours - Math.floor(hours)) * 60).toString().padStart(2, "0");
    return `${hoursString}:${minutesString}`;
}