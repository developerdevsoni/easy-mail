const express = require("express")
const mongoose = require("mongoose")
const bodyParser = require("body-parser")
const cors = require("cors")
const passport = require("passport")
const swaggerUi = require("swagger-ui-express")
const ResponseHandler = require("./utils/responseHandler")
require("dotenv").config()

// Import Swagger specs
const swaggerSpecs = require("./config/swagger.config")

// Import routes
const authRoutes = require("./routes/auth.route")
const personalTemplateRoutes = require("./routes/personalTemplate.route")
const globalTemplateRoutes = require("./routes/globalTemplate.route")
const mailRoutes = require("./routes/mail.route")

const app = express()

// Middleware
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: true }))
app.use(cors("*"))

// Initialize passport
app.use(passport.initialize())

// Database connection
mongoose
   .connect(
      process.env.MONGODB_URI ||
         "mongodb+srv://googllesoni:KzulOqfZzCdRM8Ok@cluster0.4keze1b.mongodb.net/easy-mail"
   )
   .then(() => console.log("✅ MongoDB connected successfully"))
   .catch((err) => console.error("❌ MongoDB connection error:", err))

// Health check route
app.get("/", (req, res) => {
   return ResponseHandler.success(res, 200, "Easy Mail API is running", {
      version: "1.0.0",
      timestamp: new Date().toISOString(),
      status: "healthy",
   })
})

// Swagger Documentation
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerSpecs, {
  customCss: '.swagger-ui .topbar { display: none }',
  customSiteTitle: "Easy Mail API Documentation",
  customfavIcon: "/favicon.ico",
  swaggerOptions: {
    persistAuthorization: true,
    displayRequestDuration: true,
    filter: true,
    deepLinking: true
  }
}))

// API Routes
app.use("/api/auth", authRoutes)
app.use("/api/personal-templates", personalTemplateRoutes)
app.use("/api/global-templates", globalTemplateRoutes)
app.use("/api/mail", mailRoutes)

// Error handling middleware
app.use((err, req, res, next) => {
   console.error("Error:", err)
   return ResponseHandler.internalError(
      res,
      "Internal server error",
      process.env.NODE_ENV === "development" ? err.message : null
   )
})

// 404 handler
app.use("*", (req, res) => {
   return ResponseHandler.notFound(res, "Route not found")
})

const PORT = process.env.PORT || 3000
app.listen(PORT, () => {
   console.log(`🚀 Server running on http://localhost:${PORT}`)
   console.log(`📧 Easy Mail API v1.0.0`)
   console.log(`🌍 Environment: ${process.env.NODE_ENV || "development"}`)
})
