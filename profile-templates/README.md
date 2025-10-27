# WayneWolf Profile Templates

Profile templates provide pre-configured settings for different use cases.

## Available Templates

### 1. Anonymous Profile (`anonymous.js`)
**Maximum privacy, zero persistence**

- Private browsing mode always enabled
- All data cleared on shutdown (history, cookies, cache)
- Maximum fingerprinting resistance
- WebGL disabled
- Canvas fingerprinting protection
- No form autofill
- Block all cookies by default
- Tor-like privacy settings

**Best for:**
- Anonymous browsing
- Sensitive research
- Accessing untrusted sites
- Maximum privacy scenarios

### 2. Work Profile (`work.js`)
**Balanced privacy and convenience**

- Keeps browsing history
- Session restore enabled
- Allows first-party cookies
- Disk cache for performance
- Form autofill for convenience
- Search suggestions enabled
- Container tabs support
- WebGL enabled

**Best for:**
- Daily browsing
- Work-related tasks
- Sites requiring login
- General productivity

### 3. Development Profile (`development.js`)
**Developer-friendly testing environment**

- All web APIs enabled
- Developer tools enhanced
- CORS relaxed for localhost
- Mixed content allowed
- WebGL and media APIs enabled
- Service workers enabled
- Large console history
- No fingerprinting resistance (test real behavior)

**Best for:**
- Web development
- Testing websites
- API development
- Debugging applications

## Usage

Profile templates are automatically applied when creating a new profile:

```bash
# Create profile with template
./launch-waynewolf.sh --profile work --create

# Extensions are automatically installed based on profile type
```

## Customization

You can create custom templates by:

1. Copy an existing template
2. Modify the preferences
3. Save in `profile-templates/` directory
4. Update `launch-waynewolf.sh` to recognize your template

## Extension Mapping

Extensions are automatically installed based on profile type (see `extensions.conf`):

- **All profiles:** uBlock Origin, LibRedirect, ClearURLs
- **Work/Development:** Multi-Account Containers
- **Anonymous:** CanvasBlocker, NoScript

## Manual Application

To manually apply a template to an existing profile:

```bash
# Copy template settings to profile
cat user.js profile-templates/work.js > ~/.waynewolf/profiles/myprofile.default/user.js
```
