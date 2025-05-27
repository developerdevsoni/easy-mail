const express = require("express")
const mongoose = require("mongoose")
const bodyParser = require("body-parser")
const userRoutes = require("./routes/user.route")
const mailRoutes = require("./routes/mail.route")
const cors = require("cors")

const app = express() // ✅ Correct here

app.use(bodyParser.json())
app.use(cors())
app.use(
   cors({
      origin: "http://localhost:3000", // your frontend
      credentials: true,
   })
)
mongoose
   .connect("mongodb+srv://googllesoni:KzulOqfZzCdRM8Ok@cluster0.4keze1b.mongodb.net/", {
      useNewUrlParser: true,
      useUnifiedTopology: true,
   })
   .then(() => console.log("MongoDB connected"))
   .catch((err) => console.error("MongoDB error:", err))

// ✅ Add a test root route
app.get("/", (req, res) => {
   res.send("Easy Mail API is running")
})

app.use("/api/users", userRoutes)
app.use("/api/mails", mailRoutes)

const PORT = 3000
app.listen(PORT, () => {
   console.log(`Server running on http://localhost:${PORT}`)
})
