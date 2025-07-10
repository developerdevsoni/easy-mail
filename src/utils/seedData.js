const GlobalTemplate = require('../models/globalTemplate.model');
const mongoose = require('mongoose');

const sampleTemplates = [
   {
      name: "Business Introduction",
      subject: "Introduction from {{senderName}}",
      body: `Dear {{recipientName}},

I hope this email finds you well. My name is {{senderName}} and I'm reaching out to introduce myself and explore potential collaboration opportunities.

I have been working in the industry for several years and I'm particularly interested in [specific area of interest]. I believe there could be valuable synergies between our work and I would love to discuss this further.

Would you be available for a brief call next week to discuss potential collaboration opportunities?

Looking forward to hearing from you.`,
      regards: "Best regards,\n{{senderName}}",
      category: "business",
      description: "Professional business introduction template",
      tags: ["introduction", "business", "professional"]
   },
   {
      name: "Thank You Email",
      subject: "Thank you for your time",
      body: `Dear {{recipientName}},

I wanted to take a moment to express my sincere gratitude for taking the time to meet with me today. I truly appreciate your insights and the valuable information you shared.

Our conversation was incredibly helpful and I'm excited about the potential opportunities we discussed. I will follow up on the points we covered and keep you updated on our progress.

Thank you again for your generosity with your time and expertise.`,
      regards: "Best regards,\n{{senderName}}",
      category: "thank-you",
      description: "Professional thank you email template",
      tags: ["thank-you", "gratitude", "professional"]
   },
   {
      name: "Meeting Follow-up",
      subject: "Follow-up from our meeting",
      body: `Dear {{recipientName}},

Thank you for the productive meeting we had on {{date}}. I wanted to follow up on the key points we discussed and confirm our next steps.

Key Action Items:
• [Action item 1]
• [Action item 2]
• [Action item 3]

Next Steps:
• [Next step 1]
• [Next step 2]

I will send you an update on our progress by [specific date]. Please don't hesitate to reach out if you have any questions in the meantime.`,
      regards: "Best regards,\n{{senderName}}",
      category: "follow-up",
      description: "Professional meeting follow-up template",
      tags: ["follow-up", "meeting", "professional"]
   },
   {
      name: "Apology Email",
      subject: "Sincere apologies",
      body: `Dear {{recipientName}},

I hope this email finds you well. I wanted to reach out to sincerely apologize for [specific issue or situation].

I understand that this may have caused inconvenience, and I take full responsibility for the situation. I want to assure you that I am taking steps to ensure this doesn't happen again.

Please know that I value our relationship and I'm committed to making this right. I would appreciate the opportunity to discuss this further and address any concerns you may have.

Thank you for your understanding and patience.`,
      regards: "Sincerely,\n{{senderName}}",
      category: "apology",
      description: "Professional apology email template",
      tags: ["apology", "professional", "sincere"]
   },
   {
      name: "Job Application",
      subject: "Application for [Position] at [Company]",
      body: `Dear Hiring Manager,

I am writing to express my strong interest in the [Position] role at [Company]. With my background in [relevant field] and passion for [specific area], I believe I would be an excellent fit for your team.

Key Qualifications:
• [Qualification 1]
• [Qualification 2]
• [Qualification 3]

I am particularly drawn to [Company] because of [specific reason - company values, mission, etc.]. I am excited about the opportunity to contribute to your team and help drive [specific goals or projects].

I have attached my resume for your review and would welcome the opportunity to discuss how my skills and experience align with your needs.

Thank you for considering my application. I look forward to hearing from you.`,
      regards: "Best regards,\n{{senderName}}",
      category: "professional",
      description: "Professional job application template",
      tags: ["job-application", "professional", "career"]
   },
   {
      name: "Casual Invitation",
      subject: "Join us for [Event]",
      body: `Hi {{recipientName}},

I hope you're doing well! I wanted to invite you to [Event] that we're hosting on {{date}} at {{time}}.

Details:
• Event: [Event name]
• Date: {{date}}
• Time: {{time}}
• Location: [Location]

It would be great to have you there! Please let me know if you can make it so I can plan accordingly.

Looking forward to seeing you!`,
      regards: "Cheers,\n{{senderName}}",
      category: "casual",
      description: "Casual event invitation template",
      tags: ["invitation", "casual", "event"]
   },
   {
      name: "Formal Invitation",
      subject: "Invitation to [Formal Event]",
      body: `Dear {{recipientName}},

We are pleased to extend a formal invitation to you for [Event Name] on {{date}} at {{time}}.

Event Details:
• Event: [Event Name]
• Date: {{date}}
• Time: {{time}}
• Venue: [Venue Name]
• Address: [Full Address]
• Dress Code: [Dress Code]

Please RSVP by [RSVP Date] to confirm your attendance. We look forward to your presence at this special occasion.

For any inquiries, please contact [Contact Information].`,
      regards: "Sincerely,\n{{senderName}}",
      category: "formal",
      description: "Formal event invitation template",
      tags: ["invitation", "formal", "event"]
   },
   {
      name: "Project Update",
      subject: "Project Update - [Project Name]",
      body: `Dear {{recipientName}},

I hope this email finds you well. I wanted to provide you with an update on the [Project Name] project.

Current Status:
• [Status update 1]
• [Status update 2]
• [Status update 3]

Key Achievements:
• [Achievement 1]
• [Achievement 2]

Next Steps:
• [Next step 1]
• [Next step 2]

Timeline: We are on track to complete the project by [target date].

Please let me know if you have any questions or if you'd like to schedule a call to discuss this in more detail.`,
      regards: "Best regards,\n{{senderName}}",
      category: "business",
      description: "Professional project update template",
      tags: ["project-update", "business", "professional"]
   }
];

const seedGlobalTemplates = async () => {
   try {
      // Clear existing templates
      await GlobalTemplate.deleteMany({});
      
      // Insert sample templates
      const templates = await GlobalTemplate.insertMany(sampleTemplates);
      
      console.log(`✅ Successfully seeded ${templates.length} global templates`);
      
      // Log categories
      const categories = await GlobalTemplate.distinct('category');
      console.log(`📂 Available categories: ${categories.join(', ')}`);
      
   } catch (error) {
      console.error('❌ Error seeding data:', error);
   }
};

// Run seeder if called directly
if (require.main === module) {
   mongoose.connect(process.env.MONGODB_URI || "mongodb+srv://googllesoni:KzulOqfZzCdRM8Ok@cluster0.4keze1b.mongodb.net/easy-mail", {
      useNewUrlParser: true,
      useUnifiedTopology: true,
   })
   .then(() => {
      console.log('🔗 Connected to MongoDB');
      return seedGlobalTemplates();
   })
   .then(() => {
      console.log('✅ Seeding completed');
      process.exit(0);
   })
   .catch((error) => {
      console.error('❌ Error:', error);
      process.exit(1);
   });
}

module.exports = { seedGlobalTemplates }; 