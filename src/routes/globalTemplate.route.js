const express = require("express")
const router = express.Router()
const globalTemplateController = require("../controller/globalTemplate.controller")
const { authenticateToken, optionalAuth } = require("../middleware/auth.middleware")

router.get("/", optionalAuth, globalTemplateController.getGlobalTemplates)
router.get("/popular", optionalAuth, globalTemplateController.getPopularTemplates)
router.get("/category/:category", optionalAuth, globalTemplateController.getTemplatesByCategory)

router.get("/:templateId", optionalAuth, globalTemplateController.getGlobalTemplateById)
router.post("/", authenticateToken, globalTemplateController.createGlobalTemplate)

router.patch("/:templateId/usage", authenticateToken, globalTemplateController.incrementUsageCount)

module.exports = router
