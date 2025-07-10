const GlobalTemplate = require('../models/globalTemplate.model');
const ResponseHandler = require('../utils/responseHandler');

// Get all global templates with category filtering
const getGlobalTemplates = async (req, res) => {
   try {
      const { category, search, page = 1, limit = 10 } = req.query;

      const query = { isActive: true };

      // Filter by category
      if (category && category !== 'all') {
         query.category = category;
      }

      // Search functionality
      if (search) {
         query.$or = [
            { name: { $regex: search, $options: 'i' } },
            { subject: { $regex: search, $options: 'i' } },
            { description: { $regex: search, $options: 'i' } },
            { tags: { $in: [new RegExp(search, 'i')] } }
         ];
      }

      const templates = await GlobalTemplate.find(query)
         .sort({ usageCount: -1, createdAt: -1 })
         .limit(limit * 1)
         .skip((page - 1) * limit);

      const total = await GlobalTemplate.countDocuments(query);

      // Get unique categories for filtering
      const categories = await GlobalTemplate.distinct('category', { isActive: true });

      const pagination = {
         currentPage: parseInt(page),
         totalPages: Math.ceil(total / limit),
         totalItems: total,
         itemsPerPage: parseInt(limit),
         hasNextPage: page < Math.ceil(total / limit),
         hasPrevPage: page > 1
      };

      const meta = {
         categories,
         pagination
      };

      return ResponseHandler.success(res, 200, 'Global templates retrieved successfully', templates, meta);
   } catch (error) {
      console.error('Get global templates error:', error);
      return ResponseHandler.internalError(res, 'Failed to get global templates', error.message);
   }
};

// Get template by ID
const getGlobalTemplateById = async (req, res) => {
   try {
      const { templateId } = req.params;

      const template = await GlobalTemplate.findOne({ _id: templateId, isActive: true });

      if (!template) {
         return ResponseHandler.notFound(res, 'Template not found', 'Global Template');
      }

      return ResponseHandler.item(res, 'Template retrieved successfully', { template });
   } catch (error) {
      console.error('Get global template by ID error:', error);
      return ResponseHandler.internalError(res, 'Failed to get template', error.message);
   }
};

// Get templates by category
const getTemplatesByCategory = async (req, res) => {
   try {
      const { category } = req.params;
      const { page = 1, limit = 10 } = req.query;

      const templates = await GlobalTemplate.find({ 
         category, 
         isActive: true 
      })
         .sort({ usageCount: -1, createdAt: -1 })
         .limit(limit * 1)
         .skip((page - 1) * limit);

      const total = await GlobalTemplate.countDocuments({ category, isActive: true });

      const pagination = {
         currentPage: parseInt(page),
         totalPages: Math.ceil(total / limit),
         totalItems: total,
         itemsPerPage: parseInt(limit),
         hasNextPage: page < Math.ceil(total / limit),
         hasPrevPage: page > 1
      };

      const meta = {
         category,
         pagination
      };

      return ResponseHandler.success(res, 200, 'Templates retrieved successfully', templates, meta);
   } catch (error) {
      console.error('Get templates by category error:', error);
      return ResponseHandler.internalError(res, 'Failed to get templates by category', error.message);
   }
};

// Get popular templates
const getPopularTemplates = async (req, res) => {
   try {
      const { limit = 5 } = req.query;

      const templates = await GlobalTemplate.find({ isActive: true })
         .sort({ usageCount: -1 })
         .limit(parseInt(limit));

      return ResponseHandler.list(res, 'Popular templates retrieved successfully', templates, templates.length);
   } catch (error) {
      console.error('Get popular templates error:', error);
      return ResponseHandler.internalError(res, 'Failed to get popular templates', error.message);
   }
};

// Increment usage count (called when template is used)
const incrementUsageCount = async (req, res) => {
   try {
      const { templateId } = req.params;

      const template = await GlobalTemplate.findByIdAndUpdate(
         templateId,
         { $inc: { usageCount: 1 } },
         { new: true }
      );

      if (!template) {
         return ResponseHandler.notFound(res, 'Template not found', 'Global Template');
      }

      return ResponseHandler.updated(res, 'Usage count updated', { template });
   } catch (error) {
      console.error('Increment usage count error:', error);
      return ResponseHandler.internalError(res, 'Failed to update usage count', error.message);
   }
};

// Admin: Create global template (protected route)
const createGlobalTemplate = async (req, res) => {
   try {
      const { name, subject, body, regards, category, description, tags } = req.body;

      // Validate required fields
      if (!name || !subject || !body || !regards || !category) {
         return ResponseHandler.badRequest(res, 'Name, subject, body, regards, and category are required');
      }

      const template = new GlobalTemplate({
         name,
         subject,
         body,
         regards,
         category,
         description,
         tags: tags || [],
         createdBy: req.user._id
      });

      await template.save();

      return ResponseHandler.created(res, 'Global template created successfully', { template });
   } catch (error) {
      console.error('Create global template error:', error);
      return ResponseHandler.internalError(res, 'Failed to create global template', error.message);
   }
};

module.exports = {
   getGlobalTemplates,
   getGlobalTemplateById,
   getTemplatesByCategory,
   getPopularTemplates,
   incrementUsageCount,
   createGlobalTemplate
}; 