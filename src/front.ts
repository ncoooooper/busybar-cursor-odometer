import type {Page} from "@shared/instrument";
import {rect, type Frame} from "@shared/surface";

export function marks(_page: Page, pages: Page[], index: number): Frame {
  const readings = pages.slice(0,2);
  if (readings.length !== 2 || readings.some(p=>!/^\d+(\.\d+)?m$/.test(p.value))) return [];
  const meters = readings.map(p=>parseFloat(p.value));
  const longest = Math.max(1, ...meters);
  const result: Frame = [];
  for (let i=0; i<2; i++) {
    const y = 7+i*5, width = Math.round(18*meters[i]/longest);
    result.push(rect("track"+i,52,y,18,3,"#273530FF"));
    if (width) result.push(rect("distance"+i,52,y,width,3,i===index?"#A3E6C3FF":"#547D72FF"));
  }
  return result;
}
