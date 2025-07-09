import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";
import "package:gap/gap.dart";
import "package:intl/intl.dart";
import "package:x_obese/src/widgets/back_button.dart";

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 5,
                ),
                child: Row(
                  children: [
                    getBackButton(context, () {
                      Navigator.pop(context);
                    }),
                    const Gap(10),
                    const Text(
                      "Terms and Conditions",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Html(
                    data: """
<!DOCTYPE html>
<html>
<head>
    <title>Terms and Conditions</title>
</head>
<body>

<h3>Terms and Conditions for </h3>
<h1>X Obese</h1>

<p><strong>Last Updated: ${DateFormat('yyyy-MM-dd').format(DateTime(2025, 5, 1))}</strong></p>

<p>Please read these Terms and Conditions carefully before using the X Obese mobile application operated by Impala Intech.</p>

<p>Your access to and use of the Service is conditioned upon your acceptance of and compliance with these Terms. These Terms apply to all visitors, users, and others who wish to access or use the Service.</p>

<p>By accessing or using the Service you agree to be bound by these Terms. If you disagree with any part of the terms then you do not have permission to access the Service.</p>

<h2>1. Accounts</h2>
<p>When you create an account with us, you guarantee that the information you provide us (Name, Birth Date, Height, Weight, Address, Profile Image) is accurate, complete, and current at all times. Inaccurate, incomplete, or obsolete information may result in the immediate termination of your account on the Service.</p>
<p>You are responsible for maintaining the confidentiality of your account and password, including but not limited to the restriction of access to your device and/or account. You agree to accept responsibility for any and all activities or actions that occur under your account and/or password. You must notify us immediately upon becoming aware of any breach of security or unauthorized use of your account.</p>

<h2>2. Use of the Service</h2>
<p>The Service allows you to create personalized workout plans and participate in virtual or on-site marathon programs arranged by us. For virtual events (Walking, Running, Cycling), you will use the app to record and submit your activity.</p>

<h2>3. Health Disclaimer</h2>
<p><strong>IMPORTANT:</strong> The Service offers health, fitness and nutritional information and is designed for educational purposes only. You should not rely on this information as a substitute for, nor does it replace, professional medical advice, diagnosis, or treatment. If you have any concerns or questions about your health, you should always consult with a physician or other health-care professional.</p>
<p>Do not disregard, avoid or delay obtaining medical or health related advice from your health-care professional because of something you may have read or tracked on the Service. The use of any information provided on the Service is solely at your own risk.</p>
<p>Physical activity involves risks. You should consult your doctor before starting any new fitness program or participating in any events (virtual or on-site) offered through the Service. You assume full responsibility for any risks, injuries, or damages, known or unknown, which you might incur as a result of using the Service or participating in events.</p>

<h2>4. Marathon Programs</h2>
<p>Participation in marathon programs (virtual or on-site) is subject to specific rules and requirements which may be communicated separately for each event. By participating, you agree to abide by these rules.</p>
<p>For virtual events, you are responsible for accurately recording and submitting your activity data (walking, running, cycling). We reserve the right to verify data and disqualify participants found to be submitting inaccurate or fraudulent data.</p>
<p>For on-site events, you acknowledge the inherent risks associated with participating in a physical event and agree to follow all safety instructions provided by event organizers. Additional waivers may be required for on-site events.</p>

<h2>5. Health Blog</h2>
<p>The Service includes a health-related blog section. Content published in the blog is for informational purposes only and does not constitute medical advice. Refer to the Health Disclaimer in Section 3.</p>

<h2>6. Intellectual Property</h2>
<p>The Service and its original content (excluding Content provided by users), features and functionality are and will remain the exclusive property of Impala Intech and its licensors. The Service is protected by copyright, trademark, and other laws of both [Governing Law Jurisdiction] and foreign countries.</p>

<h2>7. User Conduct</h2>
<p>You agree not to use the Service:</p>
<ul>
    <li>In any way that violates any applicable national or international law or regulation.</li>
    <li>To exploit, harm, or attempt to exploit or harm minors in any way.</li>
    <li>To transmit, or procure the sending of, any advertising or promotional material, including any "junk mail," "chain letter," "spam," or any other similar solicitation.</li>
    <li>To impersonate or attempt to impersonate Impala Intech, an employee, another user, or any other person or entity.</li>
    <li>To engage in any other conduct that restricts or inhibits anyone's use or enjoyment of the Service, or which, as determined by us, may harm us or users of the Service or expose them to liability.</li>
    <li>To interfere with the proper working of the Service, including introducing viruses or attempting unauthorized access.</li>
</ul>

<h2>8. Termination</h2>
<p>We may terminate or suspend your account and bar access to the Service immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever and without limitation, including but not limited to a breach of the Terms.</p>
<p>If you wish to terminate your account, you may simply discontinue using the Service or contact us to request deletion.</p>

<h2>9. Limitation Of Liability</h2>
<p>In no event shall Impala Intech, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from (i) your access to or use of or inability to access or use the Service; (ii) any conduct or content of any third party on the Service; (iii) any content obtained from the Service; and (iv) unauthorized access, use or alteration of your transmissions or content, whether based on warranty, contract, tort (including negligence) or any other legal theory, whether or not we have been informed of the possibility of such damage, and even if a remedy set forth herein is found to have failed of its essential purpose.</p>

<h2>10. Disclaimer</h2>
<p>Your use of the Service is at your sole risk. The Service is provided on an "AS IS" and "AS AVAILABLE" basis. The Service is provided without warranties of any kind, whether express or implied, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose, non-infringement or course of performance.</p>
<p>Impala Intech its subsidiaries, affiliates, and its licensors do not warrant that a) the Service will function uninterrupted, secure or available at any particular time or location; b) any errors or defects will be corrected; c) the Service is free of viruses or other harmful components; or d) the results of using the Service will meet your requirements.</p>

<h2>11. Governing Law</h2>
<p>These Terms shall be governed and construed in accordance with the laws of [Governing Law Jurisdiction], without regard to its conflict of law provisions.</p>

<h2>12. Changes</h2>
<p>We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material we will provide at least 30 days notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.</p>
<p>By continuing to access or use our Service after any revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, you are no longer authorized to use the Service.</p>

<h2>13. Contact Us</h2>
<p>If you have any questions about this Privacy Policy, please contact us:</p>
<p>By email: info@impalaintech.com</p>
<p>By mail: partnership@impalaintech.com</p>
</body>
</html>
                """,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
