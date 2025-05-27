module.exports = {
   successResponse: (res, message = "Success", data = {}) => {
      return res.status(200).json({
         success: true,
         message,
         data,
      })
   },

   errorResponse: (res, error = "Something went wrong", statusCode = 500) => {
      return res.status(statusCode).json({
         success: false,
         message: error,
      })
   },

   validationError: (res, message = "Validation failed") => {
      return res.status(400).json({
         success: false,
         message,
      })
   },
}
