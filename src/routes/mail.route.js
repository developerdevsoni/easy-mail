const express = require('express');
const router = express.Router();
const mailController = require('../controller/mail.controller');
const { authenticateToken } = require('../middleware/auth.middleware');

// All routes require authentication
router.use(authenticateToken);

/**
 * @swagger
 * /api/mail/send:
 *   post:
 *     summary: Send a new email
 *     tags: [Mail]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/SendEmailRequest'
 *     responses:
 *       200:
 *         description: Email sent successfully
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
 *                   example: Email sent successfully
 *                 data:
 *                   type: object
 *                   properties:
 *                     messageId:
 *                       type: string
 *                       example: <123456789@example.com>
 *                     mailHistory:
 *                       $ref: '#/components/schemas/MailHistory'
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
 *       500:
 *         description: Internal server error - email sending failed
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.post('/send', mailController.sendEmail);

/**
 * @swagger
 * /api/mail/send-with-template:
 *   post:
 *     summary: Send email using a template
 *     tags: [Mail]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/SendEmailWithTemplateRequest'
 *     responses:
 *       200:
 *         description: Email sent successfully with template
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
 *                   example: Email sent successfully
 *                 data:
 *                   type: object
 *                   properties:
 *                     messageId:
 *                       type: string
 *                       example: <123456789@example.com>
 *                     mailHistory:
 *                       $ref: '#/components/schemas/MailHistory'
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
 *       404:
 *         description: Template not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       500:
 *         description: Internal server error - email sending failed
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.post('/send-with-template', mailController.sendEmailWithTemplate);

/**
 * @swagger
 * /api/mail/history:
 *   get:
 *     summary: Get user's email history
 *     tags: [Mail]
 *     security:
 *       - bearerAuth: []
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
 *         name: status
 *         schema:
 *           type: string
 *           enum: [sent, failed]
 *         description: Filter by email status
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter emails from this date (YYYY-MM-DD)
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter emails until this date (YYYY-MM-DD)
 *     responses:
 *       200:
 *         description: Email history retrieved successfully
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
 *                         $ref: '#/components/schemas/MailHistory'
 *       401:
 *         description: Unauthorized - invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.get('/history', mailController.getMailHistory);

/**
 * @swagger
 * /api/mail/stats:
 *   get:
 *     summary: Get user's email statistics
 *     tags: [Mail]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Email statistics retrieved successfully
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
 *                   example: Email statistics retrieved successfully
 *                 data:
 *                   $ref: '#/components/schemas/MailStats'
 *       401:
 *         description: Unauthorized - invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.get('/stats', mailController.getMailStats);

module.exports = router;
