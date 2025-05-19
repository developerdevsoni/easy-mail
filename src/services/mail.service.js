const User = require("../models/user.model")
const MailTemplate = require("../models/mailtemplet.model")
const UserMailHistory = require("../models/usermailhistory.model")
const { sendEmailOAuth } = require("../utils/sendMail")

exports.saveTemplate = (data) => new MailTemplate(data).save()
exports.getTemplatesByUser = (userId) => MailTemplate.find({ userId })

exports.sendMailFromUser = async ({ userId, toEmail, templateId }) => {
   const user = await User.findById(userId)
   if (!user) throw new Error("User not found")

   const template = await MailTemplate.findById(templateId)
   if (!template) throw new Error("Template not found")

   await sendEmailOAuth(user.email, toEmail, template.subject, template.body, {
      access_token: user.accessToken,
      refresh_token: user.refreshToken,
   })

   await UserMailHistory.create({
      userId,
      toEmail,
      subject: template.subject,
      body: template.body,
      templateId,
   })

   return { message: "Mail sent successfully." }
}
