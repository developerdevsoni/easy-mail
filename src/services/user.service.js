const User = require('../models/user.model');

/**
 * Create or update user with Google OAuth tokens
 */
exports.createOrUpdateUser = async ({ email, name, accessToken, refreshToken }) => {
  const user = await User.findOneAndUpdate(
    { email },
    {
      $set: {
        email,
        name,
        accessToken,
        refreshToken,
      },
    },
    { upsert: true, new: true }
  );

  return user;
};

/**
 * Get user by email
 */
exports.getUserByEmail = async (email) => {
  return await User.findOne({ email });
};

/**
 * Get user by ID
 */
exports.getUserById = async (userId) => {
  return await User.findById(userId);
};

/**
 * Update user's tokens manually (if needed)
 */
exports.updateUserTokens = async (email, tokens) => {
  return await User.findOneAndUpdate(
    { email },
    {
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    },
    { new: true }
  );
};
