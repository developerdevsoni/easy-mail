const express = require("express")
const router = express.Router()
const personalTemplateController = require("../controller/personalTemplate.controller")
const { authenticateToken } = require("../middleware/auth.middleware")

// All routes require authentication
router.use(authenticateToken)
router.post("/", personalTemplateController.createTemplate)

router.get("/", personalTemplateController.getTemplates)

router.get("/favorites", personalTemplateController.getFavoriteTemplates)
router.get("/:templateId", personalTemplateController.getTemplateById)

router.put("/:templateId", personalTemplateController.updateTemplate)

router.delete("/:templateId", personalTemplateController.deleteTemplate)
router.patch("/:templateId/favorite", personalTemplateController.toggleFavorite)

module.exports = router
