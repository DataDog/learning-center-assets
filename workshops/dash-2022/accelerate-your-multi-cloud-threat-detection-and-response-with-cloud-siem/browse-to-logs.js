// This script performs a login to Datadog, then browses to the /logs page
// This is currently needed to enable CWS as there is no programmatic way to reproduce
// the calls the browser is doing to /api/v1/logs/start_using_logs

const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
  const page = await browser.newPage();
  await page.goto('https://app.datadoghq.com');
  await page.type('input[id=username]', process.env.LABUSER);
  await page.type('input[name=password]', process.env.NEWPASSWORD);
  await page.keyboard.press('Enter');
  await page.waitForTimeout(5000);
  await page.goto('https://app.datadoghq.com/logs')
  await page.waitForTimeout(10000);
  await page.screenshot({ path: '/tmp/screenshot.png' });
  await browser.close();
})();