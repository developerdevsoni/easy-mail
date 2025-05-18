const express = require("express");
const router = express.Router();
const mailController = require("../controller/mail.controller");

// Template related
router.post("/template", mailController.createTemplate);
router.get("/template/:userId", mailController.getTemplates);

// Mail sending
router.post("/send", mailController.sendMail);

module.exports = router;
