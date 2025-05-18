const mailService = require("../services/mail.service");

exports.createTemplate = async (req, res) => {
  try {
    const template = await mailService.saveTemplate(req.body);
    res.status(200).json(template);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getTemplates = async (req, res) => {
  try {
    const templates = await mailService.getTemplatesByUser(req.params.userId);
    res.status(200).json(templates);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.sendMail = async (req, res) => {
  try {
    const response = await mailService.sendMailFromUser(req.body);
    res.status(200).json(response);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
