const mongoose = require("mongoose")

const userMailHistorySchema = new mongoose.Schema({
   userId: mongoose.Schema.Types.ObjectId,
   toEmail: String,
   subject: String,
   body: String,
   templateId: mongoose.Schema.Types.ObjectId,
   sentAt: { type: Date, default: Date.now },
})

module.exports = mongoose.model("UserMailHistory", userMailHistorySchema)
