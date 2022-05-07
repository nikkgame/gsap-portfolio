import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/dist/ScrollTrigger';
import { ScrollToPlugin } from 'gsap/dist/ScrollToPlugin';

export default defineNuxtPlugin(() => {
  gsap.registerPlugin(ScrollToPlugin, ScrollTrigger);

  return { provide: { gsap, ScrollToPlugin, ScrollTrigger } };
});
