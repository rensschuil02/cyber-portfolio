import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  site: 'https://rensschuil02.github.io',
  base: '/cyber-portfolio',
  trailingSlash: 'ignore',
  integrations: [mdx()],
  vite: {
    plugins: [tailwindcss()],
  },
  markdown: {
    shikiConfig: {
      // Terminal-friendly code highlighting
      theme: 'github-dark',
    },
  },
});
