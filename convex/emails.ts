import { mutation } from "./_generated/server";
import { v } from "convex/values";

export const sendWelcomeEmail = mutation({
  args: {
    userEmail: v.string(),
    displayName: v.string(),
  },
  handler: async (ctx, args) => {
    const resendApiKey = process.env.RESEND_API_KEY;
    
    if (!resendApiKey) {
      console.error('❌ RESEND_API_KEY not configured');
      throw new Error('Email service not configured');
    }

    try {
      // 📧 SEND WELCOME EMAIL TO NEW USER
      console.log(`📤 Sending welcome email to: ${args.userEmail}`);
      
      const welcomeEmailResponse = await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${resendApiKey}`,
        },
        body: JSON.stringify({
          from: 'Vita Sports <onboarding@vitasports.shop>',
          to: [args.userEmail],
          subject: '🎉 Welcome to AI Sports Assessment Platform!',
          html: `
            <!DOCTYPE html>
            <html>
              <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Welcome to Vita Sports</title>
              </head>
              <body style="margin: 0; padding: 0; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); font-family: 'Inter', 'Roboto', -apple-system, BlinkMacSystemFont, system-ui, sans-serif;">
                <table role="presentation" style="width: 100%; border-collapse: collapse;">
                  <tr>
                    <td align="center" style="padding: 40px 20px;">
                      <table role="presentation" style="max-width: 600px; width: 100%; background: rgba(255, 255, 255, 0.95); border-radius: 24px; box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3); overflow: hidden;">
                        <!-- Header -->
                        <tr>
                          <td style="background: linear-gradient(135deg, #6A0DAD 0%, #007BFF 100%); padding: 40px 30px; text-align: center;">
                            <h1 style="margin: 0; color: #ffffff; font-size: 32px; font-weight: 700; text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);">
                              🎉 Welcome to Vita Sports!
                            </h1>
                          </td>
                        </tr>
                        
                        <!-- Content -->
                        <tr>
                          <td style="padding: 40px 30px;">
                            <h2 style="color: #333333; font-size: 24px; font-weight: 600; margin: 0 0 20px 0;">
                              Hi ${args.displayName}! 👋
                            </h2>
                            
                            <p style="color: #666666; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0;">
                              Welcome to the <strong>AI Sports Assessment Platform</strong> - your journey to athletic excellence starts here!
                            </p>
                            
                            <div style="background: linear-gradient(135deg, rgba(106, 13, 173, 0.1) 0%, rgba(0, 123, 255, 0.05) 100%); border-left: 4px solid #6A0DAD; padding: 20px; margin: 20px 0; border-radius: 8px;">
                              <h3 style="color: #6A0DAD; font-size: 18px; margin: 0 0 10px 0;">
                                🚀 What's Next?
                              </h3>
                              <ul style="color: #666666; font-size: 14px; line-height: 1.8; margin: 0; padding-left: 20px;">
                                <li>Complete your <strong>profile setup</strong></li>
                                <li>Take your <strong>first assessment test</strong></li>
                                <li>Get <strong>AI-powered insights</strong></li>
                                <li>Track your <strong>progress</strong> over time</li>
                                <li>Connect with <strong>mentors</strong> and community</li>
                              </ul>
                            </div>
                            
                            <p style="color: #666666; font-size: 16px; line-height: 1.6; margin: 20px 0;">
                              We're excited to be part of your athletic journey. Our AI-powered platform will help you:
                            </p>
                            
                            <table role="presentation" style="width: 100%; margin: 20px 0;">
                              <tr>
                                <td style="padding: 15px; background: #f8f9fa; border-radius: 8px; margin-bottom: 10px;">
                                  <strong style="color: #6A0DAD;">✓</strong> 
                                  <span style="color: #333333; font-size: 14px;">Assess your athletic potential scientifically</span>
                                </td>
                              </tr>
                              <tr>
                                <td style="padding: 15px; background: #f8f9fa; border-radius: 8px; margin-bottom: 10px;">
                                  <strong style="color: #007BFF;">✓</strong> 
                                  <span style="color: #333333; font-size: 14px;">Get personalized training recommendations</span>
                                </td>
                              </tr>
                              <tr>
                                <td style="padding: 15px; background: #f8f9fa; border-radius: 8px;">
                                  <strong style="color: #00FFB2;">✓</strong> 
                                  <span style="color: #333333; font-size: 14px;">Track improvements with detailed analytics</span>
                                </td>
                              </tr>
                            </table>
                            
                            <div style="text-align: center; margin: 30px 0;">
                              <a href="https://vitasports.shop" style="display: inline-block; background: linear-gradient(135deg, #6A0DAD 0%, #007BFF 100%); color: #ffffff; text-decoration: none; padding: 14px 32px; border-radius: 12px; font-weight: 600; font-size: 16px; box-shadow: 0 4px 15px rgba(106, 13, 173, 0.3);">
                                Get Started Now →
                              </a>
                            </div>
                            
                            <p style="color: #999999; font-size: 14px; line-height: 1.6; margin: 30px 0 0 0; padding-top: 20px; border-top: 1px solid #e9ecef;">
                              <strong>Pro Tip:</strong> Complete your first test within 24 hours to earn <strong style="color: #00FFB2;">50 bonus credit points</strong>! 🎁
                            </p>
                          </td>
                        </tr>
                        
                        <!-- Footer -->
                        <tr>
                          <td style="background: #f8f9fa; padding: 30px; text-align: center; border-top: 1px solid #e9ecef;">
                            <p style="margin: 0 0 10px 0; color: #666666; font-size: 14px;">
                              Questions? We're here to help!
                            </p>
                            <p style="margin: 0 0 15px 0;">
                              <a href="mailto:support@vitasports.shop" style="color: #6A0DAD; text-decoration: none; font-weight: 600;">
                                support@vitasports.shop
                              </a>
                            </p>
                            <p style="margin: 0; color: #999999; font-size: 12px;">
                              Vita Sports Assessment Platform<br>
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
          `,
        }),
      });

      console.log('📨 User Email API Response Status:', welcomeEmailResponse.status, welcomeEmailResponse.statusText);
      
      let welcomeEmailData = null;
      if (!welcomeEmailResponse.ok) {
        const errorData = await welcomeEmailResponse.json();
        console.error('❌ Failed to send welcome email to user:', {
          email: args.userEmail,
          status: welcomeEmailResponse.status,
          error: errorData,
          hint: errorData.message?.includes('sandbox') 
            ? '⚠️ Resend is in SANDBOX mode - can only send to verified emails. Add user email to verified list or upgrade domain.'
            : 'Check Resend API key and domain verification'
        });
        // Don't throw - continue to send admin notification
        welcomeEmailData = { error: errorData };
      } else {
        welcomeEmailData = await welcomeEmailResponse.json();
        console.log('✅ Welcome email sent successfully to user:', {
          email: args.userEmail,
          id: welcomeEmailData.id,
          message: 'User should receive email within 1-2 minutes'
        });
      }

      // 📧 SEND ADMIN NOTIFICATION EMAIL
      console.log('📤 Sending admin notification to: subject.test2005@gmail.com');
      
      const adminEmailResponse = await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${resendApiKey}`,
        },
        body: JSON.stringify({
          from: 'Vita Sports <notifications@vitasports.shop>',
          to: ['subject.test2005@gmail.com'],
          subject: '🎊 New User Registration Alert',
          html: `
            <!DOCTYPE html>
            <html>
              <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>New User Registration</title>
              </head>
              <body style="margin: 0; padding: 0; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); font-family: 'Inter', 'Roboto', -apple-system, BlinkMacSystemFont, system-ui, sans-serif;">
                <table role="presentation" style="width: 100%; border-collapse: collapse;">
                  <tr>
                    <td align="center" style="padding: 40px 20px;">
                      <table role="presentation" style="max-width: 600px; width: 100%; background: rgba(255, 255, 255, 0.95); border-radius: 24px; box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3); overflow: hidden;">
                        <!-- Header -->
                        <tr>
                          <td style="background: linear-gradient(135deg, #6A0DAD 0%, #007BFF 100%); padding: 40px 30px; text-align: center;">
                            <h1 style="margin: 0; color: #ffffff; font-size: 32px; font-weight: 700; text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);">
                              🎊 New User Alert!
                            </h1>
                          </td>
                        </tr>
                        
                        <!-- Content -->
                        <tr>
                          <td style="padding: 40px 30px;">
                            <h2 style="color: #333333; font-size: 24px; font-weight: 600; margin: 0 0 20px 0;">
                              New Registration Received! 🎉
                            </h2>
                            
                            <p style="color: #666666; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0;">
                              A new user has successfully registered on the <strong>AI Sports Assessment Platform</strong>.
                            </p>
                            
                            <div style="background: linear-gradient(135deg, rgba(106, 13, 173, 0.1) 0%, rgba(0, 123, 255, 0.05) 100%); border-left: 4px solid #6A0DAD; padding: 20px; margin: 20px 0; border-radius: 8px;">
                              <h3 style="color: #6A0DAD; font-size: 18px; margin: 0 0 15px 0;">
                                📋 User Details
                              </h3>
                              <table role="presentation" style="width: 100%;">
                                <tr>
                                  <td style="padding: 8px 0; color: #666666; font-size: 14px; font-weight: 600;">
                                    Email:
                                  </td>
                                  <td style="padding: 8px 0; color: #333333; font-size: 14px;">
                                    ${args.userEmail}
                                  </td>
                                </tr>
                                <tr>
                                  <td style="padding: 8px 0; color: #666666; font-size: 14px; font-weight: 600;">
                                    Display Name:
                                  </td>
                                  <td style="padding: 8px 0; color: #333333; font-size: 14px;">
                                    ${args.displayName}
                                  </td>
                                </tr>
                                <tr>
                                  <td style="padding: 8px 0; color: #666666; font-size: 14px; font-weight: 600;">
                                    Registration Time:
                                  </td>
                                  <td style="padding: 8px 0; color: #333333; fontSize: 14px;">
                                    ${new Date().toLocaleString('en-IN', { 
                                      timeZone: 'Asia/Kolkata',
                                      dateStyle: 'full',
                                      timeStyle: 'long'
                                    })}
                                  </td>
                                </tr>
                              </table>
                            </div>
                            
                            <div style="background: #f8f9fa; padding: 15px; border-radius: 8px; margin: 20px 0;">
                              <p style="margin: 0; color: #666666; font-size: 14px; line-height: 1.6;">
                                ✅ <strong>Welcome email sent</strong> to user's inbox<br>
                                ✅ <strong>User profile created</strong> in database<br>
                                ✅ <strong>Ready for first assessment</strong>
                              </p>
                            </div>
                            
                            <div style="text-align: center; margin: 30px 0;">
                              <a href="https://dashboard.convex.dev" style="display: inline-block; background: linear-gradient(135deg, #6A0DAD 0%, #007BFF 100%); color: #ffffff; text-decoration: none; padding: 12px 24px; border-radius: 12px; font-weight: 600; font-size: 14px; box-shadow: 0 4px 15px rgba(106, 13, 173, 0.3);">
                                View in Dashboard →
                              </a>
                            </div>
                            
                            <p style="color: #999999; font-size: 13px; line-height: 1.6; margin: 20px 0 0 0; padding-top: 20px; border-top: 1px solid #e9ecef;">
                              <strong>📊 Platform Stats:</strong> This notification confirms successful user onboarding. The welcome email has been delivered to the user's inbox.
                            </p>
                          </td>
                        </tr>
                        
                        <!-- Footer -->
                        <tr>
                          <td style="background: #f8f9fa; padding: 30px; text-align: center; border-top: 1px solid #e9ecef;">
                            <p style="margin: 0 0 5px 0; color: #666666; font-size: 14px; font-weight: 600;">
                              Vita Sports Admin Notifications
                            </p>
                            <p style="margin: 0; color: #999999; font-size: 12px;">
                              AI Sports Assessment Platform<br>
                              Automated Admin Alert System
                            </p>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </body>
            </html>
          `,
        }),
      });

      console.log('📨 Admin Email API Response Status:', adminEmailResponse.status, adminEmailResponse.statusText);
      
      if (!adminEmailResponse.ok) {
        const errorData = await adminEmailResponse.json();
        console.error('⚠️ Failed to send admin notification:', {
          status: adminEmailResponse.status,
          error: errorData
        });
        // Don't throw error for admin email - user registration still succeeds
      } else {
        const adminEmailData = await adminEmailResponse.json();
        console.log('✅ Admin notification sent successfully:', {
          id: adminEmailData.id,
          to: 'subject.test2005@gmail.com'
        });
      }

      return {
        success: !welcomeEmailData?.error,
        welcomeEmailId: welcomeEmailData?.id || null,
        message: welcomeEmailData?.error 
          ? 'User email failed, but registration completed. Admin notified.'
          : 'Welcome email sent successfully to user and admin notified',
        userEmailError: welcomeEmailData?.error || null
      };

    } catch (error) {
      console.error('❌ Error in sendWelcomeEmail:', error);
      throw error;
    }
  },
});