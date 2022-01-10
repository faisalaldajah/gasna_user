// ignore_for_file: constant_identifier_names, use_key_in_widget_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gasna_user/brand_colors.dart';
import 'package:gasna_user/globalvariable.dart';
import 'package:gasna_user/screens/StartPage.dart';
import 'package:gasna_user/widgets/CustomizedTextField.dart';
import 'package:gasna_user/widgets/GradientButton.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreens extends StatefulWidget {
  static const String id = 'logins';
  @override
  _LoginScreensState createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  CountryCode countryCode;
  FirebaseAuth _auth = FirebaseAuth.instance;
  var fullNameController = TextEditingController();
  String verificationId;
  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential?.user != null) {
        DatabaseReference newUserRef = FirebaseDatabase.instance.reference();
        Map userMap = {
          'fullname': fullNameController.text,
          'phone': '$countryCode${checkNumber(phoneController.text)}',
        };
        newUserRef.child('users/${authCredential.user.uid}').set(userMap);
        Navigator.pushNamedAndRemoveUntil(
            context, StartPage.id, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      displayToastMessage(e.message, context);
    }
  }

  getMobileFormWidget(context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: 50.0,
                    image: AssetImage('images/gasna.png'),
                  ),
                  SizedBox(width: 15),
                  Text(
                    'غازنا',
                    style: TextStyle(
                      color: BrandColors.colorAccent,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 40),
            SvgPicture.asset(
              'images/undraw_access_account_re_8spm.svg',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            SizedBox(height: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomizedTextField(
                  controller: fullNameController,
                  hint: 'الاسم الكامل',
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: BrandColors.lightGrey.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CountryCodePicker(
                        dialogTextStyle: TextStyle(color: Colors.black),
                        dialogBackgroundColor: Colors.white,
                        barrierColor: Colors.grey[300],
                        textStyle: TextStyle(color: Colors.black),
                        initialSelection: 'JO',
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        favorite: ['+962', 'JO'],
                        showFlagMain: true,
                        onChanged: (value) {
                          countryCode = value;
                        },
                        onInit: (value) {
                          countryCode = value;
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                    Flexible(
                      child: CustomizedTextField(
                        controller: phoneController,
                        hint: 'رقم الهاتف',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                GradientButton(
                  onPressed: () async {
                    setState(() {
                      showLoading = true;
                    });

                    await _auth.verifyPhoneNumber(
                      phoneNumber:
                          '$countryCode${checkNumber(phoneController.text)}',
                      verificationCompleted: (phoneAuthCredential) async {
                        setState(() {
                          showLoading = false;
                        });
                      },
                      verificationFailed: (verificationFailed) async {
                        setState(() {
                          showLoading = false;
                        });
                        displayToastMessage(
                            verificationFailed.message, context);
                      },
                      codeSent: (verificationId, resendingToken) async {
                        setState(() {
                          showLoading = false;
                          currentState =
                              MobileVerificationState.SHOW_OTP_FORM_STATE;
                          this.verificationId = verificationId;
                        });
                      },
                      codeAutoRetrievalTimeout: (verificationId) async {},
                    );
                  },
                  title: "تأكيد",
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  getOtpFormWidget(context) {
    return ListView(
      children: [
        SizedBox(height: 50),
        CustomizedTextField(
          controller: otpController,
          hint: 'ادخل الرمز',
        ),
        const SizedBox(
          height: 20,
        ),
        GradientButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          title: "تأكيد",
        ),
        SizedBox(height: 80),
        SvgPicture.asset(
          'images/undraw_access_account_re_8spm.svg',
          width: MediaQuery.of(context).size.width * 0.7,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: showLoading
            ? Center(child: CircularProgressIndicator())
            : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                ? getMobileFormWidget(context)
                : getOtpFormWidget(context),
        padding: EdgeInsets.all(18),
      ),
    );
  }

  // ignore: missing_return
  String checkNumber(String phone) {
    if (phone.startsWith('0')) {
      displayToastMessage('احذف الصفر في بداية الرقم', context);
    } else if (phone.length > 9) {
      displayToastMessage('يجب ان يحتوي رقم الهاتف على 9 ارقام', context);
    } else if (!phone.contains('79') &&
        !phone.contains('78') &&
        !phone.contains('77')) {
      displayToastMessage('يجب ان يحتوي رقم الهاتف رمز مزود الخدمة', context);
    } else {
      return phone;
    }
  }
}

class HomePlaceButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  const HomePlaceButton({
    Key key,
    @required this.onTap,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.15,
      decoration: BoxDecoration(
        border: Border.all(width: 0.9, color: Colors.grey),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(40),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
