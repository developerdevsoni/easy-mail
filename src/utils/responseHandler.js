/**
 * Standardized Response Handler for Easy Mail API
 * Provides consistent response formatting across all endpoints
 */

class ResponseHandler {
   /**
    * Send success response
    * @param {Object} res - Express response object
    * @param {number} statusCode - HTTP status code (default: 200)
    * @param {string} message - Success message
    * @param {*} data - Response data
    * @param {Object} meta - Additional metadata (pagination, etc.)
    */
   static success(res, statusCode = 200, message = 'Success', data = null, meta = null) {
      const response = {
         success: true,
         message,
         timestamp: new Date().toISOString()
      };

      if (data !== null) {
         response.data = data;
      }

      if (meta !== null) {
         response.meta = meta;
      }

      return res.status(statusCode).json(response);
   }

   /**
    * Send error response
    * @param {Object} res - Express response object
    * @param {number} statusCode - HTTP status code (default: 500)
    * @param {string} message - Error message
    * @param {*} error - Error details (optional)
    * @param {string} code - Custom error code (optional)
    */
   static error(res, statusCode = 500, message = 'Internal server error', error = null, code = null) {
      const response = {
         success: false,
         message,
         timestamp: new Date().toISOString()
      };

      if (error !== null) {
         response.error = error;
      }

      if (code !== null) {
         response.code = code;
      }

      return res.status(statusCode).json(response);
   }

   /**
    * Send created response (201)
    * @param {Object} res - Express response object
    * @param {string} message - Success message
    * @param {*} data - Created resource data
    */
   static created(res, message = 'Resource created successfully', data = null) {
      return this.success(res, 201, message, data);
   }

   /**
    * Send no content response (204)
    * @param {Object} res - Express response object
    */
   static noContent(res) {
      return res.status(204).send();
   }

   /**
    * Send bad request error (400)
    * @param {Object} res - Express response object
    * @param {string} message - Error message
    * @param {*} error - Validation errors or details
    */
   static badRequest(res, message = 'Bad request', error = null) {
      return this.error(res, 400, message, error, 'BAD_REQUEST');
   }

   /**
    * Send unauthorized error (401)
    * @param {Object} res - Express response object
    * @param {string} message - Error message
    */
   static unauthorized(res, message = 'Unauthorized') {
      return this.error(res, 401, message, null, 'UNAUTHORIZED');
   }

   /**
    * Send forbidden error (403)
    * @param {Object} res - Express response object
    * @param {string} message - Error message
    */
   static forbidden(res, message = 'Forbidden') {
      return this.error(res, 403, message, null, 'FORBIDDEN');
   }

   /**
    * Send not found error (404)
    * @param {Object} res - Express response object
    * @param {string} message - Error message
    * @param {string} resource - Resource type (optional)
    */
   static notFound(res, message = 'Resource not found', resource = null) {
      const fullMessage = resource ? `${resource} not found` : message;
      return this.error(res, 404, fullMessage, null, 'NOT_FOUND');
   }

   /**
    * Send conflict error (409)
    * @param {Object} res - Express response object
    * @param {string} message - Error message
    * @param {*} error - Conflict details
    */
   static conflict(res, message = 'Resource conflict', error = null) {
      return this.error(res, 409, message, error, 'CONFLICT');
   }

   /**
    * Send validation error (422)
    * @param {Object} res - Express response object
    * @param {string} message - Error message
    * @param {Object} errors - Validation errors
    */
   static validationError(res, message = 'Validation failed', errors = null) {
      return this.error(res, 422, message, errors, 'VALIDATION_ERROR');
   }

   /**
    * Send internal server error (500)
    * @param {Object} res - Express response object
    * @param {string} message - Error message
    * @param {*} error - Error details (only in development)
    */
   static internalError(res, message = 'Internal server error', error = null) {
      const errorDetails = process.env.NODE_ENV === 'development' ? error : null;
      return this.error(res, 500, message, errorDetails, 'INTERNAL_ERROR');
   }

   /**
    * Send paginated response
    * @param {Object} res - Express response object
    * @param {string} message - Success message
    * @param {Array} data - Array of items
    * @param {Object} pagination - Pagination info
    */
   static paginated(res, message = 'Data retrieved successfully', data = [], pagination = {}) {
      const meta = {
         pagination: {
            currentPage: parseInt(pagination.currentPage) || 1,
            totalPages: parseInt(pagination.totalPages) || 1,
            totalItems: parseInt(pagination.totalItems) || 0,
            itemsPerPage: parseInt(pagination.itemsPerPage) || 10,
            hasNextPage: pagination.hasNextPage || false,
            hasPrevPage: pagination.hasPrevPage || false
         }
      };

      return this.success(res, 200, message, data, meta);
   }

   /**
    * Send list response (for non-paginated lists)
    * @param {Object} res - Express response object
    * @param {string} message - Success message
    * @param {Array} data - Array of items
    * @param {number} count - Total count
    */
   static list(res, message = 'Data retrieved successfully', data = [], count = 0) {
      const meta = {
         count: count || data.length
      };

      return this.success(res, 200, message, data, meta);
   }

   /**
    * Send single item response
    * @param {Object} res - Express response object
    * @param {string} message - Success message
    * @param {*} data - Single item data
    */
   static item(res, message = 'Data retrieved successfully', data = null) {
      return this.success(res, 200, message, data);
   }

   /**
    * Send updated response
    * @param {Object} res - Express response object
    * @param {string} message - Success message
    * @param {*} data - Updated item data
    */
   static updated(res, message = 'Resource updated successfully', data = null) {
      return this.success(res, 200, message, data);
   }

   /**
    * Send deleted response
    * @param {Object} res - Express response object
    * @param {string} message - Success message
    */
   static deleted(res, message = 'Resource deleted successfully') {
      return this.success(res, 200, message);
   }

   /**
    * Send token response (for authentication)
    * @param {Object} res - Express response object
    * @param {string} message - Success message
    * @param {Object} data - User and token data
    */
   static token(res, message = 'Authentication successful', data = null) {
      return this.success(res, 200, message, data);
   }
}

module.exports = ResponseHandler;
