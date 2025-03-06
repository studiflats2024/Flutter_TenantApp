import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/utils/size_manager.dart';

//ignore: must_be_immutable
class ClubTerms extends BaseStatelessWidget {
  ClubTerms({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Terms and Conditions",
        multiLan: false,
        withBackButton: true,
        onBack: (){
          Navigator.pop(context);
        },
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(SizeManager.sizeSp16),
          child: const Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '1. Membership & Eligibility\n\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text:
                        '1.1 Membership is open exclusively to tenants who have an interest in German culture, language, and community activities.\n\n 1.2 All members must register through the club’s official app to complete their membership.\n\n 1.3 Access to the club is strictly limited to registered members. Visitors or non-members are not permitted on the premises under any circumstances.\n\n 1.4 Membership fees must be paid on time to maintain active status. \n\n 1.5 The club management reserves the right to terminate membership for violations of these terms.\n\n',
                    style: TextStyle(
                      color: Color(0xFF363636),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: '2. Conduct & Behavior\n\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),

                  TextSpan(
                    text:
                        '2.1 Members must show respect to all individuals, regardless of differences in opinion, background, or German proficiency. Disruptive, discriminatory, or disrespectful behavior will not be tolerated.\n\n 2.2 Conflicts between members should be resolved amicably. If necessary, the executive committee will mediate disputes.\n\n 2.3 Members must ensure that noise levels remain within permitted limits to maintain a comfortable environment. \n\n 2.4 Club staff have the authority to adjust or lower the volume of any electronic devices to prevent disturbances. \n\n',
                    style: TextStyle(
                      color: Color(0xFF363636),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),

                  TextSpan(
                    text: '3. Use of Club Facilities & Property\n\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text:
                        '3.1 Club property, materials, and resources must be used responsibly to maintain a clean and safe environment. \n\n 3.2 Club equipment, games, and other property must remain within the premises and may not be removed under any circumstances. \n\n 3.3 After use, all items must be returned to their designated places in proper condition. \n\n 3.4 Members are responsible for ensuring that club property is handled with care. Any damages caused by a member must be reported immediately, and the member may be held financially responsible for repairs. \n\n 3.5 Bringing food and beverages into the club is not allowed.\n\n',
                    style: TextStyle(
                      color: Color(0xFF363636),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: '4. Language Policy \n\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),

                  TextSpan(
                    text:
                        '4.1 Members are encouraged to speak in German during designated practice sessions to enhance language proficiency.\n\n',
                    style: TextStyle(
                      color: Color(0xFF363636),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: '5. Liability & Personal Belongings\n\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),

                  TextSpan(
                    text:
                        '5.1 Members are responsible for their personal belongings brought to the club premises or events. \n\n 5.2 The club is not liable for lost, stolen, or damaged personal items.\n\n',
                    style: TextStyle(
                      color: Color(0xFF363636),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: '6. Club Opening Hours\n\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),

                  TextSpan(
                    text: '6.1 The club operates during the following hours:\n\n',
                    style: TextStyle(
                      color: Color(0xFF363636),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: 'Monday to Friday: ',
                    style: TextStyle(
                      color: Color(0xFF363636),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: '  10:00 AM - 8:00 PM\n\n',
                    style: TextStyle(
                      color: Color(0xFF363636),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: 'Saturday: ',
                    style: TextStyle(
                      color: Color(0xFF363636),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: '  10:00 AM - 11:00 PM\n\n',
                    style: TextStyle(
                      color: Color(0xFF363636),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: 'Sunday: ',
                    style: TextStyle(
                      color: Color(0xFF363636),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: 'Closed\n\n',
                    style: TextStyle(
                      color: Color(0xFF363636),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text:
                        '6.2 Club management reserves the right to modify opening hours as necessary.\n\n',
                    style: TextStyle(
                      color: Color(0xFF363636),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: '7. Enforcement & Policy Violations \n\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text:
                        '7.1 Failure to comply with these terms and conditions may result in appropriate action by club management, including warnings, temporary suspension, or membership termination. \n\n 7.2 The club reserves the right to update these terms and conditions at any time. Members will be notified of any changes.\n\n',
                    style: TextStyle(
                      color: Color(0xFF363636),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text:
                        'These terms and conditions are in place to ensure a safe, enjoyable, and respectful environment for all members. By registering as a member, you agree to abide by these rules.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
