const { google } = require('googleapis');
require('dotenv').config();

const oAuth2Client = new google.auth.OAuth2(
  process.env.GOOGLE_CLIENT_ID,
  process.env.GOOGLE_CLIENT_SECRET,
  process.env.REDIRECT_URI
);

exports.getAuthURL = () => {
  const SCOPES = ['https://www.googleapis.com/auth/gmail.send'];
  return oAuth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: SCOPES,
    prompt: 'consent',
  });
};
exports.getAccessToken = async (code) => {
  const { tokens } = await oAuth2Client.getToken(code);
  oAuth2Client.setCredentials(tokens);

  const oauth2 = google.oauth2({
    auth: oAuth2Client,
    version: 'v2',
  });

  const { data } = await oauth2.userinfo.get(); // fetch email, name, etc.
  return {
    tokens,
    user: {
      email: data.email,
      name: data.name,
    },
  };
};
exports.getOAuth2Client = () => oAuth2Client;
