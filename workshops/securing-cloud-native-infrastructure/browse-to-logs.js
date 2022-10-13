// This script performs a login to Datadog, then browses to the /logs page

const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
  const page = await browser.newPage();
  console.log("Logging in to Datadog");
  await page.goto('https://app.datadoghq.com');
  await page.type('input[id=username]', process.env.LABUSER);
  await page.type('input[name=password]', process.env.NEWPASSWORD);
  await page.keyboard.press('Enter');
  await page.waitForTimeout(5000);
  console.log("Browsing to /logs");
  await page.goto('https://app.datadoghq.com/logs')
  await page.waitForTimeout(5000);
  await browser.close();
})();
