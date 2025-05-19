const mongoose = require("mongoose")

const mailTemplateSchema = new mongoose.Schema({
   userId: mongoose.Schema.Types.ObjectId,
   subject: String,
   body: String,
})

module.exports = mongoose.model("MailTemplate", mailTemplateSchema)
