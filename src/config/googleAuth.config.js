const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;
const User = require('../models/user.model');
const { generateToken } = require('../middleware/auth.middleware');

const GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID;
const GOOGLE_CLIENT_SECRET = process.env.GOOGLE_CLIENT_SECRET;
const GOOGLE_CALLBACK_URL = process.env.GOOGLE_CALLBACK_URL || 'http://localhost:3000/api/auth/google/callback';

// Configure Google OAuth Strategy
passport.use(new GoogleStrategy({
   clientID: GOOGLE_CLIENT_ID,
   clientSecret: GOOGLE_CLIENT_SECRET,
   callbackURL: GOOGLE_CALLBACK_URL,
   scope: ['profile', 'email']
}, async (accessToken, refreshToken, profile, done) => {
   try {
      // Check if user already exists
      let user = await User.findOne({ googleId: profile.id });
      
      if (!user) {
         // Check if user exists with same email
         user = await User.findOne({ email: profile.emails[0].value });
         
         if (user) {
            // Update existing user with Google ID
            user.googleId = profile.id;
            user.loginMethod = 'google';
            user.photoUrl = profile.photos[0]?.value;
            user.isEmailVerified = true;
            await user.save();
         } else {
            // Create new user
            user = new User({
               googleId: profile.id,
               email: profile.emails[0].value,
               name: profile.displayName,
               photoUrl: profile.photos[0]?.value,
               loginMethod: 'google',
               isEmailVerified: true
            });
            await user.save();
         }
      } else {
         // Update last login
         user.lastLogin = new Date();
         await user.save();
      }
      
      return done(null, user);
   } catch (error) {
      return done(error, null);
   }
}));

// Serialize user for session
passport.serializeUser((user, done) => {
   done(null, user.id);
});

// Deserialize user from session
passport.deserializeUser(async (id, done) => {
   try {
      const user = await User.findById(id);
      done(null, user);
   } catch (error) {
      done(error, null);
   }
});

module.exports = passport; 