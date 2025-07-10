const nodemailer = require('nodemailer');
const MailHistory = require('../models/mailHistory.model');
const PersonalTemplate = require('../models/personalTemplate.model');
const GlobalTemplate = require('../models/globalTemplate.model');
const ResponseHandler = require('../utils/responseHandler');

// Configure nodemailer transporter
const createTransporter = () => {
   return nodemailer.createTransporter({
      service: 'gmail',
      auth: {
         user: process.env.EMAIL_USER,
         pass: process.env.EMAIL_PASSWORD
      }
   });
};

// Send email with template
const sendEmail = async (req, res) => {
   try {
      const {
         recipientEmail,
         recipientName,
         subject,
         body,
         regards,
         templateId,
         globalTemplateId,
         aiGenerated = false
      } = req.body;

      const userId = req.user._id;

      // Validate required fields
      if (!recipientEmail || !subject || !body || !regards) {
         return ResponseHandler.badRequest(res, 'Recipient email, subject, body, and regards are required');
      }

      // Create mail history record
      const mailHistory = new MailHistory({
         userId,
         recipientEmail,
         recipientName,
         subject,
         body,
         regards,
         templateUsed: templateId,
         globalTemplateUsed: globalTemplateId,
         aiGenerated,
         metadata: {
            ipAddress: req.ip,
            userAgent: req.get('User-Agent')
         }
      });

      // Send email
      const transporter = createTransporter();
      
      const mailOptions = {
         from: process.env.EMAIL_USER,
         to: recipientEmail,
         subject: subject,
         html: `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
               <div style="background-color: #f8f9fa; padding: 20px; border-radius: 8px;">
                  <h2 style="color: #333; margin-bottom: 20px;">${subject}</h2>
                  <div style="line-height: 1.6; color: #555;">
                     ${body.replace(/\n/g, '<br>')}
                  </div>
                  <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd;">
                     <p style="color: #666; font-style: italic;">
                        ${regards}
                     </p>
                  </div>
               </div>
            </div>
         `
      };

      const info = await transporter.sendMail(mailOptions);

      // Update mail history with success status
      mailHistory.status = 'sent';
      mailHistory.sentAt = new Date();
      await mailHistory.save();

      // Update template usage count if using global template
      if (globalTemplateId) {
         await GlobalTemplate.findByIdAndUpdate(
            globalTemplateId,
            { $inc: { usageCount: 1 } }
         );
      }

      // Update personal template usage count if using personal template
      if (templateId) {
         await PersonalTemplate.findByIdAndUpdate(
            templateId,
            { $inc: { usageCount: 1 } }
         );
      }

      return ResponseHandler.success(res, 200, 'Email sent successfully', {
         messageId: info.messageId,
         mailHistory: mailHistory
      });
   } catch (error) {
      console.error('Send email error:', error);
      
      // Update mail history with failure status
      if (mailHistory) {
         mailHistory.status = 'failed';
         await mailHistory.save();
      }

      return ResponseHandler.internalError(res, 'Failed to send email', error.message);
   }
};

// Send email using template
const sendEmailWithTemplate = async (req, res) => {
   try {
      const {
         recipientEmail,
         recipientName,
         templateId,
         globalTemplateId,
         customizations = {}
      } = req.body;

      const userId = req.user._id;

      // Validate required fields
      if (!recipientEmail) {
         return ResponseHandler.badRequest(res, 'Recipient email is required');
      }

      let template = null;

      // Get template
      if (templateId) {
         template = await PersonalTemplate.findOne({ _id: templateId, userId });
      } else if (globalTemplateId) {
         template = await GlobalTemplate.findOne({ _id: globalTemplateId, isActive: true });
      }

      if (!template) {
         return ResponseHandler.notFound(res, 'Template not found', 'Template');
      }

      // Apply customizations
      let subject = template.subject;
      let body = template.body;
      let regards = template.regards;

      if (customizations.subject) {
         subject = customizations.subject;
      }
      if (customizations.body) {
         body = customizations.body;
      }
      if (customizations.regards) {
         regards = customizations.regards;
      }

      // Replace placeholders
      const placeholders = {
         '{{recipientName}}': recipientName || 'there',
         '{{senderName}}': req.user.name,
         '{{date}}': new Date().toLocaleDateString(),
         '{{time}}': new Date().toLocaleTimeString()
      };

      Object.keys(placeholders).forEach(placeholder => {
         const regex = new RegExp(placeholder, 'g');
         subject = subject.replace(regex, placeholders[placeholder]);
         body = body.replace(regex, placeholders[placeholder]);
         regards = regards.replace(regex, placeholders[placeholder]);
      });

      // Send email using the main sendEmail function
      req.body = {
         recipientEmail,
         recipientName,
         subject,
         body,
         regards,
         templateId,
         globalTemplateId
      };

      return await sendEmail(req, res);
   } catch (error) {
      console.error('Send email with template error:', error);
      return ResponseHandler.internalError(res, 'Failed to send email with template', error.message);
   }
};

// Get mail history
const getMailHistory = async (req, res) => {
   try {
      const userId = req.user._id;
      const { page = 1, limit = 10, status } = req.query;

      const query = { userId };

      if (status) {
         query.status = status;
      }

      const history = await MailHistory.find(query)
         .sort({ sentAt: -1 })
         .limit(limit * 1)
         .skip((page - 1) * limit)
         .populate('templateUsed', 'name')
         .populate('globalTemplateUsed', 'name category');

      const total = await MailHistory.countDocuments(query);

      const pagination = {
         currentPage: parseInt(page),
         totalPages: Math.ceil(total / limit),
         totalItems: total,
         itemsPerPage: parseInt(limit),
         hasNextPage: page < Math.ceil(total / limit),
         hasPrevPage: page > 1
      };

      return ResponseHandler.paginated(res, 'Mail history retrieved successfully', history, pagination);
   } catch (error) {
      console.error('Get mail history error:', error);
      return ResponseHandler.internalError(res, 'Failed to get mail history', error.message);
   }
};

// Get mail statistics
const getMailStats = async (req, res) => {
   try {
      const userId = req.user._id;

      const stats = await MailHistory.aggregate([
         { $match: { userId: userId } },
         {
            $group: {
               _id: null,
               totalSent: { $sum: { $cond: [{ $eq: ['$status', 'sent'] }, 1, 0] } },
               totalFailed: { $sum: { $cond: [{ $eq: ['$status', 'failed'] }, 1, 0] } },
               totalPending: { $sum: { $cond: [{ $eq: ['$status', 'pending'] }, 1, 0] } },
               aiGenerated: { $sum: { $cond: ['$aiGenerated', 1, 0] } }
            }
         }
      ]);

      const monthlyStats = await MailHistory.aggregate([
         { $match: { userId: userId } },
         {
            $group: {
               _id: {
                  year: { $year: '$sentAt' },
                  month: { $month: '$sentAt' }
               },
               count: { $sum: 1 }
            }
         },
         { $sort: { '_id.year': -1, '_id.month': -1 } },
         { $limit: 12 }
      ]);

      const data = {
         stats: stats[0] || {
            totalSent: 0,
            totalFailed: 0,
            totalPending: 0,
            aiGenerated: 0
         },
         monthlyStats
      };

      return ResponseHandler.success(res, 200, 'Mail statistics retrieved successfully', data);
   } catch (error) {
      console.error('Get mail stats error:', error);
      return ResponseHandler.internalError(res, 'Failed to get mail statistics', error.message);
   }
};

module.exports = {
   sendEmail,
   sendEmailWithTemplate,
   getMailHistory,
   getMailStats
};
