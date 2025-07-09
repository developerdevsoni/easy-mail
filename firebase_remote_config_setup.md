# Firebase Remote Config Setup for Force Update Feature

## Overview
This document provides the exact JSON structure needed for Firebase Remote Config to support the force update feature in the Easy Mail app.

## Remote Config Parameter

### Parameter Name: `app_update_config`
**Type:** JSON

### Complete JSON Structure

```json
{
  "ios": {
    "current_version": "1.2.0",
    "minimum_required_version": "1.0.0",
    "force_update": false,
    "show_update": true,
    "store_url": "https://apps.apple.com/app/id123456789",
    "update_title": "🚀 New Update Available!",
    "update_message": "We've added amazing new features and improvements. Update now to get the best experience!",
    "force_update_title": "⚠️ Update Required",
    "force_update_message": "This version is no longer supported for security reasons. Please update immediately to continue using Easy Mail.",
    "update_button_text": "Update Now",
    "later_button_text": "Maybe Later",
    "changelog": [
      "🎨 Beautiful new UI improvements",
      "⚡ Faster email generation with AI",
      "🐛 Fixed bugs and enhanced stability",
      "🔒 Enhanced security features",
      "📧 New email templates added"
    ]
  },
  "android": {
    "current_version": "1.2.0",
    "minimum_required_version": "1.0.0",
    "force_update": false,
    "show_update": true,
    "store_url": "https://play.google.com/store/apps/details?id=com.easyMail.easy_mail",
    "update_title": "🚀 New Update Available!",
    "update_message": "We've added amazing new features and improvements. Update now to get the best experience!",
    "force_update_title": "⚠️ Update Required",
    "force_update_message": "This version is no longer supported for security reasons. Please update immediately to continue using Easy Mail.",
    "update_button_text": "Update Now",
    "later_button_text": "Maybe Later",
    "changelog": [
      "🎨 Beautiful new UI improvements",
      "⚡ Faster email generation with AI",
      "🐛 Fixed bugs and enhanced stability",
      "🔒 Enhanced security features",
      "📧 New email templates added"
    ]
  }
}
```

## Configuration Fields Explanation

### Version Management
- **`current_version`**: Latest available version in the store
- **`minimum_required_version`**: Minimum version that can still use the app

### Update Control
- **`force_update`**: Boolean to force users to update (shows only "Update" button)
- **`show_update`**: Boolean to show/hide update dialog entirely

### Store URLs
- **`store_url`**: Direct link to app store/play store page for updates

### UI Text Customization
- **`update_title`**: Title for normal update dialog
- **`update_message`**: Message for normal update dialog
- **`force_update_title`**: Title for force update dialog
- **`force_update_message`**: Message for force update dialog
- **`update_button_text`**: Text for update button
- **`later_button_text`**: Text for "later" button (normal updates only)

### Features
- **`changelog`**: Array of strings showing what's new (max 3 items displayed)

## Usage Scenarios

### 1. Normal Update Available
```json
{
  "current_version": "1.2.0",    // User has 1.1.0
  "minimum_required_version": "1.0.0",
  "force_update": false,         // Not forced
  "show_update": true           // Show dialog
}
```
**Result**: Shows update dialog with "Update Now" and "Later" buttons

### 2. Force Update Required
```json
{
  "current_version": "1.2.0",    // User has 0.9.0
  "minimum_required_version": "1.0.0",
  "force_update": true,          // Forced
  "show_update": true           // Show dialog
}
```
**Result**: Shows force update dialog with only "Update Now" button, can't be dismissed

### 3. Version Below Minimum (Auto Force)
```json
{
  "current_version": "1.2.0",    // User has 0.8.0
  "minimum_required_version": "1.0.0",  // User below minimum
  "force_update": false,         // Doesn't matter
  "show_update": true           // Show dialog
}
```
**Result**: Automatically becomes force update regardless of `force_update` flag

### 4. No Update Shown
```json
{
  "current_version": "1.2.0",    // User has 1.2.0 or higher
  "minimum_required_version": "1.0.0",
  "force_update": false,
  "show_update": false          // Don't show
}
```
**Result**: No update dialog shown

## Firebase Console Setup Steps

1. **Go to Firebase Console** → Your Project → Remote Config

2. **Create New Parameter:**
   - Parameter key: `app_update_config`
   - Data type: JSON
   - Default value: Use the JSON structure above

3. **Set Platform-Specific Values (Optional):**
   - You can create different configurations for different app versions
   - Use conditions to target specific user segments

4. **Publish Changes:**
   - Click "Publish changes" to make the configuration live

## Testing Different Scenarios

### Test Force Update
```json
{
  "ios": {
    "current_version": "99.0.0",
    "minimum_required_version": "99.0.0",
    "force_update": true,
    "show_update": true,
    "store_url": "https://apps.apple.com/app/id123456789",
    "update_title": "🚨 Critical Update Required",
    "update_message": "Please update immediately.",
    "force_update_title": "🚨 Critical Update Required",
    "force_update_message": "Please update immediately.",
    "update_button_text": "Update Now",
    "later_button_text": "Later",
    "changelog": ["Critical security fixes"]
  },
  "android": {
    "current_version": "99.0.0",
    "minimum_required_version": "99.0.0",
    "force_update": true,
    "show_update": true,
    "store_url": "https://play.google.com/store/apps/details?id=com.easyMail.easy_mail",
    "update_title": "🚨 Critical Update Required",
    "update_message": "Please update immediately.",
    "force_update_title": "🚨 Critical Update Required",
    "force_update_message": "Please update immediately.",
    "update_button_text": "Update Now",
    "later_button_text": "Later",
    "changelog": ["Critical security fixes"]
  }
}
```

### Test Normal Update
```json
{
  "ios": {
    "current_version": "1.1.0",
    "minimum_required_version": "1.0.0",
    "force_update": false,
    "show_update": true,
    "store_url": "https://apps.apple.com/app/id123456789",
    "update_title": "✨ Update Available",
    "update_message": "New features await you!",
    "force_update_title": "⚠️ Update Required",
    "force_update_message": "Please update to continue.",
    "update_button_text": "Update",
    "later_button_text": "Later",
    "changelog": ["New templates", "Bug fixes", "UI improvements"]
  },
  "android": {
    "current_version": "1.1.0",
    "minimum_required_version": "1.0.0",
    "force_update": false,
    "show_update": true,
    "store_url": "https://play.google.com/store/apps/details?id=com.easyMail.easy_mail",
    "update_title": "✨ Update Available",
    "update_message": "New features await you!",
    "force_update_title": "⚠️ Update Required",
    "force_update_message": "Please update to continue.",
    "update_button_text": "Update",
    "later_button_text": "Later",
    "changelog": ["New templates", "Bug fixes", "UI improvements"]
  }
}
```

## Important Notes

1. **Version Format**: Use semantic versioning (e.g., "1.2.3")
2. **Store URLs**: Update with actual App Store and Play Store URLs
3. **Testing**: Always test with different version combinations
4. **Security**: Never force update unless absolutely necessary
5. **User Experience**: Provide clear, helpful messages explaining why updates are needed

## Monitoring

Monitor the following metrics:
- Update dialog show rate
- Update completion rate
- Force update necessity
- User feedback on update experience

## Support

If users face issues with updates:
1. Verify store URLs are correct
2. Check if app versions match store versions
3. Ensure Firebase Remote Config is properly configured
4. Test with different devices and OS versions 