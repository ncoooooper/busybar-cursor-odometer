import type {Page} from "@shared/instrument";
import {rect, type Frame} from "@shared/surface";

export function marks(_page: Page, pages: Page[], index: number): Frame {
  const readings = pages.slice(0,2);
  if (readings.length !== 2 || readings.some(p=>!/^\d+(\.\d+)?m$/.test(p.value))) return [];
  const meters = readings.map(p=>parseFloat(p.value));
  const longest = Math.max(1, ...meters);
  const result: Frame = [rect("selected-day",49,7+index*5,2,3,"#F4DBA9FF")];
  for (let i=0; i<2; i++) {
    const y = 7+i*5, width = Math.round(18*meters[i]/longest);
    if (width<18) result.push(rect("track"+i,52+width,y,18-width,3,"#273530FF"));
    if (width) result.push(rect("distance"+i,52,y,width,3,i===index?"#A3E6C3FF":"#547D72FF"));
  }
  return result;
}
