import { defineConfig, devices } from '@playwright/test';

const defaultBaseURL = 'http://127.0.0.1:6006';
const staticDir = 'storybook-static';
const baseURL = process.env.STORYBOOK_URL ?? defaultBaseURL;
const httpServerCommand = `node_modules/.bin/http-server ${staticDir} -a 127.0.0.1 -p 6006`;

const webServer = process.env.STORYBOOK_URL
  ? undefined
  : {
      command: httpServerCommand,
      url: baseURL,
      timeout: 30_000,
      reuseExistingServer: !process.env.CI,
    };

export default defineConfig({
  testDir: './tests/vrt',
  workers: 1,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0,
  reporter: 'list',
  use: {
    ...devices['Desktop Chrome'],
    baseURL,
  },
  ...(webServer ? { webServer } : {}),
});
