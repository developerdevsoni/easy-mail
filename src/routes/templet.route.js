const express = require('express');
const router = express.Router();
const controller = require('../controller/templet.controller');

router.get('/', controller.getTemplates);
router.post('/', controller.addTemplate);
router.put('/:id', controller.updateTemplate);
router.delete('/:id', controller.deleteTemplate);

module.exports = router;
