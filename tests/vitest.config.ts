import { defineConfig } from 'vite';

export default defineConfig({
  test: {
    include: ['ui/**/*.test.ts'],
    environment: 'jsdom',
    globals: false,
  },
} as any);
