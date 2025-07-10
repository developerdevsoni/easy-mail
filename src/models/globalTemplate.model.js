const mongoose = require("mongoose");

const globalTemplateSchema = new mongoose.Schema({
   name: {
      type: String,
      required: true,
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
   category: {
      type: String,
      required: true,
      enum: [
         'business',
         'personal',
         'professional',
         'casual',
         'formal',
         'invitation',
         'thank-you',
         'apology',
         'follow-up',
         'introduction',
         'other'
      ],
      default: 'other'
   },
   description: {
      type: String,
      trim: true
   },
   tags: [{
      type: String,
      trim: true
   }],
   isActive: {
      type: Boolean,
      default: true
   },
   usageCount: {
      type: Number,
      default: 0
   },
   createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null // null for system-created templates
   }
}, { 
   timestamps: true 
});

// Indexes for better query performance
globalTemplateSchema.index({ category: 1, isActive: 1 });
globalTemplateSchema.index({ tags: 1 });
globalTemplateSchema.index({ usageCount: -1 });

module.exports = mongoose.model("GlobalTemplate", globalTemplateSchema); 