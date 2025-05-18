const express = require("express");
const router = express.Router();
const userController = require("../controller/user.controller");

router.post("/save-google-user", userController.saveGoogleUser);
router.get("/me/:email", userController.getUserByEmail);

module.exports = router;
