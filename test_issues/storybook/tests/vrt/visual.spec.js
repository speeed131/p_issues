import { test } from '@playwright/test';
import fs from 'node:fs/promises';
import path from 'node:path';

const baseUrl = process.env.STORYBOOK_URL ?? 'http://127.0.0.1:6006';
const actualDir = path.resolve(process.cwd(), 'directory_contains_actual_images');

async function loadStories() {
  const response = await fetch(new URL('/index.json', baseUrl));
  if (!response.ok) {
    throw new Error(`Failed to load Storybook index.json (status ${response.status})`);
  }

  const payload = await response.json();
  const entries = payload.entries ?? payload.stories ?? {};
  const stories = Object.values(entries)
    .filter((story) => story.type === 'story')
    .map(({ id, title, name }) => ({ id, title, name }))
    .sort((a, b) => a.id.localeCompare(b.id));

  if (!stories.length) {
    throw new Error('No stories found for visual regression capture.');
  }

  return stories;
}

async function resetActualDir() {
  // 前回のスクリーンショットを一掃してから今回の actual を詰め直す
  await fs.rm(actualDir, { recursive: true, force: true });
  await fs.mkdir(actualDir, { recursive: true });
}

test.beforeAll(async () => {
  await resetActualDir();
});

test('captures Storybook stories for visual regression', async ({ page }) => {
  const stories = await loadStories();

  for (const story of stories) {
    await test.step(`capture ${story.id}`, async () => {
      const storyUrl = new URL('/iframe.html', baseUrl);
      storyUrl.searchParams.set('id', story.id);
      storyUrl.searchParams.set('viewMode', 'story');

      await page.goto(storyUrl.toString(), { waitUntil: 'networkidle' });
      await page.waitForLoadState('networkidle');

      const screenshotPath = path.join(actualDir, `${story.id}.png`);
      await page.screenshot({
        path: screenshotPath,
        fullPage: true,
        animations: 'disabled',
        scale: 'device',
      });
    });
  }
});
