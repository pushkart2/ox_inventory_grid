import { defineConfig } from 'vitest/config';
import path from 'path';

export default defineConfig({
  resolve: {
    alias: {
      'vitest': path.resolve(__dirname, 'node_modules/vitest'),
      '@testing-library/react': path.resolve(__dirname, 'node_modules/@testing-library/react'),
      '@testing-library/dom': path.resolve(__dirname, 'node_modules/@testing-library/dom'),
    },
  },
  server: {
    fs: {
      allow: [path.resolve(__dirname, '..')],
    },
  },
  test: {
    root: path.resolve(__dirname, '..'),
    include: ['tests/ui/**/*.test.ts'],
    environment: 'jsdom',
    globals: false,
    deps: {
      moduleDirectories: [path.resolve(__dirname, 'node_modules')],
    },
  },
});
