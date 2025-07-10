const User = require('../models/user.model');
const { generateToken } = require('../middleware/auth.middleware');
const bcrypt = require('bcryptjs');
const { OAuth2Client } = require('google-auth-library');
const ResponseHandler = require('../utils/responseHandler');

const GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID;
const googleClient = new OAuth2Client(GOOGLE_CLIENT_ID);

// Register with email and password
const register = async (req, res) => {
   try {
      const { email, password, name } = req.body;

      // Validate input
      if (!email || !password || !name) {
         return ResponseHandler.badRequest(res, 'Email, password, and name are required');
      }

      // Check if user already exists
      const existingUser = await User.findOne({ email: email.toLowerCase() });
      if (existingUser) {
         return ResponseHandler.conflict(res, 'User with this email already exists');
      }

      // Create new user
      const user = new User({
         email: email.toLowerCase(),
         password,
         name,
         loginMethod: 'email'
      });

      await user.save();

      // Generate token
      const token = generateToken(user._id);

      return ResponseHandler.created(res, 'User registered successfully', {
         user: user.getPublicProfile(),
         token
      });
   } catch (error) {
      console.error('Registration error:', error);
      return ResponseHandler.internalError(res, 'Registration failed', error.message);
   }
};

// Login with email and password
const login = async (req, res) => {
   try {
      const { email, password } = req.body;

      // Validate input
      if (!email || !password) {
         return ResponseHandler.badRequest(res, 'Email and password are required');
      }

      // Find user
      const user = await User.findOne({ email: email.toLowerCase() });
      if (!user) {
         return ResponseHandler.unauthorized(res, 'Invalid credentials');
      }

      // Check if user has password (Google OAuth users might not have password)
      if (!user.password) {
         return ResponseHandler.unauthorized(res, 'Please login with Google OAuth');
      }

      // Verify password
      const isPasswordValid = await user.comparePassword(password);
      if (!isPasswordValid) {
         return ResponseHandler.unauthorized(res, 'Invalid credentials');
      }

      // Update last login
      user.lastLogin = new Date();
      await user.save();

      // Generate token
      const token = generateToken(user._id);

      return ResponseHandler.token(res, 'Login successful', {
         user: user.getPublicProfile(),
         token
      });
   } catch (error) {
      console.error('Login error:', error);
      return ResponseHandler.internalError(res, 'Login failed', error.message);
   }
};

// Login/Register with Google ID token (frontend flow)
const loginWithGoogleToken = async (req, res) => {
   try {
      const { idToken } = req.body;
      if (!idToken) {
         return ResponseHandler.badRequest(res, 'Google ID token is required');
      }

      // Verify token with Google
      const ticket = await googleClient.verifyIdToken({
         idToken,
         audience: GOOGLE_CLIENT_ID
      });
      const payload = ticket.getPayload();
      if (!payload) {
         return ResponseHandler.unauthorized(res, 'Invalid Google token');
      }

      // Find or create user
      let user = await User.findOne({ googleId: payload.sub });
      if (!user) {
         // Check if user exists with same email
         user = await User.findOne({ email: payload.email });
         if (user) {
            user.googleId = payload.sub;
            user.loginMethod = 'google';
            user.photoUrl = payload.picture;
            user.isEmailVerified = payload.email_verified;
            await user.save();
         } else {
            user = new User({
               googleId: payload.sub,
               email: payload.email,
               name: payload.name,
               photoUrl: payload.picture,
               loginMethod: 'google',
               isEmailVerified: payload.email_verified
            });
            await user.save();
         }
      } else {
         user.lastLogin = new Date();
         await user.save();
      }

      // Issue JWT
      const token = generateToken(user._id);
      return ResponseHandler.token(res, 'Google login successful', {
         user: user.getPublicProfile(),
         token
      });
   } catch (error) {
      console.error('Google login error:', error);
      return ResponseHandler.internalError(res, 'Google login failed', error.message);
   }
};

// Google OAuth callback
const googleAuthCallback = async (req, res) => {
   try {
      const user = req.user;
      const token = generateToken(user._id);

      // Redirect to frontend with token
      res.redirect(`${process.env.FRONTEND_URL || 'http://localhost:3000'}/auth/callback?token=${token}&user=${encodeURIComponent(JSON.stringify(user.getPublicProfile()))}`);
   } catch (error) {
      console.error('Google auth callback error:', error);
      res.redirect(`${process.env.FRONTEND_URL || 'http://localhost:3000'}/auth/error`);
   }
};

// Get current user profile
const getProfile = async (req, res) => {
   try {
      return ResponseHandler.item(res, 'Profile retrieved successfully', {
         user: req.user.getPublicProfile()
      });
   } catch (error) {
      console.error('Get profile error:', error);
      return ResponseHandler.internalError(res, 'Failed to get profile', error.message);
   }
};

// Update user profile
const updateProfile = async (req, res) => {
   try {
      const { name, preferences } = req.body;
      const updates = {};

      if (name) updates.name = name;
      if (preferences) updates.preferences = { ...req.user.preferences, ...preferences };

      const user = await User.findByIdAndUpdate(
         req.user._id,
         updates,
         { new: true, runValidators: true }
      ).select('-password');

      return ResponseHandler.updated(res, 'Profile updated successfully', {
         user: user.getPublicProfile()
      });
   } catch (error) {
      console.error('Update profile error:', error);
      return ResponseHandler.internalError(res, 'Failed to update profile', error.message);
   }
};

// Logout (client-side token removal)
const logout = async (req, res) => {
   try {
      return ResponseHandler.success(res, 200, 'Logout successful');
   } catch (error) {
      console.error('Logout error:', error);
      return ResponseHandler.internalError(res, 'Logout failed', error.message);
   }
};

module.exports = {
   register,
   login,
   googleAuthCallback,
   getProfile,
   updateProfile,
   logout,
   loginWithGoogleToken
};
