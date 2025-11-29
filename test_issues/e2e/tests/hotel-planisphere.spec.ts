import { test, expect } from '@playwright/test';

const BASE_URL = 'https://hotel-example-site.takeyaqa.dev/ja';

test.describe('Hotel Planisphere', () => {
  test('課題1-2〜1-5: 会員登録入力が完了し、マイページに反映される', async ({ page }) => {
    // トップページから会員登録ページへ遷移
    await page.goto(`${BASE_URL}/`);
    await page.getByRole('link', { name: '会員登録' }).click();
    await expect(page).toHaveURL(`${BASE_URL}/signup.html`);

    const uniqueSuffix = Date.now();
    // テストの再実行でも重複しないようにユニークなemailを生成
    const email = `test-${uniqueSuffix}@example.com`;
    const password = 'Password123!';
    const username = 'Daiki';
    const address = '東京都';
    const tel = '03123456789';
    const birthday = '1990-05-15';

    // 各入力欄に値を設定
    await page.fill('#email', email);
    await page.fill('#password', password);
    await page.fill('#password-confirmation', password);
    await page.fill('#username', username);
    await page.check('#rank-normal');
    await page.fill('#address', address);
    await page.fill('#tel', tel);
    await page.selectOption('#gender', '1');
    await page.fill('#birthday', birthday);
    await page.check('#notification');

    // 登録ボタンを押してマイページに移動するまで待機
    await page.getByRole('button', { name: '登録' }).click();
    await expect(page).toHaveURL(/\/mypage\.html/);

    // マイページで入力内容が反映されていることを検証
    await expect(page.locator('#email')).toHaveText(email);
    await expect(page.locator('#username')).toHaveText(username);
    await expect(page.locator('#rank')).toHaveText('一般会員');
    await expect(page.locator('#address')).toHaveText(address);
    await expect(page.locator('#tel')).toHaveText(tel);
    await expect(page.locator('#gender')).toHaveText('男性');
    await expect(page.locator('#birthday')).toHaveText('1990年5月15日');
    await expect(page.locator('#notification')).toHaveText('受け取る');
  });

  test('課題1-6: 宿泊予約の入力値が予約内容確認に反映される', async ({ page }) => {
    // トップページから宿泊予約プラン一覧へ遷移
    await page.goto(`${BASE_URL}/`);
    await page.getByRole('link', { name: '宿泊予約' }).click();
    await expect(page).toHaveURL(`${BASE_URL}/plans.html`);

    // 「このプランで予約」リンクから予約ページのポップアップを開く
    const [reservePage] = await Promise.all([
      page.waitForEvent('popup'),
      page.getByRole('link', { name: 'このプランで予約' }).first().click(),
    ]);
    await reservePage.waitForLoadState();

    // 予約に使用する入力値を用意
    const today = new Date();
    const checkInDate = new Date(today);
    checkInDate.setDate(checkInDate.getDate() + 7);
    const stayNights = 2;
    const headCount = 2;
    const reservationUsername = 'Daiki';
    const uniqueSuffix = Date.now();
    const reservationEmail = `test-${uniqueSuffix}@example.com`;
    const reservationComment = 'Reservation created by Playwright test.';

    // カレンダーウィジェットを使いチェックイン日を選択
    const dateField = reservePage.locator('#date');
    await dateField.click();
    const needsNextMonth =
      checkInDate.getMonth() !== today.getMonth() || checkInDate.getFullYear() !== today.getFullYear();
    // チェックイン日が来月だった場合は月移動する
    if (needsNextMonth) {
      await reservePage.locator('.ui-datepicker-next').click();
    }
    const calendar = reservePage.locator('.ui-datepicker-calendar');
    await calendar
      // 今月のセル(td) だけに絞る
      .locator('td:not(.ui-datepicker-other-month)')
      // リンクテキストが日付の数字と完全一致する要素をクリック
      .getByRole('link', { name: String(checkInDate.getDate()), exact: true })
      .click();

    // フォーム各項目へ値を入力
    const dateDisplay = await dateField.inputValue();
    await reservePage.fill('#term', String(stayNights));
    await reservePage.fill('#head-count', String(headCount));
    await reservePage.check('#breakfast');
    await reservePage.check('#sightseeing');
    await reservePage.fill('#username', reservationUsername);
    await reservePage.selectOption('#contact', 'email');
    await reservePage.fill('#email', reservationEmail);
    await reservePage.fill('#comment', reservationComment);

    // 入力した内容がそのまま反映されているか確認
    await expect(dateField).toHaveValue(dateDisplay);
    await expect(reservePage.locator('#term')).toHaveValue(String(stayNights));
    await expect(reservePage.locator('#head-count')).toHaveValue(String(headCount));

    // 確認画面へ遷移する前にボタン状態をチェック
    const submitButton = reservePage.locator('#submit-button');
    await expect(submitButton).toBeEnabled();

    await submitButton.click();
    await expect(reservePage).toHaveURL(`${BASE_URL}/confirm.html`);

    // 確認画面のチェックイン/アウトの日付表示を計算
    const [selectedYear, selectedMonth, selectedDay] = dateDisplay
      .split('/')
      .map((value) => Number(value));
    const selectedDate = new Date(selectedYear, selectedMonth - 1, selectedDay);
    const checkoutDate = new Date(selectedDate.getTime());
    checkoutDate.setDate(checkoutDate.getDate() + stayNights);
    const checkInText = `${selectedDate.getFullYear()}年${selectedDate.getMonth() + 1}月${selectedDate.getDate()}日`;
    const checkoutText = `${checkoutDate.getFullYear()}年${checkoutDate.getMonth() + 1}月${checkoutDate.getDate()}日`;
    const termText = `${checkInText} 〜 ${checkoutText} ${stayNights}泊`;

    // 確認画面に入力内容が反映されていることを検証
    await expect(reservePage.locator('#plan-name')).toHaveText('お得な特典付きプラン');
    await expect(reservePage.locator('#term')).toHaveText(termText);
    await expect(reservePage.locator('#head-count')).toHaveText(`${headCount}名様`);
    await expect(reservePage.locator('#plans')).toContainText('朝食バイキング');
    await expect(reservePage.locator('#plans')).toContainText('お得な観光プラン');
    await expect(reservePage.locator('#username')).toHaveText(`${reservationUsername}様`);
    await expect(reservePage.locator('#contact')).toHaveText(`メール：${reservationEmail}`);
    await expect(reservePage.locator('#comment')).toHaveText(reservationComment);

    // 確定ボタンを押して完了モーダルを検証
    await reservePage.getByRole('button', { name: 'この内容で予約する' }).click();
    const successModal = reservePage.locator('#success-modal');
    await expect(successModal).toContainText('予約を完了しました');
    await reservePage.getByRole('button', { name: '閉じる' }).click();
  });
});
