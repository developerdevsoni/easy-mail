const MailTemplate = require("../models/mailTemplate.model")
const GlobalTemplate = require("../models/globalTemplate.model")

exports.saveTemplate = async ({ userId, subject, body, isFavorite = false }) => {
   const template = new MailTemplate({ userId, subject, body, isFavorite })
   return await template.save()
}

exports.getTemplatesByUser = async (userId) => {
   return await MailTemplate.find({ userId }).sort({ createdAt: -1 })
}

exports.getFavoriteTemplates = async (userId) => {
   return await MailTemplate.find({ userId, isFavorite: true }).sort({ createdAt: -1 })
}

exports.toggleFavorite = async (templateId, userId) => {
   const template = await MailTemplate.findOne({ _id: templateId, userId })
   if (!template) throw new Error("Template not found")
   template.isFavorite = !template.isFavorite
   return await template.save()
}

exports.getGlobalTemplates = async () => {
   return await GlobalTemplate.find().sort({ createdAt: -1 })
}

exports.saveGlobalTemplate = async ({ subject, body, title, regards }) => {
   const template = new GlobalTemplate({ subject, body, title, regards })
   return await template.save()
}

exports.sendMailFromUser = async ({ userId, templateId, subject, body, to }) => {
   // Placeholder for email sending logic
   // You can integrate with nodemailer or any email service here
   const template = await MailTemplate.findOne({ _id: templateId, userId })
   if (!template) throw new Error("Template not found")

   // Simulated email sending
   return {
      success: true,
      message: `Email sent to ${to} with subject: ${subject || template.subject}`,
      data: { subject: subject || template.subject, body: body || template.body },
   }
}
