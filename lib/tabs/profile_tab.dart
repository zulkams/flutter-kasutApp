import 'package:a_commerce/constants.dart';
import 'package:a_commerce/screens/register_page.dart';
import 'package:a_commerce/services/firebase_services.dart';
import 'package:a_commerce/widgets/custom_btn.dart';
import 'package:a_commerce/widgets/custom_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                child: Text("Close Dialog"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  FirebaseServices _firebaseServices = FirebaseServices();

  final SnackBar _snackBarOk = SnackBar(
    content: Text("Password changed successfully"),
  );

  final SnackBar _snackBarError = SnackBar(
    content: Text("ERROR! Please re-enter the current password"),
  );

  void _changePassword() async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user.email, password: currentPassword);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        Scaffold.of(context).showSnackBar(_snackBarOk);
      }).catchError((error) {
        Scaffold.of(context).showSnackBar(_snackBarError);
      });
    }).catchError((err) {});

    FirebaseFirestore.instance
        .collection("userData")
        .doc(_firebaseServices.getUserId())
        .set({
      'password': newPassword,
    });
  }

  // Default Form Loading State
  bool _loginFormLoading = false;

  // Form Input Field Values
  String currentPassword;
  String newPassword;

  // Focus Node for input fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 24.0,
                ),
                child: Text(
                  "\n\nChange your Password",
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText: "Current Password",
                    onChanged: (value) {
                      currentPassword = value;
                    },
                    isPasswordField: true,
                    onSubmitted: (value) {
                      _changePassword();
                    },
                  ),
                  CustomInput(
                    hintText: "New Password",
                    onChanged: (value) {
                      newPassword = value;
                    },
                    isPasswordField: true,
                    onSubmitted: (value) {
                      _changePassword();
                    },
                  ),
                  CustomBtn(
                    text: "Change Password",
                    onPressed: () {
                      _changePassword();
                    },
                    isLoading: _loginFormLoading,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
