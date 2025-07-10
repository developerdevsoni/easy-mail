const swaggerJsdoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Easy Mail API',
      version: '1.0.0',
      description: 'A comprehensive email management API with template support and Google OAuth integration',
      contact: {
        name: 'Easy Mail Team',
        email: 'support@easymail.com'
      },
      license: {
        name: 'MIT',
        url: 'https://opensource.org/licenses/MIT'
      }
    },
    servers: [
      {
        url: 'http://localhost:3000',
        description: 'Development server'
      },
      {
        url: 'https://api.easymail.com',
        description: 'Production server'
      }
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
          description: 'JWT token obtained from login/register endpoints'
        }
      },
      schemas: {
        // User schemas
        User: {
          type: 'object',
          properties: {
            _id: { type: 'string', example: '507f1f77bcf86cd799439011' },
            name: { type: 'string', example: 'John Doe' },
            email: { type: 'string', format: 'email', example: 'john@example.com' },
            photoUrl: { type: 'string', example: 'https://example.com/photo.jpg' },
            loginMethod: { type: 'string', enum: ['email', 'google'], example: 'email' },
            isEmailVerified: { type: 'boolean', example: true },
            preferences: { type: 'object' },
            createdAt: { type: 'string', format: 'date-time' },
            updatedAt: { type: 'string', format: 'date-time' }
          }
        },
        RegisterRequest: {
          type: 'object',
          required: ['email', 'password', 'name'],
          properties: {
            email: { type: 'string', format: 'email', example: 'john@example.com' },
            password: { type: 'string', minLength: 6, example: 'password123' },
            name: { type: 'string', example: 'John Doe' }
          }
        },
        LoginRequest: {
          type: 'object',
          required: ['email', 'password'],
          properties: {
            email: { type: 'string', format: 'email', example: 'john@example.com' },
            password: { type: 'string', example: 'password123' }
          }
        },
        GoogleLoginRequest: {
          type: 'object',
          required: ['idToken'],
          properties: {
            idToken: { type: 'string', example: 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...' }
          }
        },
        ProfileUpdateRequest: {
          type: 'object',
          properties: {
            name: { type: 'string', example: 'John Doe' },
            preferences: { type: 'object' }
          }
        },
        // Template schemas
        PersonalTemplate: {
          type: 'object',
          properties: {
            _id: { type: 'string', example: '507f1f77bcf86cd799439011' },
            userId: { type: 'string', example: '507f1f77bcf86cd799439011' },
            name: { type: 'string', example: 'Welcome Email' },
            subject: { type: 'string', example: 'Welcome to our platform!' },
            body: { type: 'string', example: 'Dear {{recipientName}}, welcome to our platform!' },
            regards: { type: 'string', example: 'Best regards, {{senderName}}' },
            category: { type: 'string', example: 'welcome' },
            isFavorite: { type: 'boolean', example: false },
            usageCount: { type: 'number', example: 5 },
            createdAt: { type: 'string', format: 'date-time' },
            updatedAt: { type: 'string', format: 'date-time' }
          }
        },
        GlobalTemplate: {
          type: 'object',
          properties: {
            _id: { type: 'string', example: '507f1f77bcf86cd799439011' },
            name: { type: 'string', example: 'Professional Follow-up' },
            subject: { type: 'string', example: 'Follow-up on our discussion' },
            body: { type: 'string', example: 'Dear {{recipientName}}, I hope this email finds you well.' },
            regards: { type: 'string', example: 'Best regards, {{senderName}}' },
            category: { type: 'string', example: 'follow-up' },
            tags: { type: 'array', items: { type: 'string' }, example: ['professional', 'follow-up'] },
            usageCount: { type: 'number', example: 150 },
            isActive: { type: 'boolean', example: true },
            createdAt: { type: 'string', format: 'date-time' },
            updatedAt: { type: 'string', format: 'date-time' }
          }
        },
        CreateTemplateRequest: {
          type: 'object',
          required: ['name', 'subject', 'body', 'regards'],
          properties: {
            name: { type: 'string', example: 'Welcome Email' },
            subject: { type: 'string', example: 'Welcome to our platform!' },
            body: { type: 'string', example: 'Dear {{recipientName}}, welcome to our platform!' },
            regards: { type: 'string', example: 'Best regards, {{senderName}}' },
            category: { type: 'string', example: 'welcome' }
          }
        },
        UpdateTemplateRequest: {
          type: 'object',
          properties: {
            name: { type: 'string', example: 'Welcome Email' },
            subject: { type: 'string', example: 'Welcome to our platform!' },
            body: { type: 'string', example: 'Dear {{recipientName}}, welcome to our platform!' },
            regards: { type: 'string', example: 'Best regards, {{senderName}}' },
            category: { type: 'string', example: 'welcome' }
          }
        },
        // Mail schemas
        SendEmailRequest: {
          type: 'object',
          required: ['recipientEmail', 'subject', 'body', 'regards'],
          properties: {
            recipientEmail: { type: 'string', format: 'email', example: 'recipient@example.com' },
            recipientName: { type: 'string', example: 'Jane Doe' },
            subject: { type: 'string', example: 'Important Update' },
            body: { type: 'string', example: 'This is the email body content.' },
            regards: { type: 'string', example: 'Best regards, John Doe' },
            templateId: { type: 'string', example: '507f1f77bcf86cd799439011' },
            globalTemplateId: { type: 'string', example: '507f1f77bcf86cd799439011' },
            aiGenerated: { type: 'boolean', example: false }
          }
        },
        SendEmailWithTemplateRequest: {
          type: 'object',
          required: ['recipientEmail'],
          properties: {
            recipientEmail: { type: 'string', format: 'email', example: 'recipient@example.com' },
            recipientName: { type: 'string', example: 'Jane Doe' },
            templateId: { type: 'string', example: '507f1f77bcf86cd799439011' },
            globalTemplateId: { type: 'string', example: '507f1f77bcf86cd799439011' },
            customizations: {
              type: 'object',
              properties: {
                subject: { type: 'string', example: 'Custom Subject' },
                body: { type: 'string', example: 'Custom body content' },
                regards: { type: 'string', example: 'Custom regards' }
              }
            }
          }
        },
        MailHistory: {
          type: 'object',
          properties: {
            _id: { type: 'string', example: '507f1f77bcf86cd799439011' },
            userId: { type: 'string', example: '507f1f77bcf86cd799439011' },
            recipientEmail: { type: 'string', format: 'email', example: 'recipient@example.com' },
            recipientName: { type: 'string', example: 'Jane Doe' },
            subject: { type: 'string', example: 'Important Update' },
            body: { type: 'string', example: 'Email body content' },
            regards: { type: 'string', example: 'Best regards, John Doe' },
            status: { type: 'string', enum: ['sent', 'failed'], example: 'sent' },
            templateUsed: { type: 'string', example: '507f1f77bcf86cd799439011' },
            globalTemplateUsed: { type: 'string', example: '507f1f77bcf86cd799439011' },
            aiGenerated: { type: 'boolean', example: false },
            sentAt: { type: 'string', format: 'date-time' },
            createdAt: { type: 'string', format: 'date-time' }
          }
        },
        MailStats: {
          type: 'object',
          properties: {
            totalEmails: { type: 'number', example: 150 },
            sentEmails: { type: 'number', example: 145 },
            failedEmails: { type: 'number', example: 5 },
            successRate: { type: 'number', example: 96.67 },
            templatesUsed: { type: 'number', example: 25 },
            thisMonth: { type: 'number', example: 45 },
            thisWeek: { type: 'number', example: 12 }
          }
        },
        // Response schemas
        SuccessResponse: {
          type: 'object',
          properties: {
            success: { type: 'boolean', example: true },
            message: { type: 'string', example: 'Operation completed successfully' },
            data: { type: 'object' },
            timestamp: { type: 'string', format: 'date-time' }
          }
        },
        ErrorResponse: {
          type: 'object',
          properties: {
            success: { type: 'boolean', example: false },
            message: { type: 'string', example: 'Error message' },
            error: { type: 'string', example: 'Detailed error information' },
            timestamp: { type: 'string', format: 'date-time' }
          }
        },
        PaginatedResponse: {
          type: 'object',
          properties: {
            success: { type: 'boolean', example: true },
            message: { type: 'string', example: 'Data retrieved successfully' },
            data: {
              type: 'object',
              properties: {
                items: { type: 'array' },
                pagination: {
                  type: 'object',
                  properties: {
                    page: { type: 'number', example: 1 },
                    limit: { type: 'number', example: 10 },
                    total: { type: 'number', example: 100 },
                    pages: { type: 'number', example: 10 }
                  }
                }
              }
            }
          }
        }
      }
    },
    tags: [
      {
        name: 'Authentication',
        description: 'User authentication and authorization endpoints'
      },
      {
        name: 'Personal Templates',
        description: 'User-specific email template management'
      },
      {
        name: 'Global Templates',
        description: 'Public email templates available to all users'
      },
      {
        name: 'Mail',
        description: 'Email sending and history management'
      }
    ]
  },
  apis: ['./src/routes/*.js', './src/controller/*.js']
};

const specs = swaggerJsdoc(options);

module.exports = specs; 