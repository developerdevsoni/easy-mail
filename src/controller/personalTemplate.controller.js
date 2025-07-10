const PersonalTemplate = require('../models/personalTemplate.model');
const ResponseHandler = require('../utils/responseHandler');

// Create personal template
const createTemplate = async (req, res) => {
   try {
      const { name, subject, body, regards, tags, isFavorite } = req.body;
      const userId = req.user._id;

      // Validate required fields
      if (!name || !subject || !body || !regards) {
         return ResponseHandler.badRequest(res, 'Name, subject, body, and regards are required');
      }

      const template = new PersonalTemplate({
         userId,
         name,
         subject,
         body,
         regards,
         tags: tags || [],
         isFavorite: isFavorite || false
      });

      await template.save();

      return ResponseHandler.created(res, 'Personal template created successfully', { template });
   } catch (error) {
      console.error('Create template error:', error);
      return ResponseHandler.internalError(res, 'Failed to create template', error.message);
   }
};

// Get all personal templates for user
const getTemplates = async (req, res) => {
   try {
      const userId = req.user._id;
      const { page = 1, limit = 10, isFavorite, search } = req.query;

      const query = { userId };

      // Filter by favorite status
      if (isFavorite !== undefined) {
         query.isFavorite = isFavorite === 'true';
      }

      // Search functionality
      if (search) {
         query.$or = [
            { name: { $regex: search, $options: 'i' } },
            { subject: { $regex: search, $options: 'i' } },
            { tags: { $in: [new RegExp(search, 'i')] } }
         ];
      }

      const templates = await PersonalTemplate.find(query)
         .sort({ isFavorite: -1, createdAt: -1 })
         .limit(limit * 1)
         .skip((page - 1) * limit);

      const total = await PersonalTemplate.countDocuments(query);

      const pagination = {
         currentPage: parseInt(page),
         totalPages: Math.ceil(total / limit),
         totalItems: total,
         itemsPerPage: parseInt(limit),
         hasNextPage: page < Math.ceil(total / limit),
         hasPrevPage: page > 1
      };

      return ResponseHandler.paginated(res, 'Templates retrieved successfully', templates, pagination);
   } catch (error) {
      console.error('Get templates error:', error);
      return ResponseHandler.internalError(res, 'Failed to get templates', error.message);
   }
};

// Get single template by ID
const getTemplateById = async (req, res) => {
   try {
      const { templateId } = req.params;
      const userId = req.user._id;

      const template = await PersonalTemplate.findOne({ _id: templateId, userId });

      if (!template) {
         return ResponseHandler.notFound(res, 'Template not found', 'Template');
      }

      return ResponseHandler.item(res, 'Template retrieved successfully', { template });
   } catch (error) {
      console.error('Get template by ID error:', error);
      return ResponseHandler.internalError(res, 'Failed to get template', error.message);
   }
};

// Update template
const updateTemplate = async (req, res) => {
   try {
      const { templateId } = req.params;
      const userId = req.user._id;
      const { name, subject, body, regards, tags, isFavorite } = req.body;

      const template = await PersonalTemplate.findOne({ _id: templateId, userId });

      if (!template) {
         return ResponseHandler.notFound(res, 'Template not found', 'Template');
      }

      // Update fields
      if (name !== undefined) template.name = name;
      if (subject !== undefined) template.subject = subject;
      if (body !== undefined) template.body = body;
      if (regards !== undefined) template.regards = regards;
      if (tags !== undefined) template.tags = tags;
      if (isFavorite !== undefined) template.isFavorite = isFavorite;

      await template.save();

      return ResponseHandler.updated(res, 'Template updated successfully', { template });
   } catch (error) {
      console.error('Update template error:', error);
      return ResponseHandler.internalError(res, 'Failed to update template', error.message);
   }
};

// Delete template
const deleteTemplate = async (req, res) => {
   try {
      const { templateId } = req.params;
      const userId = req.user._id;

      const template = await PersonalTemplate.findOneAndDelete({ _id: templateId, userId });

      if (!template) {
         return ResponseHandler.notFound(res, 'Template not found', 'Template');
      }

      return ResponseHandler.deleted(res, 'Template deleted successfully');
   } catch (error) {
      console.error('Delete template error:', error);
      return ResponseHandler.internalError(res, 'Failed to delete template', error.message);
   }
};

// Toggle favorite status
const toggleFavorite = async (req, res) => {
   try {
      const { templateId } = req.params;
      const userId = req.user._id;

      const template = await PersonalTemplate.findOne({ _id: templateId, userId });

      if (!template) {
         return ResponseHandler.notFound(res, 'Template not found', 'Template');
      }

      template.isFavorite = !template.isFavorite;
      await template.save();

      const message = `Template ${template.isFavorite ? 'added to' : 'removed from'} favorites`;
      return ResponseHandler.updated(res, message, { template });
   } catch (error) {
      console.error('Toggle favorite error:', error);
      return ResponseHandler.internalError(res, 'Failed to toggle favorite', error.message);
   }
};

// Get favorite templates
const getFavoriteTemplates = async (req, res) => {
   try {
      const userId = req.user._id;

      const templates = await PersonalTemplate.find({ userId, isFavorite: true })
         .sort({ updatedAt: -1 });

      return ResponseHandler.list(res, 'Favorite templates retrieved successfully', templates, templates.length);
   } catch (error) {
      console.error('Get favorite templates error:', error);
      return ResponseHandler.internalError(res, 'Failed to get favorite templates', error.message);
   }
};

module.exports = {
   createTemplate,
   getTemplates,
   getTemplateById,
   updateTemplate,
   deleteTemplate,
   toggleFavorite,
   getFavoriteTemplates
}; 