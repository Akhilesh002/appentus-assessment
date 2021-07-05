import 'dart:io';

import 'package:appentus_assessment/db/db_helper.dart';
import 'package:appentus_assessment/screen/login_screen.dart';
import 'package:appentus_assessment/util/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({Key? key}) : super(key: key);

  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  bool _passwordVisible = true;
  PickedFile? pickedFile;
  ImagePicker picker = ImagePicker();
  File? imageFile;
  Directory? directory;
  File? storedImage;
  String image = '';

  @override
  void initState() {
    super.initState();
    getDirectoryPath();
  }

  getDirectoryPath() async {
    directory = await getApplicationDocumentsDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: TextStyle(
            letterSpacing: 1.0,
            fontSize: 16.0,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 40.0,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(5.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.blue.shade100,
          ),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3.0),
                  child: TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      contentPadding: const EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3.0),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      contentPadding: const EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3.0),
                  child: TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _passwordVisible,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3.0),
                  child: TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: 'Mobile Number',
                      contentPadding: const EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    pickedFile = await picker.getImage(source: ImageSource.gallery, maxHeight: 75.0, maxWidth: 75.0, imageQuality: 75);
                    if (pickedFile == null) return;
                    directory = await getApplicationDocumentsDirectory();
                    String directoryPath = directory!.path;
                    imageFile = File(pickedFile!.path);
                    final File localImage = await imageFile!.copy('$directoryPath/image.png');
                    print(localImage.path);
                    setState(() {
                      image = imageFile!.path;
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(20.0)),
                      height: 100.0,
                      width: 100.0,
                      child: image.isEmpty
                          ? Icon(
                              Icons.error,
                              size: 40.0,
                            )
                          : CircleAvatar(backgroundImage: FileImage(File(image)), radius: 50, backgroundColor: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (image.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please choose an image first')));
                      return;
                    }
                    _onSubmit(nameController.text, emailController.text, passwordController.text, numberController.text, image);
                  },
                  child: Text(
                    'Create an account',
                    style: TextStyle(letterSpacing: 1.0, fontSize: 18.0),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Already have an account!  ',
                    style: TextStyle(color: Colors.black, fontSize: 17.0),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Login',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          },
                        style: new TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  _onSubmit(String name, String email, String password, String number, String image) {
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && number.isNotEmpty) {
      if (name.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Name\'s length should be minimum 6 characters.')));
        return;
      }
      if (email.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email\'s length should be minimum 6 characters.')));
        return;
      }
      if (password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password\'s length should be minimum 6 characters.')));
        return;
      }
      if (number.length < 10) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mobile number\'s length should be minimum 10 characters.')));
        return;
      }

      Box? userBox = DbHelper().getUserBox();
      if (!userBox!.containsKey(Constant.name) &&
          !userBox.containsKey(Constant.email) &&
          !userBox.containsKey(Constant.password) &&
          !userBox.containsKey(Constant.mobile) &&
          !userBox.containsKey(Constant.image)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please wait. We are creating your account')));
        userBox.put(Constant.name, name).whenComplete(() {
          userBox.put(Constant.email, email).whenComplete(() {
            userBox.put(Constant.password, password).whenComplete(() {
              userBox.put(Constant.mobile, number).whenComplete(() {
                userBox.put(Constant.image, image).whenComplete(() {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text('Your account is created. Please press below button to navigate to login screen'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                              },
                              child: Text('Okay'),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      });
                });
              });
            });
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An user already exists on your device. Please login or reinstall application to create another account.'),
          ),
        );
        return;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter valid credential')));
    }
  }
}
