const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");

const userSchema = new mongoose.Schema({
   email: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      lowercase: true
   },
   name: {
      type: String,
      required: true,
      trim: true
   },
   password: {
      type: String,
      required: function() {
         return !this.googleId; // Password only required if not Google OAuth
      },
      minlength: 6
   },
   googleId: {
      type: String,
      unique: true,
      sparse: true
   },
   photoUrl: {
      type: String,
      default: null
   },
   isEmailVerified: {
      type: Boolean,
      default: false
   },
   loginMethod: {
      type: String,
      enum: ['google', 'email'],
      required: true
   },
   lastLogin: {
      type: Date,
      default: Date.now
   },
   preferences: {
      defaultTemplate: {
         type: mongoose.Schema.Types.ObjectId,
         ref: 'PersonalTemplate'
      },
      theme: {
         type: String,
         default: 'light'
      }
   }
}, { 
   timestamps: true 
});

// Hash password before saving
userSchema.pre('save', async function(next) {
   if (this.isModified('password')) {
      this.password = await bcrypt.hash(this.password, 12);
   }
   next();
});

// Method to compare password
userSchema.methods.comparePassword = async function(candidatePassword) {
   return await bcrypt.compare(candidatePassword, this.password);
};

// Method to get public profile
userSchema.methods.getPublicProfile = function() {
   const userObject = this.toObject();
   delete userObject.password;
   return userObject;
};

module.exports = mongoose.model("User", userSchema);
