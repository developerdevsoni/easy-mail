const mongoose = require("mongoose");

const mailHistorySchema = new mongoose.Schema({
   userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
   },
   recipientEmail: {
      type: String,
      required: true,
      trim: true,
      lowercase: true
   },
   recipientName: {
      type: String,
      trim: true
   },
   subject: {
      type: String,
      required: true,
      trim: true
   },
   body: {
      type: String,
      required: true
   },
   regards: {
      type: String,
      required: true,
      trim: true
   },
   templateUsed: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "PersonalTemplate"
   },
   globalTemplateUsed: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "GlobalTemplate"
   },
   status: {
      type: String,
      enum: ['sent', 'failed', 'pending'],
      default: 'pending'
   },
   sentAt: {
      type: Date,
      default: Date.now
   },
   aiGenerated: {
      type: Boolean,
      default: false
   },
   metadata: {
      ipAddress: String,
      userAgent: String,
      templateName: String
   }
}, { 
   timestamps: true 
});

// Indexes for better query performance
mailHistorySchema.index({ userId: 1, sentAt: -1 });
mailHistorySchema.index({ status: 1 });
mailHistorySchema.index({ recipientEmail: 1 });

module.exports = mongoose.model("MailHistory", mailHistorySchema); 