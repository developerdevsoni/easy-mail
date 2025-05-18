const mongoose = require("mongoose");

const userMailHistorySchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  toEmail: { type: String, required: true },
  subject: String,
  body: String,
  templateId: { type: mongoose.Schema.Types.ObjectId, ref: "MailTemplate" },
  sentAt: { type: Date, default: Date.now }
}, { timestamps: true });

module.exports = mongoose.model("UserMailHistory", userMailHistorySchema);
