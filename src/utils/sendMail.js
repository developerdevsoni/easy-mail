const nodemailer = require("nodemailer")
const { google } = require("googleapis")

const CLIENT_ID = "YOUR_CLIENT_ID"
const CLIENT_SECRET = "YOUR_CLIENT_SECRET"
const REDIRECT_URI = "https://developers.google.com/oauthplayground"

const oAuth2Client = new google.auth.OAuth2(CLIENT_ID, CLIENT_SECRET, REDIRECT_URI)

async function sendEmailOAuth(from, to, subject, body, tokens) {
   oAuth2Client.setCredentials({
      access_token: tokens.access_token,
      refresh_token: tokens.refresh_token,
   })

   const accessToken = await oAuth2Client.getAccessToken()

   const transport = nodemailer.createTransport({
      service: "gmail",
      auth: {
         type: "OAuth2",
         user: from,
         clientId: CLIENT_ID,
         clientSecret: CLIENT_SECRET,
         refreshToken: tokens.refresh_token,
         accessToken: accessToken.token,
      },
   })

   const mailOptions = {
      from,
      to,
      subject,
      html: body,
   }

   return await transport.sendMail(mailOptions)
}

module.exports = { sendEmailOAuth }
