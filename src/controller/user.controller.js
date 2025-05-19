const userService = require("../services/user.service")

exports.saveGoogleUser = async (req, res) => {
   try {
      const { email, name, accessToken, refreshToken } = req.body
      const user = await userService.createOrUpdateUser({
         email,
         name,
         accessToken,
         refreshToken,
      })
      res.status(200).json(user)
   } catch (err) {
      console.error("Error saving user:", err)
      res.status(500).json({ error: err.message })
   }
}

exports.getUserByEmail = async (req, res) => {
   try {
      const user = await userService.getUserByEmail(req.params.email)
      if (!user) return res.status(404).json({ message: "User not found" })
      res.status(200).json(user)
   } catch (err) {
      console.error("Error fetching user:", err)
      res.status(500).json({ error: err.message })
   }
}
