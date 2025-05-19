const { getAuthURL, getAccessToken } = require("../auth/googleAuth")

exports.loginWithGoogle = (req, res) => {
   res.redirect(getAuthURL())
}
const User = require("../models/user.model") // import your user model

exports.handleGoogleCallback = async (req, res) => {
   try {
      console.log("handleGoogleCallback  ---", req)
      const code = req.query.code
      const { tokens, user } = await getAccessToken(code)

      // Upsert user in DB
      const existingUser = await User.findOneAndUpdate(
         { email: user.email },
         {
            email: user.email,
            name: user.name,
            accessToken: tokens.access_token,
            refreshToken: tokens.refresh_token,
         },
         { upsert: true, new: true }
      )

      // Redirect or return token info
      res.json({
         message: "Authentication successful",
         user: {
            id: existingUser._id,
            email: existingUser.email,
            name: existingUser.name,
         },
         tokens,
      })
   } catch (err) {
      console.error(err)
      res.status(500).json({ error: "Authentication failed" })
   }
}
