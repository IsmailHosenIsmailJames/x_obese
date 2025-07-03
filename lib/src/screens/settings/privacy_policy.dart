import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";
import "package:x_obese/src/widgets/back_button.dart";

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
                      Get.back();
                    }),
                    const Gap(10),
                    const Text(
                      "Privacy Policy",
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
                    <title>Privacy Policy</title>
                </head>
                <body>
                
                <h3>Privacy Policy for</h3>
                <h1>X Obese</h1>
                
                <p><strong>Last Updated: ${DateFormat('yyyy-MM-dd').format(DateTime(2025, 5, 1))}</strong></p>
                
                <p>Impala Intech operates the X Obese mobile application.</p>
                
                <p>This page informs you of our policies regarding the collection, use, and disclosure of personal data when you use our Service and the choices you have associated with that data.</p>
                
                <p>We use your data to provide and improve the Service. By using the Service, you agree to the collection and use of information in accordance with this policy. Unless otherwise defined in this Privacy Policy, terms used in this Privacy Policy have the same meanings as in our Terms and Conditions.</p>
                
                <h2>1. Information Collection And Use</h2>
                <p>We collect several different types of information for various purposes to provide and improve our Service to you.</p>
                
                <h3>Types of Data Collected</h3>
                <ul>
                    <li>
                        <strong>Personal Data:</strong> While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you ("Personal Data"). Personally identifiable information may include, but is not limited to:
                        <ul>
                            <li>Email address (if used for login/recovery, otherwise clarify login method)</li>
                            <li>First name and last name</li>
                            <li>Date of Birth</li>
                            <li>Height</li>
                            <li>Weight</li>
                            <li>Address</li>
                            <li>Profile Image (optional or required)</li>
                        </ul>
                    </li>
                    <li>
                        <strong>Health and Activity Data:</strong>
                        <ul>
                            <li>Workout data you create or log (exercises, duration, sets, reps, etc.).</li>
                            <li>Activity data collected for virtual events (steps, distance, duration for walking, running, cycling). This may be manually entered or collected via device sensors with your permission.</li>
                            <li>Data derived from your inputs (e.g., estimated calorie burn based on weight/activity).</li>
                        </ul>
                    </li>
                    <li>
                        <strong>Usage Data:</strong> We may also collect information that your device sends whenever you visit our Service or when you access the Service by or through a mobile device ("Usage Data"). This Usage Data may include information such as your device's Internet Protocol address (e.g. IP address), device type, operating system version, the features of our Service that you visit, the time and date of your visit, the time spent on those features, unique device identifiers and other diagnostic data.
                    </li>
                    <li>
                        <strong>Tracking & Cookies Data (If applicable):</strong> Specify if you use cookies or similar tracking technologies. For a mobile app, this might be less relevant unless using web views or specific SDKs. Often device identifiers are used instead. *[Adjust this section based on your actual implementation]*
                    </li>
                </ul>
                
                <h2>2. Use of Data</h2>
                <p>Impala Intech uses the collected data for various purposes:</p>
                <ul>
                    <li>To provide and maintain our Service</li>
                    <li>To manage your account and provide user support</li>
                    <li>To enable your participation in workout creation and marathon programs (virtual and on-site)</li>
                    <li>To track and verify participation in virtual events</li>
                    <li>To personalize your experience within the app</li>
                    <li>To provide you with news, special offers and general information about other goods, services and events which we offer that are similar to those that you have already purchased or enquired about unless you have opted not to receive such information (if applicable)</li>
                    <li>To publish health-related blog content (Note: Your personal data is not typically published here, but aggregated/anonymized data might inform topics)</li>
                    <li>To monitor the usage of our Service</li>
                    <li>To detect, prevent and address technical issues and security threats</li>
                    <li>To fulfill legal obligations</li>
                </ul>
                
                <h2>3. Data Storage and Transfer</h2>
                <p>Your information, including Personal Data, may be transferred to — and maintained on — computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from your jurisdiction.</p>
                <p>If you are located outside Bangladesh and choose to provide information to us, please note that we transfer the data, including Personal Data, to [Your Company's Country] and process it there.</p>
                <p>Your consent to this Privacy Policy followed by your submission of such information represents your agreement to that transfer.</p>
                <p>Impala Intech will take all steps reasonably necessary to ensure that your data is treated securely and in accordance with this Privacy Policy and no transfer of your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of your data and other personal information.</p>
                
                <h2>4. Disclosure Of Data</h2>
                <p>We may disclose your Personal Data in the good faith belief that such action is necessary to:</p>
                <ul>
                    <li>To comply with a legal obligation</li>
                    <li>To protect and defend the rights or property of Impala Intech</li>
                    <li>To prevent or investigate possible wrongdoing in connection with the Service</li>
                    <li>To protect the personal safety of users of the Service or the public</li>
                    <li>To protect against legal liability</li>
                    <li>With Service Providers: We may share your data with third-party companies and individuals to facilitate our Service ("Service Providers"), provide the Service on our behalf, perform Service-related services or assist us in analyzing how our Service is used. These third parties have access to your Personal Data only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose. *[List types of service providers if known, e.g., cloud hosting, analytics]*</li>
                    <li>Business Transfers: If we are involved in a merger, acquisition or asset sale, your Personal Data may be transferred.</li>
                </ul>
                <p>We will not sell your Personal Data.</p>
                
                <h2>5. Security Of Data</h2>
                <p>The security of your data is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data (such as encryption, access controls, etc.), we cannot guarantee its absolute security.</p>
                
                <h2>6. Your Data Protection Rights</h2>
                <p>Depending on your location, you may have the following data protection rights:</p>
                <ul>
                    <li>The right to access, update or delete the information we have on you.</li>
                    <li>The right of rectification.</li>
                    <li>The right to object.</li>
                    <li>The right of restriction.</li>
                    <li>The right to data portability.</li>
                    <li>The right to withdraw consent.</li>
                </ul>
                <p>You can usually exercise these rights directly within your account settings section. If you are unable to perform these actions yourself, please contact us to assist you. Please note that we may ask you to verify your identity before responding to such requests.</p>
                
                <h2>7. Children's Privacy</h2>
                <p>Our Service does not address anyone under the age of [Specify Age - e.g., 13 or 16 depending on regulations like COPPA/GDPR].</p>
                <p>We do not knowingly collect personally identifiable information from anyone under the specified age. If you are a parent or guardian and you are aware that your child has provided us with Personal Data, please contact us. If we become aware that we have collected Personal Data from children without verification of parental consent, we take steps to remove that information from our servers.</p>
                
                <h2>8. Changes To This Privacy Policy</h2>
                <p>We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date.</p>
                <p>You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.</p>
                
                <h2>9. Contact Us</h2>
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
