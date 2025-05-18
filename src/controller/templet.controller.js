const service = require('../services/templet.service');

exports.getTemplates = (req, res) => {
  const templates = service.getAllTemplates();
  res.json(templates);
};

exports.addTemplate = (req, res) => {
  const result = service.addTemplate(req.body);
  res.json(result);
};

exports.updateTemplate = (req, res) => {
  const result = service.updateTemplate(req.params.id, req.body);
  res.json(result);
};

exports.deleteTemplate = (req, res) => {
  const result = service.deleteTemplate(req.params.id);
  res.json(result);
};
