const User = require("../models/user.model")

exports.createOrUpdateUser = async ({ email, name, accessToken, refreshToken }) => {
   const existingUser = await User.findOne({ email })
   if (existingUser) {
      existingUser.accessToken = accessToken
      existingUser.refreshToken = refreshToken
      return await existingUser.save()
   } else {
      const user = new User({ email, name, accessToken, refreshToken })
      return await user.save()
   }
}

exports.getUserByEmail = (email) => User.findOne({ email })
