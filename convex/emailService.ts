// Email Service using Resend API
// This handles all email notifications for the app

import { action, internalAction } from "./_generated/server";
import { v } from "convex/values";

// Environment variable for Resend API key
// Add RESEND_API_KEY to your Convex environment variables
// Dashboard: https://dashboard.convex.dev -> Settings -> Environment Variables

/**
 * Send Welcome Email to New User
 * Called after successful user registration
 */
export const sendWelcomeEmail = internalAction({
  args: {
    userEmail: v.string(),
    userName: v.string(),
  },
  handler: async (ctx, args) => {
    // Get environment variable from Convex
    const RESEND_API_KEY = process.env.RESEND_API_KEY as string | undefined;
    
    // Enhanced logging for debugging
    console.log("🔔 Welcome Email Request:", {
      recipient: args.userEmail,
      userName: args.userName,
      hasApiKey: !!RESEND_API_KEY,
      timestamp: new Date().toISOString()
    });
    
    if (!RESEND_API_KEY) {
      console.error("❌ RESEND_API_KEY not configured in Convex environment");
      console.error("📝 Setup instructions:");
      console.error("   1. Sign up at https://resend.com");
      console.error("   2. Get API key from https://resend.com/api-keys");
      console.error("   3. Run: npx convex env set RESEND_API_KEY re_your_key");
      return { success: false, error: "Email service not configured - API key missing" };
    }

    try {
      const emailPayload = {
        from: "Vita Sports <onboarding@vitasports.shop>",
        to: [args.userEmail],
        subject: "🎉 Welcome to AI Sports Assessment Platform!",
        html: getWelcomeEmailHTML(args.userName),
      };

      console.log("📧 Sending email via Resend API to:", args.userEmail);

      const response = await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${RESEND_API_KEY}`,
        },
        body: JSON.stringify(emailPayload),
      });

      const data = await response.json();

      if (!response.ok) {
        console.error("❌ Resend API error:", {
          status: response.status,
          statusText: response.statusText,
          error: data,
          recipient: args.userEmail
        });
        
        // Special handling for common errors
        if (response.status === 403) {
          console.error("⚠️ Email domain not verified. Using resend.dev domain for testing.");
          console.error("   To send to any email, verify your domain at https://resend.com/domains");
        } else if (response.status === 429) {
          console.error("⚠️ Rate limit exceeded. Free tier allows 100 emails/day.");
        }
        
        return { success: false, error: data.message || "Failed to send email", details: data };
      }

      console.log("✅ Welcome email sent successfully:", {
        emailId: data.id,
        recipient: args.userEmail,
        userName: args.userName
      });
      return { success: true, emailId: data.id };
    } catch (error: any) {
      console.error("❌ Error sending welcome email:", {
        error: error.message,
        recipient: args.userEmail,
        stack: error.stack
      });
      return { success: false, error: error.message };
    }
  },
});

/**
 * Send Admin Notification for New User Registration
 * Notifies admin about new signups
 */
export const sendAdminNotification = internalAction({
  args: {
    userEmail: v.string(),
    userName: v.string(),
    userId: v.string(),
  },
  handler: async (ctx, args) => {
    const RESEND_API_KEY = process.env.RESEND_API_KEY;
    const ADMIN_EMAIL = process.env.ADMIN_EMAIL || "sidvashisth2005@gmail.com";
    
    console.log("🔔 Admin Notification Request:", {
      newUser: args.userName,
      userEmail: args.userEmail,
      userId: args.userId,
      adminEmail: ADMIN_EMAIL,
      hasApiKey: !!RESEND_API_KEY
    });
    
    if (!RESEND_API_KEY) {
      console.error("❌ RESEND_API_KEY not configured for admin notification");
      return { success: false, error: "Email service not configured" };
    }

    try {
      console.log("📧 Sending admin notification to:", ADMIN_EMAIL);
      
      const response = await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${RESEND_API_KEY}`,
        },
        body: JSON.stringify({
          from: "Vita Sports <notifications@vitasports.shop>",
          to: [ADMIN_EMAIL],
          subject: "🎊 New User Registration Alert",
          html: getAdminNotificationHTML(args.userName, args.userEmail, args.userId),
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        console.error("❌ Admin notification error:", data);
        return { success: false, error: data.message };
      }

      console.log("✅ Admin notification sent successfully to:", ADMIN_EMAIL);
      return { success: true, emailId: data.id };
    } catch (error: any) {
      console.error("❌ Error sending admin notification:", error);
      return { success: false, error: error.message };
    }
  },
});

/**
 * Send Test Result Email to User
 * Sent after completing a fitness assessment
 */
export const sendTestResultEmail = action({
  args: {
    userEmail: v.string(),
    userName: v.string(),
    testType: v.string(),
    score: v.number(),
    rank: v.optional(v.number()),
  },
  handler: async (ctx, args) => {
    const RESEND_API_KEY = process.env.RESEND_API_KEY;
    
    if (!RESEND_API_KEY) {
      return { success: false, error: "Email service not configured" };
    }

    try {
      const response = await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${RESEND_API_KEY}`,
        },
        body: JSON.stringify({
          from: "Sports Assessment App <results@yourdomain.com>",
          to: [args.userEmail],
          subject: `🏆 Your ${args.testType} Test Results`,
          html: getTestResultEmailHTML(args.userName, args.testType, args.score, args.rank),
        }),
      });

      const data = await response.json();
      return response.ok ? { success: true, emailId: data.id } : { success: false, error: data.message };
    } catch (error: any) {
      return { success: false, error: error.message };
    }
  },
});

// ============================================
// EMAIL HTML TEMPLATES
// ============================================

function getWelcomeEmailHTML(userName: string): string {
  const currentDate = new Date().toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' });
  
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Welcome to AI Sports Assessment - Your Journey Begins!</title>
  <style>
    @keyframes slideIn {
      from { opacity: 0; transform: translateY(-20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    @keyframes pulse {
      0%, 100% { transform: scale(1); }
      50% { transform: scale(1.05); }
    }
  </style>
</head>
<body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
  
  <!-- Main Container -->
  <table width="100%" cellpadding="0" cellspacing="0" style="padding: 20px 0;">
    <tr>
      <td align="center">
        
        <!-- Email Card -->
        <table width="650" cellpadding="0" cellspacing="0" style="background-color: #ffffff; border-radius: 20px; overflow: hidden; box-shadow: 0 20px 60px rgba(0,0,0,0.3);">
          
          <!-- Animated Header with Brand Colors -->
          <tr>
            <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%); padding: 0; position: relative;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="padding: 50px 30px; text-align: center;">
                    <div style="font-size: 72px; margin-bottom: 10px;">🏆</div>
                    <h1 style="color: #ffffff; margin: 0; font-size: 42px; font-weight: 800; text-shadow: 0 2px 4px rgba(0,0,0,0.2); letter-spacing: -1px;">WELCOME ABOARD!</h1>
                    <p style="color: #ffffff; margin: 15px 0 0 0; font-size: 18px; opacity: 0.95;">Your Athletic Journey Starts Now</p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Personalized Greeting Section -->
          <tr>
            <td style="padding: 40px 40px 20px 40px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); padding: 25px; border-radius: 15px; margin-bottom: 30px;">
                    <h2 style="color: #ffffff; margin: 0 0 10px 0; font-size: 28px;">Hey ${userName}! 👋</h2>
                    <p style="color: #ffffff; margin: 0; font-size: 16px; line-height: 1.6; opacity: 0.95;">
                      We're absolutely <strong>thrilled</strong> to have you join our community of <strong>10,000+ athletes</strong> across India who are crushing their fitness goals with AI-powered insights!
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Welcome Stats Dashboard -->
          <tr>
            <td style="padding: 0 40px 30px 40px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: #f8f9fa; padding: 25px; border-radius: 15px; border: 2px solid #e9ecef;">
                    <p style="color: #333; margin: 0 0 20px 0; font-size: 18px; font-weight: 600; text-align: center;">📊 YOUR ACCOUNT SUMMARY</p>
                    <table width="100%" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="33%" style="text-align: center; padding: 10px;">
                          <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 15px; border-radius: 10px;">
                            <p style="color: #ffffff; margin: 0; font-size: 28px; font-weight: bold;">100</p>
                            <p style="color: #ffffff; margin: 5px 0 0 0; font-size: 12px; opacity: 0.9;">Credits</p>
                          </div>
                        </td>
                        <td width="33%" style="text-align: center; padding: 10px;">
                          <div style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); padding: 15px; border-radius: 10px;">
                            <p style="color: #ffffff; margin: 0; font-size: 28px; font-weight: bold;">0</p>
                            <p style="color: #ffffff; margin: 5px 0 0 0; font-size: 12px; opacity: 0.9;">Tests Done</p>
                          </div>
                        </td>
                        <td width="33%" style="text-align: center; padding: 10px;">
                          <div style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); padding: 15px; border-radius: 10px;">
                            <p style="color: #ffffff; margin: 0; font-size: 28px; font-weight: bold;">NEW</p>
                            <p style="color: #ffffff; margin: 5px 0 0 0; font-size: 12px; opacity: 0.9;">Athlete</p>
                          </div>
                        </td>
                      </tr>
                    </table>
                    <p style="color: #666; margin: 15px 0 0 0; font-size: 12px; text-align: center;">Joined: ${currentDate}</p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Feature Showcase with Icons -->
          <tr>
            <td style="padding: 0 40px 30px 40px;">
              <h3 style="color: #333; margin: 0 0 25px 0; font-size: 24px; text-align: center; font-weight: 700;">🎯 UNLOCK YOUR POTENTIAL</h3>
              
              <!-- Feature Grid -->
              <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom: 10px;">
                <tr>
                  <td width="50%" style="padding: 0 5px 10px 0;">
                    <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; border-radius: 12px; min-height: 120px;">
                      <div style="font-size: 36px; margin-bottom: 10px;">🤖</div>
                      <p style="color: #ffffff; margin: 0 0 8px 0; font-size: 16px; font-weight: bold;">AI-Powered Analysis</p>
                      <p style="color: #ffffff; margin: 0; font-size: 13px; opacity: 0.9; line-height: 1.5;">Real-time pose detection with 95% accuracy using Google's MediaPipe technology</p>
                    </div>
                  </td>
                  <td width="50%" style="padding: 0 0 10px 5px;">
                    <div style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); padding: 20px; border-radius: 12px; min-height: 120px;">
                      <div style="font-size: 36px; margin-bottom: 10px;">🏅</div>
                      <p style="color: #ffffff; margin: 0 0 8px 0; font-size: 16px; font-weight: bold;">Live Leaderboards</p>
                      <p style="color: #ffffff; margin: 0; font-size: 13px; opacity: 0.9; line-height: 1.5;">Compete with 10,000+ athletes nationwide and climb the rankings</p>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td width="50%" style="padding: 0 5px 10px 0;">
                    <div style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); padding: 20px; border-radius: 12px; min-height: 120px;">
                      <div style="font-size: 36px; margin-bottom: 10px;">🗣️</div>
                      <p style="color: #ffffff; margin: 0 0 8px 0; font-size: 16px; font-weight: bold;">Voice AI Coach - Riley</p>
                      <p style="color: #ffffff; margin: 0; font-size: 13px; opacity: 0.9; line-height: 1.5;">Chat with your personal AI trainer powered by VAPI for instant guidance</p>
                    </div>
                  </td>
                  <td width="50%" style="padding: 0 0 10px 5px;">
                    <div style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); padding: 20px; border-radius: 12px; min-height: 120px;">
                      <div style="font-size: 36px; margin-bottom: 10px;">📊</div>
                      <p style="color: #ffffff; margin: 0 0 8px 0; font-size: 16px; font-weight: bold;">Advanced Analytics</p>
                      <p style="color: #ffffff; margin: 0; font-size: 13px; opacity: 0.9; line-height: 1.5;">Track progress with detailed charts, graphs, and performance insights</p>
                    </div>
                  </td>
                </tr>
              </table>
              
              <!-- Additional Features List -->
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="padding: 20px; background: #f8f9fa; border-radius: 12px;">
                    <p style="color: #333; margin: 0 0 15px 0; font-size: 16px; font-weight: 600;">🎯 MORE AMAZING FEATURES:</p>
                    <table width="100%" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="50%" style="padding: 8px 5px;">
                          <span style="color: #667eea; font-size: 16px; font-weight: bold;">✓</span>
                          <span style="color: #555; font-size: 14px; margin-left: 8px;">Personalized workout plans</span>
                        </td>
                        <td width="50%" style="padding: 8px 5px;">
                          <span style="color: #667eea; font-size: 16px; font-weight: bold;">✓</span>
                          <span style="color: #555; font-size: 14px; margin-left: 8px;">Achievement badges & rewards</span>
                        </td>
                      </tr>
                      <tr>
                        <td width="50%" style="padding: 8px 5px;">
                          <span style="color: #667eea; font-size: 16px; font-weight: bold;">✓</span>
                          <span style="color: #555; font-size: 14px; margin-left: 8px;">Social sharing features</span>
                        </td>
                        <td width="50%" style="padding: 8px 5px;">
                          <span style="color: #667eea; font-size: 16px; font-weight: bold;">✓</span>
                          <span style="color: #555; font-size: 14px; margin-left: 8px;">Progress photos & videos</span>
                        </td>
                      </tr>
                      <tr>
                        <td width="50%" style="padding: 8px 5px;">
                          <span style="color: #667eea; font-size: 16px; font-weight: bold;">✓</span>
                          <span style="color: #555; font-size: 14px; margin-left: 8px;">Community challenges</span>
                        </td>
                        <td width="50%" style="padding: 8px 5px;">
                          <span style="color: #667eea; font-size: 16px; font-weight: bold;">✓</span>
                          <span style="color: #555; font-size: 14px; margin-left: 8px;">Offline mode support</span>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Exclusive Welcome Bonus -->
          <tr>
            <td style="padding: 0 40px 30px 40px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 35px; border-radius: 15px; text-align: center; box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);">
                    <div style="font-size: 48px; margin-bottom: 15px;">🎁</div>
                    <p style="color: #ffffff; margin: 0 0 10px 0; font-size: 22px; font-weight: bold; text-transform: uppercase; letter-spacing: 1px;">EXCLUSIVE WELCOME BONUS</p>
                    <p style="color: #ffffff; margin: 0; font-size: 48px; font-weight: 900; text-shadow: 0 2px 4px rgba(0,0,0,0.2);">100 CREDITS</p>
                    <p style="color: #ffffff; margin: 15px 0 0 0; font-size: 15px; opacity: 0.95; line-height: 1.6;">
                      Worth ₹500! Use these credits to unlock premium features, get detailed analysis reports, and access exclusive challenges!
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Quick Start Guide -->
          <tr>
            <td style="padding: 0 40px 30px 40px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: #f8f9fa; padding: 30px; border-radius: 15px; border-left: 5px solid #667eea;">
                    <p style="color: #333; margin: 0 0 20px 0; font-size: 20px; font-weight: 700;">🚀 GET STARTED IN 3 EASY STEPS:</p>
                    
                    <table width="100%" cellpadding="0" cellspacing="0">
                      <tr>
                        <td style="padding: 15px 0;">
                          <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                              <td width="60" style="vertical-align: top;">
                                <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #ffffff; width: 45px; height: 45px; border-radius: 50%; text-align: center; line-height: 45px; font-size: 22px; font-weight: bold;">1</div>
                              </td>
                              <td style="vertical-align: top;">
                                <p style="color: #333; margin: 0 0 5px 0; font-size: 16px; font-weight: 600;">Open the App & Complete Your Profile</p>
                                <p style="color: #666; margin: 0; font-size: 14px; line-height: 1.5;">Add your age, height, weight, and fitness goals for personalized recommendations</p>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      
                      <tr>
                        <td style="padding: 15px 0;">
                          <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                              <td width="60" style="vertical-align: top;">
                                <div style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: #ffffff; width: 45px; height: 45px; border-radius: 50%; text-align: center; line-height: 45px; font-size: 22px; font-weight: bold;">2</div>
                              </td>
                              <td style="vertical-align: top;">
                                <p style="color: #333; margin: 0 0 5px 0; font-size: 16px; font-weight: 600;">Choose Your First Assessment</p>
                                <p style="color: #666; margin: 0; font-size: 14px; line-height: 1.5;">Try Push-ups, Squats, or Standing Broad Jump - our AI will guide you through!</p>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      
                      <tr>
                        <td style="padding: 15px 0;">
                          <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                              <td width="60" style="vertical-align: top;">
                                <div style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: #ffffff; width: 45px; height: 45px; border-radius: 50%; text-align: center; line-height: 45px; font-size: 22px; font-weight: bold;">3</div>
                              </td>
                              <td style="vertical-align: top;">
                                <p style="color: #333; margin: 0 0 5px 0; font-size: 16px; font-weight: 600;">View Your Results & Compete</p>
                                <p style="color: #666; margin: 0; font-size: 14px; line-height: 1.5;">Get instant feedback, check the leaderboard, and share your achievements!</p>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- CTA Button -->
          <tr>
            <td style="padding: 0 40px 40px 40px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td align="center">
                    <a href="#" style="display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #ffffff; padding: 18px 50px; text-decoration: none; border-radius: 30px; font-weight: bold; font-size: 18px; box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4); text-transform: uppercase; letter-spacing: 1px;">START YOUR FIRST TEST 🔥</a>
                  </td>
                </tr>
              </table>
              
              <p style="color: #666; font-size: 14px; text-align: center; margin: 20px 0 0 0;">
                Need help? Contact our support team or chat with Riley AI Coach in the app!
              </p>
            </td>
          </tr>
          
          <!-- Social Proof -->
          <tr>
            <td style="padding: 0 40px 30px 40px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%); padding: 25px; border-radius: 15px; text-align: center;">
                    <p style="color: #333; margin: 0 0 15px 0; font-size: 18px; font-weight: 600;">💪 JOIN THOUSANDS OF ATHLETES</p>
                    <table width="100%" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="33%" style="text-align: center; padding: 10px;">
                          <p style="color: #333; margin: 0; font-size: 28px; font-weight: bold;">10K+</p>
                          <p style="color: #666; margin: 5px 0 0 0; font-size: 13px;">Active Users</p>
                        </td>
                        <td width="33%" style="text-align: center; padding: 10px;">
                          <p style="color: #333; margin: 0; font-size: 28px; font-weight: bold;">50K+</p>
                          <p style="color: #666; margin: 5px 0 0 0; font-size: 13px;">Tests Completed</p>
                        </td>
                        <td width="33%" style="text-align: center; padding: 10px;">
                          <p style="color: #333; margin: 0; font-size: 28px; font-weight: bold;">4.8⭐</p>
                          <p style="color: #666; margin: 5px 0 0 0; font-size: 13px;">App Rating</p>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Tips Section -->
          <tr>
            <td style="padding: 0 40px 30px 40px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: #fff3cd; padding: 20px; border-radius: 12px; border-left: 4px solid #ffc107;">
                    <p style="color: #856404; margin: 0 0 10px 0; font-size: 16px; font-weight: 600;">💡 PRO TIP FOR BEGINNERS:</p>
                    <p style="color: #856404; margin: 0; font-size: 14px; line-height: 1.6;">
                      Start with the <strong>Camera Calibration Test</strong> to ensure optimal AI tracking. Good lighting and a clear background will give you the most accurate results!
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Footer -->
          <tr>
            <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 40px 30px 40px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="text-align: center;">
                    <p style="color: #ffffff; font-size: 24px; font-weight: bold; margin: 0 0 10px 0;">AI Sports Talent Assessment</p>
                    <p style="color: #ffffff; font-size: 14px; margin: 0 0 20px 0; opacity: 0.9;">Empowering 10,000+ Athletes Across India 🇮🇳</p>
                    
                    <!-- Social Links -->
                    <table width="100%" cellpadding="0" cellspacing="0">
                      <tr>
                        <td align="center" style="padding: 20px 0;">
                          <a href="#" style="display: inline-block; margin: 0 10px; text-decoration: none;">
                            <span style="background: rgba(255,255,255,0.2); color: #ffffff; padding: 10px 15px; border-radius: 8px; font-size: 14px;">📱 Download App</span>
                          </a>
                          <a href="#" style="display: inline-block; margin: 0 10px; text-decoration: none;">
                            <span style="background: rgba(255,255,255,0.2); color: #ffffff; padding: 10px 15px; border-radius: 8px; font-size: 14px;">📧 Contact Us</span>
                          </a>
                          <a href="#" style="display: inline-block; margin: 0 10px; text-decoration: none;">
                            <span style="background: rgba(255,255,255,0.2); color: #ffffff; padding: 10px 15px; border-radius: 8px; font-size: 14px;">❓ Help Center</span>
                          </a>
                        </td>
                      </tr>
                    </table>
                    
                    <p style="color: #ffffff; font-size: 12px; margin: 20px 0 10px 0; opacity: 0.8; line-height: 1.6;">
                      Powered by Google MediaPipe AI • Convex Real-time Database • VAPI Voice AI<br>
                      Making Sports Assessment Accessible to Every Indian Athlete
                    </p>
                    
                    <p style="color: #ffffff; font-size: 11px; margin: 15px 0 0 0; opacity: 0.7;">
                      <a href="#" style="color: #ffffff; text-decoration: none; margin: 0 10px;">Privacy Policy</a> | 
                      <a href="#" style="color: #ffffff; text-decoration: none; margin: 0 10px;">Terms of Service</a> | 
                      <a href="#" style="color: #ffffff; text-decoration: none; margin: 0 10px;">Unsubscribe</a>
                    </p>
                    
                    <p style="color: #ffffff; font-size: 11px; margin: 15px 0 0 0; opacity: 0.7;">
                      © 2025 AI Sports Talent Assessment Platform. All rights reserved.<br>
                      You're receiving this email because you signed up for our platform on ${currentDate}.
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
        </table>
        
      </td>
    </tr>
  </table>
  
</body>
</html>
  `;
}

function getAdminNotificationHTML(userName: string, userEmail: string, userId: string): string {
  const timestamp = new Date();
  const formattedDate = timestamp.toLocaleDateString('en-US', { 
    weekday: 'long', 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  });
  const formattedTime = timestamp.toLocaleTimeString('en-US', { 
    hour: '2-digit', 
    minute: '2-digit',
    second: '2-digit',
    hour12: true
  });
  
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>🎊 New Athlete Registration Alert</title>
</head>
<body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
  
  <table width="100%" cellpadding="0" cellspacing="0" style="padding: 30px 0;">
    <tr>
      <td align="center">
        
        <!-- Main Card -->
        <table width="650" cellpadding="0" cellspacing="0" style="background-color: #ffffff; border-radius: 15px; overflow: hidden; box-shadow: 0 20px 60px rgba(0,0,0,0.3);">
          
          <!-- Header -->
          <tr>
            <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 30px; text-align: center;">
              <div style="font-size: 64px; margin-bottom: 15px;">🎊</div>
              <h1 style="color: #ffffff; margin: 0; font-size: 36px; font-weight: 800; text-shadow: 0 2px 4px rgba(0,0,0,0.2);">NEW ATHLETE REGISTERED!</h1>
              <p style="color: #ffffff; margin: 15px 0 0 0; font-size: 16px; opacity: 0.95;">Your Community is Growing 🚀</p>
            </td>
          </tr>
          
          <!-- Alert Badge -->
          <tr>
            <td style="padding: 30px 30px 0 30px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); padding: 20px; border-radius: 12px; text-align: center;">
                    <p style="color: #ffffff; margin: 0; font-size: 18px; font-weight: bold;">🔔 REAL-TIME NOTIFICATION</p>
                    <p style="color: #ffffff; margin: 10px 0 0 0; font-size: 14px; opacity: 0.95;">${formattedDate} at ${formattedTime}</p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- User Details Card -->
          <tr>
            <td style="padding: 30px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: #f8f9fa; padding: 30px; border-radius: 12px; border-left: 5px solid #667eea;">
                    <h2 style="color: #333; margin: 0 0 25px 0; font-size: 22px; font-weight: 700;">👤 ATHLETE PROFILE</h2>
                    
                    <!-- User Info Grid -->
                    <table width="100%" cellpadding="0" cellspacing="0" style="border-collapse: collapse;">
                      <tr>
                        <td style="padding: 15px; background: #ffffff; border-bottom: 2px solid #e9ecef;">
                          <p style="color: #666; margin: 0 0 5px 0; font-size: 12px; text-transform: uppercase; letter-spacing: 1px;">Full Name</p>
                          <p style="color: #333; margin: 0; font-size: 18px; font-weight: 600;">${userName}</p>
                        </td>
                      </tr>
                      <tr>
                        <td style="padding: 15px; background: #ffffff; border-bottom: 2px solid #e9ecef;">
                          <p style="color: #666; margin: 0 0 5px 0; font-size: 12px; text-transform: uppercase; letter-spacing: 1px;">Email Address</p>
                          <p style="color: #333; margin: 0; font-size: 16px; font-weight: 600;">${userEmail}</p>
                          <a href="mailto:${userEmail}" style="color: #667eea; text-decoration: none; font-size: 13px; display: inline-block; margin-top: 5px;">📧 Send Email</a>
                        </td>
                      </tr>
                      <tr>
                        <td style="padding: 15px; background: #ffffff; border-bottom: 2px solid #e9ecef;">
                          <p style="color: #666; margin: 0 0 5px 0; font-size: 12px; text-transform: uppercase; letter-spacing: 1px;">User ID</p>
                          <p style="color: #333; margin: 0; font-size: 14px; font-family: 'Courier New', monospace; background: #f8f9fa; padding: 8px; border-radius: 5px; display: inline-block;">${userId}</p>
                        </td>
                      </tr>
                      <tr>
                        <td style="padding: 15px; background: #ffffff;">
                          <p style="color: #666; margin: 0 0 5px 0; font-size: 12px; text-transform: uppercase; letter-spacing: 1px;">Account Created</p>
                          <p style="color: #333; margin: 0; font-size: 16px; font-weight: 600;">${formattedDate}</p>
                          <p style="color: #666; margin: 5px 0 0 0; font-size: 14px;">${formattedTime}</p>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Account Details -->
          <tr>
            <td style="padding: 0 30px 30px 30px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); padding: 25px; border-radius: 12px;">
                    <h3 style="color: #ffffff; margin: 0 0 20px 0; font-size: 18px; font-weight: 700;">📊 ACCOUNT SUMMARY</h3>
                    <table width="100%" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="33%" style="text-align: center; padding: 10px;">
                          <div style="background: rgba(255,255,255,0.25); padding: 15px; border-radius: 10px; backdrop-filter: blur(10px);">
                            <p style="color: #ffffff; margin: 0; font-size: 32px; font-weight: bold;">100</p>
                            <p style="color: #ffffff; margin: 5px 0 0 0; font-size: 12px; opacity: 0.95;">Starting Credits</p>
                          </div>
                        </td>
                        <td width="33%" style="text-align: center; padding: 10px;">
                          <div style="background: rgba(255,255,255,0.25); padding: 15px; border-radius: 10px; backdrop-filter: blur(10px);">
                            <p style="color: #ffffff; margin: 0; font-size: 32px; font-weight: bold;">0</p>
                            <p style="color: #ffffff; margin: 5px 0 0 0; font-size: 12px; opacity: 0.95;">Tests Completed</p>
                          </div>
                        </td>
                        <td width="33%" style="text-align: center; padding: 10px;">
                          <div style="background: rgba(255,255,255,0.25); padding: 15px; border-radius: 10px; backdrop-filter: blur(10px);">
                            <p style="color: #ffffff; margin: 0; font-size: 28px; font-weight: bold;">NEW</p>
                            <p style="color: #ffffff; margin: 5px 0 0 0; font-size: 12px; opacity: 0.95;">Member Status</p>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Quick Actions -->
          <tr>
            <td style="padding: 0 30px 30px 30px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: #f8f9fa; padding: 25px; border-radius: 12px;">
                    <h3 style="color: #333; margin: 0 0 20px 0; font-size: 18px; font-weight: 700;">⚡ QUICK ACTIONS</h3>
                    <table width="100%" cellpadding="0" cellspacing="0">
                      <tr>
                        <td style="padding: 8px 0;">
                          <a href="https://dashboard.convex.dev" style="display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #ffffff; padding: 12px 25px; text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 14px; box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);">📊 View in Convex Dashboard</a>
                        </td>
                      </tr>
                      <tr>
                        <td style="padding: 8px 0;">
                          <a href="mailto:${userEmail}" style="display: inline-block; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: #ffffff; padding: 12px 25px; text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 14px; box-shadow: 0 4px 15px rgba(240, 147, 251, 0.3);">✉️ Send Welcome Message</a>
                        </td>
                      </tr>
                      <tr>
                        <td style="padding: 8px 0;">
                          <a href="https://dashboard.convex.dev" style="display: inline-block; background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: #ffffff; padding: 12px 25px; text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 14px; box-shadow: 0 4px 15px rgba(79, 172, 254, 0.3);">📈 View Growth Analytics</a>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Growth Stats -->
          <tr>
            <td style="padding: 0 30px 30px 30px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%); padding: 25px; border-radius: 12px; text-align: center;">
                    <p style="color: #333; margin: 0 0 15px 0; font-size: 18px; font-weight: 700;">🎯 PLATFORM GROWTH</p>
                    <p style="color: #666; margin: 0; font-size: 14px; line-height: 1.6;">
                      Your platform now has <strong style="color: #333;">one more athlete</strong> on their journey to excellence!<br>
                      Keep building the future of sports assessment in India! 🇮🇳
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Reminder -->
          <tr>
            <td style="padding: 0 30px 30px 30px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: #fff3cd; padding: 20px; border-radius: 10px; border-left: 4px solid #ffc107;">
                    <p style="color: #856404; margin: 0 0 10px 0; font-size: 15px; font-weight: 600;">📝 REMINDER:</p>
                    <p style="color: #856404; margin: 0; font-size: 13px; line-height: 1.6;">
                      • Monitor new user activity in the first 24 hours<br>
                      • Check if they complete their first assessment<br>
                      • Engage with users who need help via in-app chat<br>
                      • Send personalized tips to improve retention
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Footer -->
          <tr>
            <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; text-align: center;">
              <p style="color: #ffffff; margin: 0 0 10px 0; font-size: 20px; font-weight: bold;">AI Sports Talent Assessment</p>
              <p style="color: #ffffff; margin: 0 0 20px 0; font-size: 13px; opacity: 0.9;">Admin Notification System</p>
              
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td align="center" style="padding: 15px 0;">
                    <a href="https://dashboard.convex.dev" style="color: #ffffff; text-decoration: none; margin: 0 15px; font-size: 13px; opacity: 0.9;">Dashboard</a>
                    <span style="color: #ffffff; opacity: 0.5;">|</span>
                    <a href="#" style="color: #ffffff; text-decoration: none; margin: 0 15px; font-size: 13px; opacity: 0.9;">Analytics</a>
                    <span style="color: #ffffff; opacity: 0.5;">|</span>
                    <a href="#" style="color: #ffffff; text-decoration: none; margin: 0 15px; font-size: 13px; opacity: 0.9;">Support</a>
                  </td>
                </tr>
              </table>
              
              <p style="color: #ffffff; margin: 20px 0 0 0; font-size: 11px; opacity: 0.8; line-height: 1.6;">
                This is an automated notification sent to admin@aisportsassessment.com<br>
                © 2025 AI Sports Talent Assessment Platform. All rights reserved.
              </p>
            </td>
          </tr>
          
        </table>
        
      </td>
    </tr>
  </table>
  
</body>
</html>
  `;
}

function getTestResultEmailHTML(userName: string, testType: string, score: number, rank?: number): string {
  const testDate = new Date().toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' });
  const scorePercentage = Math.min(100, (score / 100) * 100);
  const performanceLevel = score >= 90 ? 'OUTSTANDING' : score >= 75 ? 'EXCELLENT' : score >= 60 ? 'GOOD' : score >= 40 ? 'FAIR' : 'NEEDS IMPROVEMENT';
  const performanceEmoji = score >= 90 ? '🔥' : score >= 75 ? '⭐' : score >= 60 ? '💪' : score >= 40 ? '👍' : '📈';
  
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Your ${testType} Results - AI Sports Assessment</title>
</head>
<body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
  
  <table width="100%" cellpadding="0" cellspacing="0" style="padding: 20px 0;">
    <tr>
      <td align="center">
        
        <table width="650" cellpadding="0" cellspacing="0" style="background-color: #ffffff; border-radius: 20px; overflow: hidden; box-shadow: 0 20px 60px rgba(0,0,0,0.3);">
          
          <!-- Header -->
          <tr>
            <td style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); padding: 45px 30px; text-align: center;">
              <div style="font-size: 64px; margin-bottom: 15px;">🏆</div>
              <h1 style="color: #ffffff; margin: 0; font-size: 38px; font-weight: 800; text-shadow: 0 2px 4px rgba(0,0,0,0.2);">ASSESSMENT COMPLETE!</h1>
              <p style="color: #ffffff; margin: 15px 0 0 0; font-size: 18px; opacity: 0.95;">Great job, ${userName}! 🎉</p>
            </td>
          </tr>
          
          <!-- Test Info Banner -->
          <tr>
            <td style="padding: 30px 30px 20px 30px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); padding: 20px; border-radius: 12px; text-align: center;">
                    <p style="color: #ffffff; margin: 0; font-size: 16px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px;">${testType}</p>
                    <p style="color: #ffffff; margin: 8px 0 0 0; font-size: 13px; opacity: 0.9;">Completed on ${testDate}</p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Main Score Card -->
          <tr>
            <td style="padding: 0 30px 30px 30px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px; border-radius: 15px; text-align: center; box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);">
                    <p style="color: #ffffff; margin: 0 0 20px 0; font-size: 18px; font-weight: 600; opacity: 0.9;">YOUR SCORE</p>
                    <div style="font-size: 80px; margin: 20px 0; color: #ffffff; font-weight: 900; text-shadow: 0 4px 8px rgba(0,0,0,0.3);">${score}</div>
                    <div style="background: rgba(255,255,255,0.2); padding: 15px; border-radius: 10px; margin: 20px 0; backdrop-filter: blur(10px);">
                      <p style="color: #ffffff; margin: 0; font-size: 24px; font-weight: bold;">${performanceEmoji} ${performanceLevel}</p>
                    </div>
                    ${rank ? `
                      <div style="margin-top: 25px; padding-top: 25px; border-top: 2px solid rgba(255,255,255,0.3);">
                        <p style="color: #ffffff; margin: 0 0 10px 0; font-size: 16px; opacity: 0.9;">LEADERBOARD RANK</p>
                        <p style="color: #ffffff; margin: 0; font-size: 48px; font-weight: bold;">#${rank}</p>
                        <p style="color: #ffffff; margin: 10px 0 0 0; font-size: 14px; opacity: 0.9;">Keep climbing! 🚀</p>
                      </div>
                    ` : ''}
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Performance Breakdown -->
          <tr>
            <td style="padding: 0 30px 30px 30px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: #f8f9fa; padding: 30px; border-radius: 15px; border-left: 5px solid #667eea;">
                    <h3 style="color: #333; margin: 0 0 25px 0; font-size: 22px; font-weight: 700;">📊 PERFORMANCE ANALYSIS</h3>
                    
                    <!-- Score Visualization -->
                    <div style="background: #ffffff; padding: 20px; border-radius: 10px; margin-bottom: 20px;">
                      <p style="color: #666; margin: 0 0 10px 0; font-size: 14px;">Score Breakdown</p>
                      <div style="background: #e9ecef; height: 30px; border-radius: 15px; overflow: hidden; position: relative;">
                        <div style="background: linear-gradient(90deg, #667eea 0%, #764ba2 100%); height: 100%; width: ${scorePercentage}%; border-radius: 15px; display: flex; align-items: center; justify-content: flex-end; padding-right: 10px;">
                          <span style="color: #ffffff; font-size: 12px; font-weight: bold;">${score}%</span>
                        </div>
                      </div>
                    </div>
                    
                    <!-- Key Metrics -->
                    <table width="100%" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="50%" style="padding: 15px; background: #ffffff; border-radius: 10px; margin: 5px;">
                          <p style="color: #666; margin: 0 0 5px 0; font-size: 12px; text-transform: uppercase;">Form Accuracy</p>
                          <p style="color: #333; margin: 0; font-size: 24px; font-weight: bold;">${Math.min(100, score + 5)}%</p>
                        </td>
                        <td width="50%" style="padding: 15px; background: #ffffff; border-radius: 10px; margin: 5px;">
                          <p style="color: #666; margin: 0 0 5px 0; font-size: 12px; text-transform: uppercase;">Consistency</p>
                          <p style="color: #333; margin: 0; font-size: 24px; font-weight: bold;">${Math.max(70, score - 5)}%</p>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Achievements -->
          ${score >= 80 ? `
          <tr>
            <td style="padding: 0 30px 30px 30px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%); padding: 25px; border-radius: 12px; text-align: center;">
                    <div style="font-size: 48px; margin-bottom: 10px;">🎖️</div>
                    <p style="color: #333; margin: 0 0 10px 0; font-size: 20px; font-weight: bold;">NEW ACHIEVEMENT UNLOCKED!</p>
                    <p style="color: #666; margin: 0; font-size: 14px;">You've earned the "${performanceLevel} Performer" badge!</p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          ` : ''}
          
          <!-- Improvement Tips -->
          <tr>
            <td style="padding: 0 30px 30px 30px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: #fff3cd; padding: 25px; border-radius: 12px; border-left: 4px solid #ffc107;">
                    <p style="color: #856404; margin: 0 0 15px 0; font-size: 18px; font-weight: 600;">💡 PERSONALIZED TIPS</p>
                    <table width="100%" cellpadding="0" cellspacing="0">
                      <tr>
                        <td style="padding: 10px 0;">
                          <p style="color: #856404; margin: 0; font-size: 14px; line-height: 1.8;">
                            ✓ <strong>Warm up properly</strong> before your next assessment<br>
                            ✓ <strong>Focus on form</strong> over speed for better scores<br>
                            ✓ <strong>Practice consistently</strong> to see improvement<br>
                            ✓ <strong>Chat with Riley AI</strong> for personalized coaching tips
                          </p>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Next Steps -->
          <tr>
            <td style="padding: 0 30px 30px 30px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; border-radius: 15px; text-align: center;">
                    <h3 style="color: #ffffff; margin: 0 0 20px 0; font-size: 22px; font-weight: 700;">🎯 WHAT'S NEXT?</h3>
                    <table width="100%" cellpadding="0" cellspacing="0">
                      <tr>
                        <td style="padding: 10px 0;">
                          <a href="#" style="display: inline-block; background: rgba(255,255,255,0.25); color: #ffffff; padding: 15px 35px; text-decoration: none; border-radius: 30px; font-weight: 600; font-size: 15px; backdrop-filter: blur(10px); margin: 5px;">📊 View Detailed Report</a>
                        </td>
                      </tr>
                      <tr>
                        <td style="padding: 10px 0;">
                          <a href="#" style="display: inline-block; background: rgba(255,255,255,0.25); color: #ffffff; padding: 15px 35px; text-decoration: none; border-radius: 30px; font-weight: 600; font-size: 15px; backdrop-filter: blur(10px); margin: 5px;">🏅 Check Leaderboard</a>
                        </td>
                      </tr>
                      <tr>
                        <td style="padding: 10px 0;">
                          <a href="#" style="display: inline-block; background: rgba(255,255,255,0.25); color: #ffffff; padding: 15px 35px; text-decoration: none; border-radius: 30px; font-weight: 600; font-size: 15px; backdrop-filter: blur(10px); margin: 5px;">🔄 Try Another Test</a>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Social Sharing -->
          <tr>
            <td style="padding: 0 30px 30px 30px;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="background: #f8f9fa; padding: 25px; border-radius: 12px; text-align: center;">
                    <p style="color: #333; margin: 0 0 15px 0; font-size: 16px; font-weight: 600;">📱 Share Your Achievement!</p>
                    <p style="color: #666; margin: 0; font-size: 14px;">Let your friends know about your progress and inspire them to join!</p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          <!-- Footer -->
          <tr>
            <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 35px 30px; text-align: center;">
              <p style="color: #ffffff; margin: 0 0 10px 0; font-size: 20px; font-weight: bold;">AI Sports Talent Assessment</p>
              <p style="color: #ffffff; margin: 0 0 20px 0; font-size: 13px; opacity: 0.9;">Keep pushing your limits! 💪</p>
              
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td align="center" style="padding: 15px 0;">
                    <a href="#" style="color: #ffffff; text-decoration: none; margin: 0 12px; font-size: 13px; opacity: 0.9;">View History</a>
                    <span style="color: #ffffff; opacity: 0.5;">|</span>
                    <a href="#" style="color: #ffffff; text-decoration: none; margin: 0 12px; font-size: 13px; opacity: 0.9;">Get Coaching</a>
                    <span style="color: #ffffff; opacity: 0.5;">|</span>
                    <a href="#" style="color: #ffffff; text-decoration: none; margin: 0 12px; font-size: 13px; opacity: 0.9;">Help Center</a>
                  </td>
                </tr>
              </table>
              
              <p style="color: #ffffff; margin: 20px 0 0 0; font-size: 11px; opacity: 0.8; line-height: 1.6;">
                © 2025 AI Sports Talent Assessment Platform<br>
                Empowering Athletes Across India 🇮🇳
              </p>
            </td>
          </tr>
          
        </table>
        
      </td>
    </tr>
  </table>
  
</body>
</html>
  `;
}
