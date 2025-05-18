const express = require('express');
const router = express.Router();
const authCtrl = require('../controller/auth.controller');

router.get('/google', authCtrl.loginWithGoogle);
router.get('/google/callback', authCtrl.handleGoogleCallback);

module.exports = router;
