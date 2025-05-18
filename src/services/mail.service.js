const User = require("../models/user.model");
const MailTemplate = require("../models/mailtemplet.model");
const UserMailHistory = require("../models/usermailhistory.model");
// const { sendEmailOAuth } = require("."); // if split helper

exports.sendMailFromUser = async ({ userId, toEmail, templateId }) => {
  const user = await User.findById(userId);
  if (!user || !user.email || !user.accessToken || !user.refreshToken) {
    throw new Error("User credentials not found");
  }

  const template = await MailTemplate.findById(templateId);
  if (!template) {
    throw new Error("Template not found.");
  }

  // await sendEmailOAuth(user.email, toEmail, template.subject, template.body, {
  //   access_token: user.accessToken,
  //   refresh_token: user.refreshToken,
  // });

  await UserMailHistory.create({
    userId,
    toEmail,
    subject: template.subject,
    body: template.body,
    templateId,
  });

  return { message: "Mail sent successfully." };
};
