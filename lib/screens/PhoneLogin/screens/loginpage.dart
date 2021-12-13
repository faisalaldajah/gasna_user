import 'dart:async';
import 'package:gasna_user/Screens/PhoneLogin/services/authservice.dart';
import 'package:gasna_user/Widgets/GradientButton.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gasna_user/screens/StartPage.dart';

class LoginPages extends StatefulWidget {
  static const String id = 'login';
  @override
  _LoginPagesState createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String phoneNo, verificationId, smsCode;

  bool codeSent = false;
  String governorate;
  String homePlaceName;
  var otpKey;
  CountryCode countryCode;
  Timer _timer;
  int _start = 60;
  var fullNameController = TextEditingController();

  var placeController = TextEditingController();

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
      key: scaffoldKey,
      body: Form(
          key: formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 50,
              ),
              Image(
                alignment: Alignment.center,
                height: 160.0,
                width: 160.0,
                image: AssetImage('images/gasna.png'),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  CountryCodePicker(
                    initialSelection: 'JO',
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    favorite: ['+962', 'JO'],
                    showFlagMain: true,
                    onInit: (value) {
                      countryCode = value;
                    },
                    onChanged: (value) {
                      countryCode = value;
                    },
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'رقم الهاتق',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 30),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(hintText: 'الاسم الكامل'),
                  controller: fullNameController,
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 30),
                  child: DropdownButton<String>(
                    value: governorate,
                    hint: Text('المحافظة'),
                    onChanged: (value) {
                      setState(() {
                        //homePlaceName = '';
                        governorate = value;
                      });
                    },
                    items:
                        <String>['عمان', 'الكرك'].map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 30),
                  child: (governorate == 'الكرك')
                      ? DropdownButton<String>(
                          value: homePlaceName,
                          hint: Text('المنطقة'),
                          onChanged: (value) {
                            setState(() {
                              homePlaceName = value;
                            });
                          },
                          items: <String>['زحوم', 'الثنية', 'المرج', 'المزار']
                              .map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        )
                      : DropdownButton<String>(
                          value: homePlaceName,
                          hint: Text('المنطقة'),
                          onChanged: (value) {
                            setState(() {
                              homePlaceName = value;
                              //print(homePlaceName);
                            });
                          },
                          items: <String>[
                            'طبربور',
                            'ماركا',
                            'الهاشمي',
                            'جبل الحسين'
                          ].map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                ),
              ),
              codeSent ? Center(child: Text('$_start')) : Container(),
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
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: GradientButton(
                  title: codeSent ? 'تسجيل' : 'تأكيد',
                  onPressed: () {
                    codeSent
                        ? AuthService().signInWithOTP(smsCode, verificationId)
                        : verifyPhone(
                            phoneController.text, countryCode.toString());
                  },
                ),
              ),
              SizedBox(height: 50),
            ],
          )),
    );
  }

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

//verifyPhone(phoneNo);
//print('$otpKey${phoneController.text}');
  Future<void> verifyPhone(var phoneNo, var otp) async {
    if (homePlaceName == '') {
      showSnackBar('أختر منطقة');
      return;
    }
    if (governorate == '') {
      showSnackBar('أختر محافظة');
      return;
    }
    if (fullNameController.text == null) {
      showSnackBar('خانة الاسم فارغة');
      return;
    }
    startTimer();
    var phoneNumber = '$otp$phoneNo';
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
            'governorate': governorate,
            'homePlaceName': homePlaceName
          };

          newUserRef.child('users/${value.user.uid}').set(userMap);
          fullNameController.clear();
          phoneController.clear();
          Navigator.pushNamed(context, StartPage.id);
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
