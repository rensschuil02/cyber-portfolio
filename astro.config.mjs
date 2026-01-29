import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';

// https://astro.build/config
export default defineConfig({
  site: 'https://rensschuil02.github.io',
  base: '/cyber-portfolio',
  integrations: [tailwind()],
});
