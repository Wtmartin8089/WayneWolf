// WayneWolf Work Profile Template
// Balanced privacy with convenience for daily use

/******************************************************************************
 * WORK PROFILE - BALANCED PRIVACY & CONVENIENCE                             *
******************************************************************************/

// Inherit base privacy settings
// This file is merged with user.js

// Keep browsing history (but clear on shutdown if desired)
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.clearOnShutdown.downloads", false);

// Keep cookies for trusted sites, clear third-party
user_pref("network.cookie.cookieBehavior", 4); // 4 = cross-site tracking protection
user_pref("network.cookie.lifetimePolicy", 0); // 0 = accept normally

// Enable disk cache for better performance
user_pref("browser.cache.disk.enable", true);
user_pref("browser.cache.disk.capacity", 1048576); // 1GB

// Session restore enabled for convenience
user_pref("browser.sessionstore.resume_from_crash", true);
user_pref("browser.sessionstore.max_tabs_undo", 10);

// Moderate fingerprinting resistance
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.resistFingerprinting.letterboxing", false); // Disabled for better UX

// Allow WebGL (needed for some work tools)
user_pref("webgl.disabled", false);
user_pref("webgl.enable-webgl2", true);

// Allow some form autofill for convenience
user_pref("browser.formfill.enable", true);
user_pref("extensions.formautofill.addresses.enabled", false); // Still no address autofill
user_pref("extensions.formautofill.creditCards.enabled", false); // No credit cards

// Enable search suggestions
user_pref("browser.search.suggest.enabled", true);
user_pref("browser.urlbar.suggest.searches", true);
user_pref("browser.urlbar.suggest.history", true);
user_pref("browser.urlbar.suggest.bookmark", true);

// Moderate referrer policy
user_pref("network.http.referer.XOriginPolicy", 0); // 0 = allow
user_pref("network.http.referer.XOriginTrimmingPolicy", 2); // 2 = scheme+host+port+path

// Allow some media autoplay (muted)
user_pref("media.autoplay.default", 5); // 5 = block all (can be relaxed per-site)
user_pref("media.autoplay.blocking_policy", 1);

// Keep download history
user_pref("browser.download.useDownloadDir", false); // Still ask where to save
user_pref("browser.download.folderList", 2);

// Container tabs support (for work/personal separation)
user_pref("privacy.userContext.enabled", true);
user_pref("privacy.userContext.ui.enabled", true);

// Default to DuckDuckGo but allow other search engines
user_pref("browser.search.defaultenginename", "DuckDuckGo");

// Compact UI
user_pref("browser.uidensity", 1);

// Custom homepage - can be changed per preference
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.startup.page", 3); // 3 = restore previous session
