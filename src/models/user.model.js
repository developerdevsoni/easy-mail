const mongoose = require("mongoose")

const userSchema = new mongoose.Schema({
   email: String,
   name: String,
   serverAuthToken: String,
   id: String,
   photoUrl: String,
})

module.exports = mongoose.model("User", userSchema)
