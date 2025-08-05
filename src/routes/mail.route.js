const express = require("express")
const router = express.Router()
const mailController = require("../controller/mail.controller")
const { authenticateToken } = require("../middleware/auth.middleware")

// All routes require authentication
router.use(authenticateToken)

router.post("/send", mailController.sendEmail)
router.post("/send-with-template", mailController.sendEmailWithTemplate)

router.get("/history", mailController.getMailHistory)

router.get("/stats", mailController.getMailStats)

module.exports = router
