// WayneWolf Development Profile Template
// Developer-friendly settings for web development

/******************************************************************************
 * DEVELOPMENT PROFILE - DEVELOPER TOOLS & TESTING                           *
******************************************************************************/

// Inherit base privacy settings
// This file is merged with user.js

// Keep browsing history and sessions
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.clearOnShutdown.downloads", false);
user_pref("privacy.clearOnShutdown.cache", false);

// Enable disk cache for development
user_pref("browser.cache.disk.enable", true);
user_pref("browser.cache.disk.capacity", 2097152); // 2GB for development assets

// Session restore
user_pref("browser.sessionstore.resume_from_crash", true);
user_pref("browser.sessionstore.max_tabs_undo", 25);

// Relax fingerprinting resistance for testing
user_pref("privacy.resistFingerprinting", false); // Disabled to test real browser behavior
user_pref("privacy.resistFingerprinting.letterboxing", false);

// Enable WebGL for graphics testing
user_pref("webgl.disabled", false);
user_pref("webgl.enable-webgl2", true);
user_pref("webgl.enable-debug-renderer-info", true);

// Enable all media features for testing
user_pref("media.navigator.enabled", true);
user_pref("media.peerconnection.enabled", true);
user_pref("media.peerconnection.ice.default_address_only", false);

// Allow localhost and development servers
user_pref("network.proxy.allow_hijacking_localhost", true);

// Developer Tools
user_pref("devtools.chrome.enabled", true);
user_pref("devtools.debugger.remote-enabled", true);
user_pref("devtools.theme", "dark");
user_pref("devtools.toolbox.host", "bottom");

// Disable CORS for local development (CAREFUL - only for dev!)
user_pref("security.fileuri.strict_origin_policy", false);

// Allow mixed content for development
user_pref("security.mixed_content.block_active_content", false);
user_pref("security.mixed_content.block_display_content", false);

// Relax HTTPS-only mode for localhost
user_pref("dom.security.https_only_mode", false);

// Allow all cookies (needed for testing)
user_pref("network.cookie.cookieBehavior", 0); // 0 = accept all
user_pref("network.cookie.lifetimePolicy", 0);

// First Party Isolation OFF for development
user_pref("privacy.firstparty.isolate", false);

// Enable search suggestions
user_pref("browser.search.suggest.enabled", true);
user_pref("browser.urlbar.suggest.searches", true);

// Form autofill
user_pref("browser.formfill.enable", true);

// Allow autoplay for testing
user_pref("media.autoplay.default", 0); // 0 = allow all
user_pref("media.autoplay.blocking_policy", 0);

// Standard referrer policy for testing
user_pref("network.http.referer.XOriginPolicy", 0);
user_pref("network.http.referer.XOriginTrimmingPolicy", 0);

// Enable browser console
user_pref("devtools.browserconsole.filter.jswarn", true);
user_pref("devtools.browserconsole.filter.error", true);

// Show punycode
user_pref("network.IDN_show_punycode", true);

// Use standard fonts (not restricted)
user_pref("browser.display.use_document_fonts", 1);

// Container tabs for testing different contexts
user_pref("privacy.userContext.enabled", true);
user_pref("privacy.userContext.ui.enabled", true);

// Service workers enabled
user_pref("dom.serviceWorkers.enabled", true);

// IndexedDB enabled
user_pref("dom.indexedDB.enabled", true);

// Web notifications enabled for testing
user_pref("dom.webnotifications.enabled", true);

// Restore previous session
user_pref("browser.startup.page", 3);

// Developer-friendly homepage
user_pref("browser.startup.homepage", "about:blank");

// Compact UI
user_pref("browser.uidensity", 1);

// Enable console warnings
user_pref("devtools.webconsole.filter.warn", true);
user_pref("devtools.webconsole.filter.error", true);

// Large console history
user_pref("devtools.hud.loglimit", 10000);
