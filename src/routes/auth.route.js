const express = require("express")
const router = express.Router()
const authController = require("../controller/auth.controller")
const { authenticateToken } = require("../middleware/auth.middleware")

router.post("/register", authController.register)

router.post("/login", authController.login)

// Store Google user data (frontend handles Google auth)
router.post("/google", authController.storeGoogleUser)

router.get("/profile", authenticateToken, authController.getProfile)

router.put("/profile", authenticateToken, authController.updateProfile)

router.post("/logout", authenticateToken, authController.logout)

module.exports = router
