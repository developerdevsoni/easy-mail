const mongoose = require("mongoose")

const mailTemplateSchema = new mongoose.Schema({
   userId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "User",
   },
   subject: {
      type: String,
      required: true,
      trim: true,
   },
   body: {
      type: String,
      required: true,
   },
   isFavorite: {
      type: Boolean,
      default: false,
   },
   createdAt: {
      type: Date,
      default: Date.now,
   },
})

module.exports = mongoose.model("MailTemplate", mailTemplateSchema)
