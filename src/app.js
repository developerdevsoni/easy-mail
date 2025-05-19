const express = require("express")
const mongoose = require("mongoose")
const bodyParser = require("body-parser")
const userRoutes = require("./routes/user.route")
const mailRoutes = require("./routes/mail.route")

const app = express()
app.use(bodyParser.json())

mongoose
   .connect("mongodb+srv://googllesoni:KzulOqfZzCdRM8Ok@cluster0.4keze1b.mongodb.net/", {
      useNewUrlParser: true,
      useUnifiedTopology: true,
   })
   .then(() => console.log("MongoDB connected"))
   .catch((err) => console.error("MongoDB error:", err))

app.use("/api/users", userRoutes)
app.use("/api/mails", mailRoutes)

const PORT = 5000
app.listen(PORT, () => {
   console.log(`Server running on http://localhost:${PORT}`)
})
