const mongoose = require("mongoose");

const personalTemplateSchema = new mongoose.Schema({
   userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
   },
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
   isFavorite: {
      type: Boolean,
      default: false
   },
   tags: [{
      type: String,
      trim: true
   }],
   usageCount: {
      type: Number,
      default: 0
   }
}, { 
   timestamps: true 
});

// Index for better query performance
personalTemplateSchema.index({ userId: 1, isFavorite: -1 });
personalTemplateSchema.index({ userId: 1, tags: 1 });

module.exports = mongoose.model("PersonalTemplate", personalTemplateSchema); 