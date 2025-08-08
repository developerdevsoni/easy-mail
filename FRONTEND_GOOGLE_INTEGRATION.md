# Frontend Google Integration Guide

## 🚀 **Simple Backend Integration**

Since you've already implemented Google login on the frontend, you just need to send the user data to the backend to store it.

## 📱 **Frontend Implementation**

### **After Google Sign-In Success**

```javascript
// After successful Google authentication, send user data to backend
const handleGoogleSignIn = async (googleUser) => {
  try {
    const response = await fetch('/api/auth/google', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        googleId: googleUser.id, // or googleUser.sub
        email: googleUser.email,
        name: googleUser.name,
        photoUrl: googleUser.picture // optional
      }),
    });

    const data = await response.json();
    
    if (response.ok) {
      // Store the JWT token
      localStorage.setItem('token', data.data.token);
      localStorage.setItem('user', JSON.stringify(data.data.user));
      
      // Redirect to dashboard or home
      window.location.href = '/dashboard';
    } else {
      console.error('Backend error:', data.message);
    }
  } catch (error) {
    console.error('Network error:', error);
  }
};
```

### **Flutter Example**

```dart
Future<void> handleGoogleSignIn(GoogleSignInAccount googleUser) async {
  try {
    final response = await http.post(
      Uri.parse('YOUR_API_URL/api/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'googleId': googleUser.id,
        'email': googleUser.email,
        'name': googleUser.displayName,
        'photoUrl': googleUser.photoUrl,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Store token and user data
      await storeUserData(data['data']['token'], data['data']['user']);
    }
  } catch (error) {
    print('Error: $error');
  }
}
```

### **React Native Example**

```javascript
const handleGoogleSignIn = async (userInfo) => {
  try {
    const response = await fetch('YOUR_API_URL/api/auth/google', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        googleId: userInfo.user.id,
        email: userInfo.user.email,
        name: userInfo.user.name,
        photoUrl: userInfo.user.photo,
      }),
    });

    const data = await response.json();
    
    if (response.ok) {
      // Store token and user data
      await AsyncStorage.setItem('token', data.data.token);
      await AsyncStorage.setItem('user', JSON.stringify(data.data.user));
    }
  } catch (error) {
    console.error('Error:', error);
  }
};
```

## 🔧 **Backend API Endpoint**

### **POST /api/auth/google**

**Request Body:**
```json
{
  "googleId": "123456789012345678901",
  "email": "user@example.com",
  "name": "John Doe",
  "photoUrl": "https://lh3.googleusercontent.com/..." // optional
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
      "isEmailVerified": true,
      "lastLogin": "2024-01-15T10:30:45.123Z"
    },
    "token": "jwt_token_here"
  }
}
```

## 📊 **What Gets Stored**

| Field | From Frontend | Description |
|-------|---------------|-------------|
| `googleId` | `googleUser.id` | Unique Google user ID |
| `email` | `googleUser.email` | User's email address |
| `name` | `googleUser.name` | Display name |
| `photoUrl` | `googleUser.picture` | Profile picture URL |
| `loginMethod` | Auto-set | Set to "google" |
| `isEmailVerified` | Auto-set | Set to true |
| `lastLogin` | Auto-set | Current timestamp |

## 🔄 **User Flow**

1. **User clicks "Sign in with Google"**
2. **Frontend handles Google authentication**
3. **Frontend gets user data from Google**
4. **Frontend sends data to `/api/auth/google`**
5. **Backend stores/updates user in database**
6. **Backend returns JWT token and user data**
7. **Frontend stores token and user data**
8. **User is logged in**

## 🛠 **Testing**

```bash
# Test the endpoint
curl -X POST http://localhost:3000/api/auth/google \
  -H "Content-Type: application/json" \
  -d '{
    "googleId": "123456789012345678901",
    "email": "test@example.com",
    "name": "Test User",
    "photoUrl": "https://example.com/photo.jpg"
  }'
```

## ✅ **Benefits**

• **Simple** - No complex token verification
• **Fast** - Direct user data storage
• **Flexible** - Works with any frontend framework
• **Secure** - Frontend handles Google authentication
• **Reliable** - Backend just stores verified data

This approach is perfect when you've already implemented Google authentication on the frontend! 🎉 