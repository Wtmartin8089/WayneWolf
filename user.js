// WayneWolf Custom Privacy & Security Configuration
// Based on arkenfox user.js with LibreWolf-specific optimizations

/******************************************************************************
 * SECTION: STARTUP                                                          *
******************************************************************************/
// Disable about:config warning
user_pref("browser.aboutConfig.showWarning", false);
// Disable default browser check
user_pref("browser.shell.checkDefaultBrowser", false);

/******************************************************************************
 * SECTION: GEOLOCATION                                                      *
******************************************************************************/
// Disable geolocation
user_pref("geo.enabled", false);
user_pref("geo.provider.network.url", "");

/******************************************************************************
 * SECTION: LANGUAGE / LOCALE                                                *
******************************************************************************/
// Set language to US English to reduce fingerprinting
user_pref("intl.accept_languages", "en-US, en");
user_pref("javascript.use_us_english_locale", true);

/******************************************************************************
 * SECTION: QUIETER FOX                                                      *
******************************************************************************/
// Disable recommendations
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);

// Disable telemetry
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");

// Disable studies
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

// Disable crash reports
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);

/******************************************************************************
 * SECTION: SAFE BROWSING                                                    *
******************************************************************************/
// Disable safe browsing to avoid Google contact
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.url", "");

/******************************************************************************
 * SECTION: NETWORK                                                          *
******************************************************************************/
// Enable DNS-over-HTTPS with Quad9
user_pref("network.trr.mode", 2); // 2 = TRR first with fallback
user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");
user_pref("network.trr.custom_uri", "https://dns.quad9.net/dns-query");

// Disable link prefetching
user_pref("network.prefetch-next", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.predictor.enabled", false);

// Disable HTTP Alternative Services
user_pref("network.http.altsvc.enabled", false);
user_pref("network.http.altsvc.oe", false);

/******************************************************************************
 * SECTION: PRIVACY                                                          *
******************************************************************************/
// Enhanced Tracking Protection - Strict
user_pref("browser.contentblocking.category", "strict");
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);

// Disable WebRTC leak
user_pref("media.peerconnection.ice.default_address_only", true);
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);

// Resist fingerprinting
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.resistFingerprinting.letterboxing", true);
user_pref("webgl.disabled", true);

// Disable WebGL debugging info
user_pref("webgl.enable-debug-renderer-info", false);

// Limit font fingerprinting
user_pref("browser.display.use_document_fonts", 0);

// Disable media devices enumeration
user_pref("media.navigator.enabled", false);

// First Party Isolation (deprecated but still useful)
user_pref("privacy.firstparty.isolate", true);

// Cookie behavior - block third-party
user_pref("network.cookie.cookieBehavior", 1); // 1 = block third-party

// HTTPS-Only Mode
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_send_http_background_request", false);

/******************************************************************************
 * SECTION: DOWNLOADS                                                        *
******************************************************************************/
// Always ask where to save downloads
user_pref("browser.download.useDownloadDir", false);
user_pref("browser.download.folderList", 2);

/******************************************************************************
 * SECTION: PASSWORDS                                                        *
******************************************************************************/
// Disable password manager (use external password manager)
user_pref("signon.rememberSignons", false);
user_pref("signon.autofillForms", false);
user_pref("signon.formlessCapture.enabled", false);

/******************************************************************************
 * SECTION: CACHE / SESSION                                                  *
******************************************************************************/
// Clear on shutdown
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown.cookies", true);
user_pref("privacy.clearOnShutdown.downloads", true);
user_pref("privacy.clearOnShutdown.formdata", true);
user_pref("privacy.clearOnShutdown.history", true);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.sessions", true);

// Disable disk cache
user_pref("browser.cache.disk.enable", false);
user_pref("browser.sessionstore.privacy_level", 2);

/******************************************************************************
 * SECTION: UI / UX                                                          *
******************************************************************************/
// Disable pocket
user_pref("extensions.pocket.enabled", false);

// Compact mode
user_pref("browser.uidensity", 1);

// Show punycode for IDN to prevent phishing
user_pref("network.IDN_show_punycode", true);

// Disable Firefox Accounts
user_pref("identity.fxaccounts.enabled", false);

/******************************************************************************
 * SECTION: PERFORMANCE                                                      *
******************************************************************************/
// Hardware acceleration (keep enabled for performance)
user_pref("gfx.webrender.all", true);
user_pref("media.ffmpeg.vaapi.enabled", true);

/******************************************************************************
 * SECTION: WAYNEWOLF CUSTOM                                                 *
******************************************************************************/
// Custom homepage
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.newtabpage.enabled", false);

// Disable Firefox View
user_pref("browser.tabs.firefox-view", false);

// Search engine - DuckDuckGo
user_pref("browser.search.defaultenginename", "DuckDuckGo");
user_pref("browser.search.order.1", "DuckDuckGo");
