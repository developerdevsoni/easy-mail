# Google Login Implementation Guide

## 🚀 **Overview**

This guide explains how to implement Google login for your Easy Mail app, covering both mobile apps and web applications.

## 📱 **Mobile App Implementation (Flutter/React Native)**

### 1. **Setup Google Sign-In SDK**

**Flutter:**
```yaml
# pubspec.yaml
dependencies:
  google_sign_in: ^6.1.6
  http: ^1.1.0
```

**React Native:**
```bash
npm install @react-native-google-signin/google-signin
```

### 2. **Configure Google Sign-In**

**Flutter:**
```dart
// Initialize Google Sign-In
final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
);

// Sign in method
Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      
      if (idToken != null) {
        // Send token to your backend
        await sendTokenToBackend(idToken);
      }
    }
  } catch (error) {
    print('Google Sign-In Error: $error');
  }
}
```

**React Native:**
```javascript
import { GoogleSignin } from '@react-native-google-signin/google-signin';

// Configure Google Sign-In
GoogleSignin.configure({
  webClientId: 'YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com',
  offlineAccess: true,
});

// Sign in method
const signInWithGoogle = async () => {
  try {
    await GoogleSignin.hasPlayServices();
    const userInfo = await GoogleSignin.signIn();
    const idToken = userInfo.idToken;
    
    if (idToken) {
      // Send token to your backend
      await sendTokenToBackend(idToken);
    }
  } catch (error) {
    console.error('Google Sign-In Error:', error);
  }
};
```

### 3. **Send Token to Backend**

```dart
// Flutter
Future<void> sendTokenToBackend(String idToken) async {
  final response = await http.post(
    Uri.parse('YOUR_API_URL/api/auth/google'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'idToken': idToken}),
  );
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // Store token and user data
    await storeUserData(data['token'], data['user']);
  }
}
```

```javascript
// React Native
const sendTokenToBackend = async (idToken) => {
  try {
    const response = await fetch('YOUR_API_URL/api/auth/google', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ idToken }),
    });
    
    const data = await response.json();
    if (response.ok) {
      // Store token and user data
      await storeUserData(data.token, data.user);
    }
  } catch (error) {
    console.error('Backend API Error:', error);
  }
};
```

## 🌐 **Web App Implementation**

### 1. **Setup Google Sign-In**

```html
<!-- Include Google Sign-In script -->
<script src="https://accounts.google.com/gsi/client" async defer></script>
```

### 2. **Initialize Google Sign-In**

```javascript
// Initialize Google Sign-In
google.accounts.id.initialize({
  client_id: 'YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com',
  callback: handleCredentialResponse
});

// Handle the response
function handleCredentialResponse(response) {
  const idToken = response.credential;
  
  // Send token to your backend
  sendTokenToBackend(idToken);
}

// Render the button
google.accounts.id.renderButton(
  document.getElementById("google-signin-button"),
  { theme: "outline", size: "large" }
);
```

### 3. **Send Token to Backend**

```javascript
const sendTokenToBackend = async (idToken) => {
  try {
    const response = await fetch('/api/auth/google', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ idToken }),
    });
    
    const data = await response.json();
    if (response.ok) {
      // Store token and redirect
      localStorage.setItem('token', data.token);
      localStorage.setItem('user', JSON.stringify(data.user));
      window.location.href = '/dashboard';
    }
  } catch (error) {
    console.error('Backend API Error:', error);
  }
};
```

## 🔧 **Backend API Endpoints**

### **POST /api/auth/google**
**Request:**
```json
{
  "idToken": "google_id_token_here"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Google login successful",
  "data": {
    "user": {
      "_id": "user_id",
      "email": "user@example.com",
      "name": "John Doe",
      "photoUrl": "https://...",
      "loginMethod": "google",
      "isEmailVerified": true
    },
    "token": "jwt_token_here"
  }
}
```

## 📊 **What Gets Saved in Database**

| Field | Description | Example |
|-------|-------------|---------|
| `googleId` | Unique Google user ID | `123456789012345678901` |
| `email` | User's email address | `user@example.com` |
| `name` | Display name | `John Doe` |
| `photoUrl` | Profile picture URL | `https://lh3.googleusercontent.com/...` |
| `loginMethod` | Authentication method | `google` |
| `isEmailVerified` | Email verification status | `true` |
| `lastLogin` | Last login timestamp | `2024-01-15T10:30:45.123Z` |

## 🔐 **Security Considerations**

1. **Token Verification**: Always verify Google ID tokens on the backend
2. **HTTPS Only**: Use HTTPS in production
3. **Token Expiry**: Handle token expiration gracefully
4. **Error Handling**: Implement proper error handling for failed logins
5. **Rate Limiting**: Implement rate limiting on auth endpoints

## 🚀 **Environment Variables**

```bash
# .env
GOOGLE_CLIENT_ID=your_google_client_id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your_google_client_secret
FRONTEND_URL=https://your-app.com
```

## 📱 **Mobile App Configuration**

### **Android (Flutter)**
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest>
  <uses-permission android:name="android.permission.INTERNET"/>
  <!-- ... -->
</manifest>
```

### **iOS (Flutter)**
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string>REVERSED_CLIENT_ID</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
    </array>
  </dict>
</array>
```

## 🔄 **User Flow**

1. **User clicks "Sign in with Google"**
2. **Google Sign-In SDK handles authentication**
3. **App receives Google ID token**
4. **App sends token to your backend**
5. **Backend verifies token with Google**
6. **Backend creates/updates user in database**
7. **Backend returns JWT token and user data**
8. **App stores token and user data**
9. **User is logged in**

## 🛠 **Testing**

### **Test Google Login**
```bash
# Test the endpoint
curl -X POST http://localhost:3000/api/auth/google \
  -H "Content-Type: application/json" \
  -d '{"idToken": "test_token"}'
```

### **Check User in Database**
```javascript
// Check if user was created/updated
const user = await User.findOne({ email: 'test@example.com' });
console.log(user);
```

This implementation provides a secure, scalable Google login system for your Easy Mail app! 🎉 