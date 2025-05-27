const User = require("../models/user.model")

exports.createOrUpdateUser = async ({ email, name, serverAuthToken, id, photoUrl }) => {
   const existingUser = await User.findOne({ email })
   if (existingUser) {
      existingUser.serverAuthToken = serverAuthToken
      existingUser.id = id
      return await existingUser.save()
   } else {
      const user = new User({ email, name, serverAuthToken, id, photoUrl })
      return await user.save()
   }
}

exports.getUserByEmail = (email) => User.findOne({ email })
