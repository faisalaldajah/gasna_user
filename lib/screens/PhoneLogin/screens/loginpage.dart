import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gasna_user/brand_colors.dart';
import 'package:gasna_user/screens/PhoneLogin/services/authservice.dart';
import 'package:gasna_user/screens/mainpage.dart';
import 'package:gasna_user/widgets/GradientButton.dart';

class LoginPages extends StatefulWidget {
  static const String id = 'login';
  @override
  _LoginPagesState createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    // ignore: deprecated_member_use
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final formKey = new GlobalKey<FormState>();

  String verificationId, smsCode;

  bool codeSent = false;
  CountryCode countryCode;
  String otpKey;

  Timer _timer;
  int _start = 180;
  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.colorBackground,
      key: scaffoldKey,
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'images/gasna.png',
                  width: 150,
                  height: 150,
                ),
                Center(
                  child: AutoSizeText(
                    'غازنا',
                    style: TextStyle(
                      fontFamily: 'Kharabeesh',
                      fontSize: 50,
                      color: BrandColors.colorAccent,
                    ),
                    minFontSize: 15,
                  ),
                ),SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 30),
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 15),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(hintText: 'الاسم الكامل'),
                          controller: fullNameController,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    CountryCodePicker(
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
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(left: 5,right: 20),
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(hintText: '7********'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                codeSent ? Center(child: Text('time: $_start')) : Container(),
                SizedBox(height: 30),
                codeSent
                    ? Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: (otpKey == null) ? 'ادخل الرمز' : otpKey,
                          ),
                          onChanged: (val) {
                            setState(() {
                              this.smsCode = val;
                            });
                          },
                        ))
                    : Container(),
                SizedBox(height: 10),
                codeSent
                    ? TextButton(
                        onPressed: () {
                          codeSent
                              ? AuthService()
                                  .signInWithOTP(smsCode, verificationId)
                              : verifyPhone(phoneController.text, countryCode);
                        },
                        child: Text('إعادة إرسال'))
                    : Container(),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25),
                  child: GradientButton(
                    title: codeSent ? 'تسجيل' : 'تأكيد',
                    onPressed: () {
                      codeSent
                          ? AuthService().signInWithOTP(smsCode, verificationId)
                          : verifyPhone(phoneController.text, countryCode);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ignore: missing_return
  String checkNumber(String phone) {
    if (phone.startsWith('0')) {
      return phone.substring(1);
    }
    if (phone.length < 9 || phone.length > 9) {
      print(phone.length);
      showSnackBar('يجب ان يحتوي رقم الهاتف على 10 ارقام');
    } else
      return phone;
  }

  Future<void> verifyPhone(phoneNo, var country) async {
    startTimer();
    var phoneNumber = '$country${checkNumber(phoneNo)}';
    final PhoneVerificationCompleted verified =
        (PhoneAuthCredential credential) async {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        if (value.user != null) {
          otpKey = credential.smsCode;
          print('otpkey: $otpKey');
          DatabaseReference newUserRef = FirebaseDatabase.instance.reference();

          //Prepare data to be saved on users table
          Map userMap = {
            'fullname': fullNameController.text,
            'phone': phoneNumber,
          };

          newUserRef.child('users/${value.user.uid}').set(userMap);
          Navigator.pushNamed(context, MainPage.id);
        }
      });
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      print('authException: ${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      print('object: $verificationId');
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
      print('object: $verificationId');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verified,
      verificationFailed: verificationfailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }
}
