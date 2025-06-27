const mailService = require("../services/mail.service")

exports.createTemplate = async (req, res) => {
   try {
      const template = await mailService.saveTemplate({
         ...req.body,
         userId: req.params.userId,
      })
      res.status(201).json(template)
   } catch (err) {
      res.status(400).json({ error: "Failed to create template: ${err.message}" })
   }
}

exports.getTemplates = async (req, res) => {
   try {
      const template = await mailService.getTemplatesByUser(req.params.userId)
      res.status(200).json(templates)
   } catch (err) {
      res.status(500).json({ error: "Failed to fetch templates: ${err.message}" })
   }
}

exports.getFavoriteTemplates = async (req, res) => {
   try {
      const templates = await mailService.getFavoriteTemplates(req.params.userId)
      res.status(200).json(templates)
   } catch (err) {
      res.status(500).json({ error: "Failed to fetch favorite templates: ${err.message}" })
   }
}

exports.toggleFavorite = async (req, res) => {
   try {
      const template = await mailService.toggleFavorite(req.params.templateId, req.params.userId)
      res.status(200).json(template)
   } catch (err) {
      res.status(400).json({ error: "Failed to update favorite status: ${err.message}" })
   }
}

exports.getGlobalTemplates = async (req, res) => {
   try {
      const templates = await mailService.getGlobalTemplates()
      res.status(200).json(templates)
   } catch (err) {
      res.status(500).json({ error: "Failed to fetch global templates: ${err.message}" })
   }
}

exports.createGlobalTemplate = async (req, res) => {
   try {
      const template = await mailService.saveGlobalTemplate(req.body)
      res.status(201).json(template)
   } catch (err) {
      res.status(400).json({ error: "Failed to create global template: ${err.message}" })
   }
}

exports.sendMail = async (req, res) => {
   try {
      const response = await mailService.sendMailFromUser({
         ...req.body,
         userId: req.params.userId,
      })
      res.status(200).json(response)
   } catch (err) {
      res.status(500).json({ error: "Failed to send email: ${err.message}" })
   }
}
