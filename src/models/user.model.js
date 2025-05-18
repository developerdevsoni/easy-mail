const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  email: { type: String, },
  name: String,
  googleId: String,
  accessToken: String,
  refreshToken: String,
  tokenExpiryDate: Date
}, { timestamps: true });

module.exports = mongoose.model("User", userSchema);
