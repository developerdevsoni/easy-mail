const express = require('express');
const router = express.Router();
const globalTemplateController = require('../controller/globalTemplate.controller');
const { authenticateToken, optionalAuth } = require('../middleware/auth.middleware');

// Public routes (no authentication required)
/**
 * @swagger
 * /api/global-templates:
 *   get:
 *     summary: Get all global templates
 *     tags: [Global Templates]
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *         description: Page number for pagination
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 10
 *         description: Number of items per page
 *       - in: query
 *         name: category
 *         schema:
 *           type: string
 *         description: Filter by template category
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         description: Search templates by name or content
 *       - in: query
 *         name: tags
 *         schema:
 *           type: string
 *         description: Filter by tags (comma-separated)
 *     responses:
 *       200:
 *         description: Global templates retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/PaginatedResponse'
 *               properties:
 *                 data:
 *                   type: object
 *                   properties:
 *                     items:
 *                       type: array
 *                       items:
 *                         $ref: '#/components/schemas/GlobalTemplate'
 */
router.get('/', optionalAuth, globalTemplateController.getGlobalTemplates);

/**
 * @swagger
 * /api/global-templates/popular:
 *   get:
 *     summary: Get popular global templates
 *     tags: [Global Templates]
 *     parameters:
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 50
 *           default: 10
 *         description: Number of popular templates to return
 *     responses:
 *       200:
 *         description: Popular templates retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: Popular templates retrieved successfully
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/GlobalTemplate'
 */
router.get('/popular', optionalAuth, globalTemplateController.getPopularTemplates);

/**
 * @swagger
 * /api/global-templates/category/{category}:
 *   get:
 *     summary: Get global templates by category
 *     tags: [Global Templates]
 *     parameters:
 *       - in: path
 *         name: category
 *         required: true
 *         schema:
 *           type: string
 *         description: Template category
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *         description: Page number for pagination
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 10
 *         description: Number of items per page
 *     responses:
 *       200:
 *         description: Templates by category retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/PaginatedResponse'
 *               properties:
 *                 data:
 *                   type: object
 *                   properties:
 *                     items:
 *                       type: array
 *                       items:
 *                         $ref: '#/components/schemas/GlobalTemplate'
 *       404:
 *         description: Category not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.get('/category/:category', optionalAuth, globalTemplateController.getTemplatesByCategory);

/**
 * @swagger
 * /api/global-templates/{templateId}:
 *   get:
 *     summary: Get a specific global template by ID
 *     tags: [Global Templates]
 *     parameters:
 *       - in: path
 *         name: templateId
 *         required: true
 *         schema:
 *           type: string
 *         description: Template ID
 *     responses:
 *       200:
 *         description: Template retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: Template retrieved successfully
 *                 data:
 *                   $ref: '#/components/schemas/GlobalTemplate'
 *       404:
 *         description: Template not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.get('/:templateId', optionalAuth, globalTemplateController.getGlobalTemplateById);

// Protected routes (authentication required)
/**
 * @swagger
 * /api/global-templates:
 *   post:
 *     summary: Create a new global template (Admin only)
 *     tags: [Global Templates]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/CreateTemplateRequest'
 *     responses:
 *       201:
 *         description: Global template created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: Global template created successfully
 *                 data:
 *                   $ref: '#/components/schemas/GlobalTemplate'
 *       400:
 *         description: Bad request - missing required fields
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       401:
 *         description: Unauthorized - invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       403:
 *         description: Forbidden - insufficient permissions
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.post('/', authenticateToken, globalTemplateController.createGlobalTemplate);

/**
 * @swagger
 * /api/global-templates/{templateId}/usage:
 *   patch:
 *     summary: Increment usage count for a global template
 *     tags: [Global Templates]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: templateId
 *         required: true
 *         schema:
 *           type: string
 *         description: Template ID
 *     responses:
 *       200:
 *         description: Usage count incremented successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: Usage count updated successfully
 *                 data:
 *                   $ref: '#/components/schemas/GlobalTemplate'
 *       401:
 *         description: Unauthorized - invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       404:
 *         description: Template not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.patch('/:templateId/usage', authenticateToken, globalTemplateController.incrementUsageCount);

module.exports = router; 