// WayneWolf Anonymous Profile Template
// Maximum privacy, no persistence, anonymous browsing

/******************************************************************************
 * ANONYMOUS PROFILE - MAXIMUM PRIVACY                                       *
******************************************************************************/

// Inherit base privacy settings
// This file is merged with user.js

// ALWAYS use private browsing mode
user_pref("browser.privatebrowsing.autostart", true);

// Delete everything on shutdown
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown.cookies", true);
user_pref("privacy.clearOnShutdown.downloads", true);
user_pref("privacy.clearOnShutdown.formdata", true);
user_pref("privacy.clearOnShutdown.history", true);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.sessions", true);
user_pref("privacy.clearOnShutdown.sitesettings", true);

// No disk cache
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.memory.enable", true);
user_pref("browser.cache.memory.capacity", 262144); // 256MB

// No session restore
user_pref("browser.sessionstore.resume_from_crash", false);
user_pref("browser.sessionstore.max_tabs_undo", 0);

// Disable all form autofill
user_pref("browser.formfill.enable", false);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);

// Maximum fingerprinting resistance
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.resistFingerprinting.letterboxing", true);

// Disable WebGL completely
user_pref("webgl.disabled", true);
user_pref("webgl.enable-webgl2", false);

// Disable canvas
user_pref("privacy.resistFingerprinting.block_mozAddonManager", true);

// Disable media devices
user_pref("media.navigator.enabled", false);
user_pref("media.peerconnection.enabled", false);

// Block all cookies by default (can be overridden per-site)
user_pref("network.cookie.cookieBehavior", 2); // 2 = block all third-party cookies
user_pref("network.cookie.lifetimePolicy", 2); // 2 = accept cookies for session only

// Disable all network predictions
user_pref("network.predictor.enabled", false);
user_pref("network.prefetch-next", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.http.speculative-parallel-limit", 0);

// Disable search suggestions
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.suggest.searches", false);

// Tor-like behavior for timezone
user_pref("privacy.resistFingerprinting.jsmloglevel", "Warn");

// Disable media auto-play
user_pref("media.autoplay.default", 5); // 5 = block all
user_pref("media.autoplay.blocking_policy", 2);

// Strict referrer policy
user_pref("network.http.referer.XOriginPolicy", 2); // 2 = strict
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

// Anonymous profile homepage
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.startup.page", 0); // 0 = blank page
