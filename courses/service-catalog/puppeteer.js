const puppeteer = require('puppeteer');

const startUrl = process.env.STOREDOG_URL;
console.log('starting...');

if (!startUrl) {
  console.log('No start URL provided');
  process.exit(1);
}

const getNewBrowser = async () => {
  const browser = await puppeteer.launch({
    defaultViewport: null,
    timeout: 30000,
    slowMo: 1000,
    args: [
      // Required for Docker version of Puppeteer
      '--no-sandbox',
      '--disable-setuid-sandbox',
      // This will write shared memory files into /tmp instead of /dev/shm,
      // because Docker’s default for /dev/shm is 64MB
      '--disable-dev-shm-usage',
    ],
  });
  const browserVersion = await browser.version();
  console.log(`Started ${browserVersion}`);
  return browser;
};

const choosePhone = () => {
  const deviceNames = [
    'Pixel 2 XL',
    'Pixel 2',
    'Galaxy S5',
    'iPhone 11 Pro Max',
    'iPhone 11',
    'iPhone XR',
    'iPhone X',
    'iPhone SE',
    'iPad Pro',
    'iPad Mini',
  ];

  const deviceIndex = Math.floor(Math.random() * deviceNames.length);
  const device = deviceNames[deviceIndex];
  return puppeteer.devices[device];
};

const randomlyCloseSession = async (browser, page, skipSessionClose) => {
  console.log('In randomlyCloseSession');

  if (skipSessionClose) {
    console.log('Skipping session close');
    return false;
  }

  const random = Math.floor(Math.random() * 15) + 1;
  if (random === 1) {
    console.log('Closing browser...');
    await page.close();
    await browser.close();
    return true;
  } else {
    return false;
  }
};

// select cool bits product on search page
const selectCoolBits = async (page) => {
  console.log('In selectHomePageProduct on page', await page.title());
  await page.waitForTimeout(8000);
  let productAriaLabel = 'Cool Bits';
  const selector = `[aria-label="${productAriaLabel}"]`;

  await Promise.all([page.waitForNavigation(), page.click(selector)]);
  await page.waitForTimeout(5000);
  const pageTitle = await page.title();
  console.log(`"${pageTitle}" loaded`);
  return;
};

// select a random product on the home page
const selectHomePageProduct = async (page) => {
  console.log('In selectHomePageProduct on page', await page.title());
  await page.waitForTimeout(8000);
  const allProducts = await page.$$('.product-item');
  const randomProductIndex = Math.floor(Math.random() * allProducts.length);
  const randomProduct = allProducts[randomProductIndex];
  // reassign selector to the random product's aria-label
  const productAriaLabel = await randomProduct.evaluate((el) =>
    el.getAttribute('aria-label')
  );

  const selector = `[aria-label="${productAriaLabel}"]`;

  await Promise.all([page.waitForNavigation(), page.click(selector)]);
  await page.waitForTimeout(5000);
  const pageTitle = await page.title();
  console.log(`"${pageTitle}" loaded`);
  return;
};

// when on product page, add to cart
const addToCart = async (page) => {
  console.log('In addToCart on page', await page.title());
  let selector = '#add-to-cart-button';
  await page.click(selector);
  selector = '#close-sidebar';
  const sidebarEl = await page.$(selector);
  await sidebarEl.evaluate((el) => el.click());
  return;
};

// select related product on product page
const selectRelatedProduct = async (page) => {
  console.log('In selectRelatedProduct on page', await page.title());
  const selector = '[aria-label="Learning Bits"]';
  await Promise.all([page.waitForNavigation(), page.click(selector)]);
  const pageTitle = await page.title();
  console.log(`"${pageTitle}" loaded`);
  return;
};

// select product on search page
const selectSearchPageProduct = async (page) => {
  // go to all products page
  let selector = 'nav#main-navbar a:first-child';
  const button = await page.$(selector);
  await Promise.all([
    button.evaluate((b) => b.click()),
    page.waitForNavigation(),
  ]);

  selector = '.product-grid';
  await page.waitForSelector(selector);
  // does selector exist
  const productGrid = await page.$(selector);
  if (!productGrid) {
    console.log("didn't find product grid");
    return;
  }

  // get products and select one at random
  const products = await page.$$('.product-item');
  let productIndex = Math.floor(Math.random() * products.length);
  let product = products[productIndex];
  let productThumbnail = await product.$('img');
  // click on product
  let [_, navigation] = await Promise.allSettled([
    productThumbnail.click(),
    page.waitForNavigation(),
  ]);

  // if it didn't go anywhere, try again
  if (navigation.status !== 'fulfilled') {
    await Promise.all([
      productThumbnail.evaluate((el) => {
        el.click();
        el.click();
        el.click();
      }),
      page.waitForTimeout(5000),
    ]);

    if (Math.floor(Math.random() * 20) === 0) {
      console.log('Frustrated and closing browser...');
      await page.goto('https://google.com', {
        waitUntil: 'domcontentloaded',
      });
      await page.close();
      return;
    }
    let productLink = await product.$('a');
    [_, navigation] = await Promise.allSettled([
      productLink.evaluate((el) => {
        el.click();
        el.click();
      }),
      page.waitForNavigation(),
    ]);
    pageTitle = await page.title();
    console.log(`"${pageTitle}" loaded`);
  }
};

const useDiscountCode = async (page) => {
  console.log('In useDiscountCode on page', await page.title());
  // get discount form
  const selector = '#discount-form';
  await page.waitForTimeout(5000);

  const discountForm = await page.$(selector);
  await page.waitForTimeout(5000);

  // get discount code input
  const discountCodeInput = await discountForm.$('input');
  await page.waitForTimeout(5000);

  // enter discount code out of random array
  const discountCodes = [
    'DISCOUNT',
    'COOLBITS',
    'LEARNINGBITS',
    'BITS',
    'COOL',
    'STOREDOG',
    'STOREDOG10',
  ];
  const randomIndex = Math.floor(Math.random() * discountCodes.length);
  const discountCode = discountCodes[randomIndex];
  await discountCodeInput.type(discountCode, { delay: 250 });
  await page.waitForTimeout(8000);
  console.log('entered code', discountCode);

  // click apply button
  const applyButton = await discountForm.$('button');
  await applyButton.evaluate((el) => el.click());
  // wait for discount to be applied
  await page.waitForTimeout(5000);

  // try again
  await discountCodeInput.type(discountCode, { delay: 250 });
  await page.waitForTimeout(8000);
  console.log('entered code', discountCode);

  // click apply button
  await applyButton.evaluate((el) => el.click());
  await page.waitForTimeout(8000);

  return;
};

const checkout = async (page, useDiscount) => {
  console.log('In checkout on page', await page.title());
  let selector = 'nav#user-nav button.toggle-cart';
  await page.waitForSelector(selector, { visible: true });
  await Promise.all([
    page.waitForTimeout(8000),
    page.click(selector, { delay: 250 }),
  ]);
  page.waitForTimeout(8000);

  selector = 'div#proceed-to-checkout .checkout-btn';
  await page.waitForSelector(selector, { visible: true });
  let el = await page.$(selector);
  console.log('opened cart');
  await Promise.all([
    page.waitForTimeout(8000),
    page.click(selector, { delay: 250 }),
  ]);
  page.waitForTimeout(8000);

  // if useDiscount is true, try to enter a discount (and get errors)
  if (useDiscount) {
    await useDiscountCode(page);
    await page.close();
  }

  selector = 'form#checkout-form .confirm-purchase-btn';
  el = await page.$(selector);
  // console.log('confirm purchase btn', el);
  await page.waitForSelector(selector, { visible: true });
  console.log('proceeded to checkout');
  await Promise.all([
    page.waitForTimeout(5000),
    el.evaluate((el) => el.click()),
  ]);
  page.waitForTimeout(10000);

  selector = '.purchase-confirmed-msg';
  await page.waitForSelector(selector, { visible: true });
  el = await page.$(selector);
  console.log('purchase confirmed');

  console.log('Checkout complete');
  await page.waitForTimeout(8000);
  return;
};

const mainSession = async () => {
  const browser = await getNewBrowser();
  let selector;

  try {
    const page = await browser.newPage();
    if (Math.floor(Math.random() * 6) === 0) {
      await page.emulate(choosePhone());
    }

    await page.setDefaultNavigationTimeout(
      process.env.PUPPETEER_TIMEOUT || 40000
    );

    // go to home page
    await page.goto(startUrl, { waitUntil: 'domcontentloaded' });

    const pageTitle = await page.title();
    console.log(`"${pageTitle}" loaded`);

    await selectCoolBits(page);
    await addToCart(page);

    // maybe purchase that extra product
    if (Math.floor(Math.random() * 3) === 0) {
      await selectRelatedProduct(page);
      await addToCart(page);
    }

    // maybe go back to the home page and purchase another product
    if (Math.floor(Math.random() * 3) === 0) {
      selector = '[href="/"]';
      const logo = await page.$(selector);
      await logo.evaluate((el) => el.click());
      await page.waitForNavigation();
      await selectHomePageProduct(page);
      await page.waitForTimeout(4000);
      await addToCart(page);
    }

    // maybe do that again
    if (Math.floor(Math.random() * 3) === 0) {
      selector = '[href="/"]';
      const logo = await page.$(selector);
      await logo.evaluate((el) => el.click());
      await page.waitForNavigation();
      await selectHomePageProduct(page);
      await page.waitForTimeout(4000);
      await addToCart(page);
    }

    // maybe do that again
    if (Math.floor(Math.random() * 3) === 0) {
      selector = '[href="/"]';
      const logo = await page.$(selector);
      await logo.evaluate((el) => el.click());
      await page.waitForNavigation();
      await selectHomePageProduct(page);
      await page.waitForTimeout(4000);
      await addToCart(page);
    }

    await checkout(page);
    await page.waitForTimeout(10000);
    await page.close();
  } catch (err) {
    console.log(`Session failed: ${err}`);
  } finally {
    await browser.close();
    if (browser && browser.process() != null) browser.process().kill('SIGINT');
  }
};

// has some frustration signals due to a incorrect product item UI component configuration in the search page
const secondSession = async () => {
  const browser = await getNewBrowser();

  try {
    const page = await browser.newPage();
    if (Math.floor(Math.random() * 6) === 0) {
      await page.emulate(choosePhone());
    }

    await page.setDefaultNavigationTimeout(
      process.env.PUPPETEER_TIMEOUT || 40000
    );

    // go to home page
    await page.goto(startUrl, { waitUntil: 'domcontentloaded' });
    let pageTitle = await page.title();
    console.log(`"${pageTitle}" loaded`);

    // go to all products page (and maybe leave)
    await selectSearchPageProduct(page);
    await addToCart(page);

    // maybe select a related product
    if (Math.floor(Math.random() * 2) === 0) {
      await selectRelatedProduct(page);
      await addToCart(page);
    }

    // maybe try to find another product on the search page
    if (Math.floor(Math.random() * 4) === 0) {
      await selectSearchPageProduct(page);
      await addToCart(page);
    }

    // maybe try to find another product on the search page
    if (Math.floor(Math.random() * 10) === 0) {
      await selectSearchPageProduct(page);
      await addToCart(page);
    }

    await page.waitForTimeout(5000);
    await checkout(page, true);
    console.log('Second session complete');
    await page.waitForTimeout(10000);
    await page.goto('https://google.com', { waitUntil: 'domcontentloaded' });
    await page.close();
  } catch (err) {
    console.log(`Session failed: ${err}`);
  } finally {
    await browser.close();
  }
};

(() => mainSession())();
(() => secondSession())();
(() => mainSession())();
(() => secondSession())();
(() => mainSession())();
(() => secondSession())();
