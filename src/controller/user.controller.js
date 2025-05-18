const userService = require("../services/user.service");

/**
 * Save or update user from Google login
 */
exports.saveGoogleUser = async (req, res) => {
  try {
    const { email, name, accessToken, refreshToken } = req.body;

    const user = await userService.createOrUpdateUser({
      email,
      name,
      accessToken,
      refreshToken,
    });

    res.status(200).json(user);
  } catch (err) {
    console.error("Error saving user:", err);
    res.status(500).json({ error: err.message });
  }
};

/**
 * Get user by email
 */
exports.getUserByEmail = async (req, res) => {
  try {
    const user = await userService.getUserByEmail(req.params.email);
    if (!user) return res.status(404).json({ message: "User not found" });

    res.status(200).json(user);
  } catch (err) {
    console.error("Error fetching user:", err);
    res.status(500).json({ error: err.message });
  }
};

/**
 * Optional: Get user by ID
 */
exports.getUserById = async (req, res) => {
  try {
    const user = await userService.getUserById(req.params.userId);
    if (!user) return res.status(404).json({ message: "User not found" });

    res.status(200).json(user);
  } catch (err) {
    console.error("Error fetching user by ID:", err);
    res.status(500).json({ error: err.message });
  }
};
