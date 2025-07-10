const jwt = require('jsonwebtoken');
const User = require('../models/user.model');
const ResponseHandler = require('../utils/responseHandler');

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key-change-in-production';

// Generate JWT token
const generateToken = (userId) => {
   return jwt.sign({ userId }, JWT_SECRET, { expiresIn: '7d' });
};

// Verify JWT token middleware
const authenticateToken = async (req, res, next) => {
   try {
      const authHeader = req.headers['authorization'];
      const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

      if (!token) {
         return ResponseHandler.unauthorized(res, 'Access token required');
      }

      const decoded = jwt.verify(token, JWT_SECRET);
      const user = await User.findById(decoded.userId).select('-password');
      
      if (!user) {
         return ResponseHandler.unauthorized(res, 'Invalid token');
      }

      req.user = user;
      next();
   } catch (error) {
      if (error.name === 'JsonWebTokenError') {
         return ResponseHandler.unauthorized(res, 'Invalid token');
      }
      if (error.name === 'TokenExpiredError') {
         return ResponseHandler.unauthorized(res, 'Token expired');
      }
      return ResponseHandler.internalError(res, 'Authentication error', error.message);
   }
};

// Optional authentication middleware (doesn't fail if no token)
const optionalAuth = async (req, res, next) => {
   try {
      const authHeader = req.headers['authorization'];
      const token = authHeader && authHeader.split(' ')[1];

      if (token) {
         const decoded = jwt.verify(token, JWT_SECRET);
         const user = await User.findById(decoded.userId).select('-password');
         if (user) {
            req.user = user;
         }
      }
      next();
   } catch (error) {
      // Continue without authentication
      next();
   }
};

module.exports = {
   generateToken,
   authenticateToken,
   optionalAuth,
   JWT_SECRET
}; 