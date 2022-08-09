//= require govuk_tech_docs

var cookieBanner = function () {
  const PROD_HOSTNAME = 'sign-in.service.gov.uk';
  const COOKIES_PREFERENCES_SET = "cookies_preferences_set";

  const cookiesAccepted = document.querySelector("#cookies-accepted");
  const cookiesRejected = document.querySelector("#cookies-rejected");
  const hideCookieBanner = document.querySelectorAll(".cookie-hide-button");
  const cookieBannerContainer = document.querySelector(".govuk-cookie-banner");
  const cookieBanner = document.querySelector("#cookies-banner-main");
  const acceptCookies = document.querySelector("#cookiesAccept");
  const rejectCookies = document.querySelector("#cookiesReject");
  const gaTrackingCode = 'GTM-W38DXV2';
  const cookiePreferencesExist =
    document.cookie.indexOf(COOKIES_PREFERENCES_SET + "=") > -1;

  function init() {
    if (isOnCookiesPage()) {
      cookiesPageInit();
      return;
    } else if (cookiePreferencesExist) {
      const analyticsEnabled = JSON.parse(getCookieValue(COOKIES_PREFERENCES_SET)).analytics;
      initGATagManager(analyticsEnabled);
      return;
    }

    showElement(cookieBannerContainer);

    acceptCookies.addEventListener(
      "click",
      function (event) {
        event.preventDefault();
        setCookie(COOKIES_PREFERENCES_SET, {"analytics": true});
        showElement(cookiesAccepted);
        hideElement(cookieBanner);
        initGATagManager(true);
      }.bind(this)
    );

    rejectCookies.addEventListener(
      "click",
      function (event) {
        event.preventDefault();
        setCookie(COOKIES_PREFERENCES_SET, {"analytics": false});
        showElement(cookiesRejected);
        hideElement(cookieBanner);
        initGATagManager(false);
      }.bind(this)
    );

    const hideButtons = Array.prototype.slice.call(hideCookieBanner);
    hideButtons.forEach(function (element) {
      element.addEventListener(
        "click",
        function (event) {
          event.preventDefault();
          hideElement(cookieBannerContainer);
        }.bind(this)
      );
    });
  }

  function isProdDomain() {
    return window.location.hostname.includes(PROD_HOSTNAME);
  }

  function isLocalhost() {
    return window.location.hostname.includes("localhost");
  }

  function isAws() {
    return window.location.hostname.includes("eu-west-2.elb.amazonaws.com");
  }

  function getCookiesDomainAttribute() {
    if (isProdDomain()) {
      return "; domain=" + PROD_HOSTNAME;
    }
    return "";
  }

  function getCookiesSecureAttribute() {
    if (isLocalhost() || isAws()) {
      return "";
    }
    return "; Secure";
  }

  function setCookie(name, value) {
    const currentDate = new Date();
    const expiryDate = new Date(
      currentDate.setMonth(currentDate.getMonth() + 12)
    );

    document.cookie =
      name + "=" + JSON.stringify(value) +
      getCookiesDomainAttribute() +
      "; expires=" + expiryDate +
      "; path=/" +
      getCookiesSecureAttribute();
  }

  function hideElement(el) {
    el.style.display = "none";
  }

  function showElement(el) {
    el.style.display = "block";
  }

  function isOnCookiesPage() {
    return window.location.pathname.indexOf("cookies") !== -1;
  }

  function cookiesPageInit() {
    const cookie = getCookieValue(COOKIES_PREFERENCES_SET);
    var analyticsValue = false;

    if (cookie) {
      analyticsValue = JSON.parse(cookie).analytics;
      initGATagManager(analyticsValue);
    }

    document.querySelector("#policy-cookies-accepted").checked = analyticsValue;
    document.querySelector("#policy-cookies-rejected").checked = !analyticsValue;
    document.querySelector("#save-cookie-settings").addEventListener(
      "click",
      function (event) {
        event.preventDefault();
        const selectedPreference = document.querySelector("#radio-cookie-preferences input[type=\"radio\"]:checked").value;
        const analyticsEnabled = selectedPreference === "true";
        setCookie(COOKIES_PREFERENCES_SET, {"analytics": analyticsEnabled});
        initGATagManager(analyticsEnabled);

        showElement(document.querySelector("#save-success-banner"));
        if (analyticsEnabled) {
          showElement(document.querySelector("#policy-cookies-accepted-banner"));
          hideElement(document.querySelector("#policy-cookies-rejected-banner"));
        } else {
          hideElement(document.querySelector("#policy-cookies-accepted-banner"));
          showElement(document.querySelector("#policy-cookies-rejected-banner"));
        }

        window.scrollTo(0, 0);
      }.bind(this)
    );
  }

  function initGATagManager(hasGivenConsent) {
    if (hasGivenConsent) {

      const commentStart = document.createComment(' Google Tag Manager ')
      document.head.append(commentStart);

      const script = document.createElement("script");
      const scriptValue = "(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start': new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0], j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','GTM-W38DXV2');";
      script.text = scriptValue;
      document.head.append(script);

      const commentEnd = document.createComment(' End Google Tag Manager ')
      document.head.append(commentEnd);
    } else {
      deleteCookie("_gid");
      deleteCookie("_ga");
      deleteCookie("_gat_gtag_" + gaTrackingCode.value.replace("-", "_"));
    }
  }

  function getCookieValue(cookieName) {
    const cookies = document.cookie.split(';');
    for (var i = 0; i < cookies.length; i++) {
      const name = cookies[i].split('=')[0].toLowerCase().trim();
      const value = cookies[i].split('=')[1];
      if (name.indexOf(cookieName) !== -1) {
        return value;
      }
    }
    return undefined;
  }

  function deleteCookie(name) {
    document.cookie = name + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
  }

  return {
    init: init
  };
};

if (window) {
  window.GOVSignin = window.GOVSignin || {};
  window.GOVSignin.CookieBanner = cookieBanner();
}

