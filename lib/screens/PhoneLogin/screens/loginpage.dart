// ignore_for_file: constant_identifier_names, use_key_in_widget_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gasna_user/brand_colors.dart';
import 'package:gasna_user/globalvariable.dart';
import 'package:gasna_user/models/Regions.dart';
import 'package:gasna_user/screens/SplashScreen.dart';
import 'package:gasna_user/widgets/CustomizedTextField.dart';
import 'package:gasna_user/widgets/GradientButton.dart';
import 'package:gasna_user/widgets/TaxiButton.dart';

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
          'phone': '$countryCode${checkData(phoneController.text)}',
          'governatsPlace': governatsPlace,
          'places': places,
        };
        newUserRef.child('users/${authCredential.user.uid}').set(userMap);
        Navigator.pushNamedAndRemoveUntil(
            context, SplashScreen.id, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      displayToastMessage(e.message, context);
    }
  }

  @override
  void initState() {
    getAllJsons();
    super.initState();
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
                      color: BrandColors.colorPrimaryDark,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 40),
            SvgPicture.asset(
              'images/undraw_my_location_re_r52x.svg',
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
                  textInputType: TextInputType.name,
                  codeCountry: false,
                ),
                const SizedBox(height: 20),
                TaxiButton(
                  color: BrandColors.colorLightGray,
                  onPressed: () {
                    chooseDistrectModalBottomSheet(context);
                  },
                  title: governatsPlace,
                ),
                const SizedBox(height: 20),
                TaxiButton(
                  color: BrandColors.colorLightGray,
                  onPressed: () {
                    chooseCityModalBottomSheet(context);
                  },
                  title: places,
                ),
                const SizedBox(height: 20),
                CustomizedTextField(
                  controller: phoneController,
                  hint: 'رقم الهاتف',
                  textInputType: TextInputType.number,
                  codeCountry: true,
                  widget: Container(
                    decoration: BoxDecoration(
                      color: BrandColors.colorLightGray,
                      borderRadius: BorderRadius.circular(25),
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
                ),
                const SizedBox(height: 30),
                GradientButton(
                  onPressed: () async {
                    setState(() {
                      showLoading = true;
                    });

                    await _auth.verifyPhoneNumber(
                      phoneNumber:
                          '$countryCode${checkData(phoneController.text)}',
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
          textInputType: TextInputType.name,
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

  void chooseDistrectModalBottomSheet(context) {
    showModalBottomSheet(
        elevation: 5,
        backgroundColor: Colors.white.withOpacity(0),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0),
                ),
              ),
              child: Wrap(
                children: <Widget>[
                  Container(height: 10),
                  Center(
                    child: Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: BrandColors.colorPrimaryDark.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  Container(height: 15),
                  Center(
                    child: Text(
                      'إختر المحافظة',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(height: 15),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: regions.districts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(regions.districts[index].districtAR),
                        onTap: () {
                          setState(() {
                            governatsPlace =
                                regions.districts[index].districtAR;
                            citys = regions.districts[index].cities;
                            places = 'إختر المدينة';
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void chooseCityModalBottomSheet(context) {
    showModalBottomSheet(
        elevation: 5,
        backgroundColor: Colors.white.withOpacity(0),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(height: 10),
                    Center(
                      child: Container(
                        height: 5,
                        width: MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(
                          color: BrandColors.colorPrimaryDark.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    Container(height: 15),
                    Center(
                      child: Text(
                        'إختر المدينة',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(height: 15),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: citys.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(citys[index].cityAR),
                          onTap: () {
                            setState(() {
                              places = citys[index].cityAR;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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
  String checkData(String phone) {
    if (phone.startsWith('0')) {
      displayToastMessage('احذف الصفر في بداية الرقم', context);
    } else if (phone.length > 9) {
      displayToastMessage('يجب ان يحتوي رقم الهاتف على 9 ارقام', context);
    } else if (!phone.contains('79') &&
        !phone.contains('78') &&
        !phone.contains('77')) {
      displayToastMessage('يجب ان يحتوي رقم الهاتف رمز مزود الخدمة', context);
    } else if (places == 'إختر المدينة') {
      displayToastMessage('يجب ان تختار موقع سكنك', context);
    } else if (governatsPlace == 'إختر المحافظة') {
      displayToastMessage('يجب ان تختار موقع سكنك', context);
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

void getAllJsons() async {
  String jsonString;
  jsonString = await rootBundle.loadString('assets/region.json');
  Map<String, dynamic> jsonMap = json.decode(jsonString);
  jsonMap = json.decode(jsonString);
  regions = Regions.fromJson(jsonMap);
}
