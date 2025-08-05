const express = require("express")
const passport = require("passport")
const router = express.Router()
const authController = require("../controller/auth.controller")
const { authenticateToken } = require("../middleware/auth.middleware")

// Import Google OAuth configuration
require("../config/googleAuth.config")
router.post("/register", authController.register)

router.post("/login", authController.login)

router.post("/google", authController.loginWithGoogleToken)
router.get("/google", passport.authenticate("google", { scope: ["profile", "email"] }))
router.get(
   "/google/callback",
   passport.authenticate("google", { session: false, failureRedirect: "/auth/error" }),
   authController.googleAuthCallback
)
router.get("/profile", authenticateToken, authController.getProfile)

router.put("/profile", authenticateToken, authController.updateProfile)

router.post("/logout", authenticateToken, authController.logout)

module.exports = router
