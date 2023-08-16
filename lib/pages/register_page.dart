import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_media_material/components/login_button.dart';
import 'package:social_media_material/components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({
    super.key,
    required this.onTap
  });
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controller
  final emailTextController =TextEditingController();
  final nameTextController =TextEditingController();
  final passwordTextController =TextEditingController();
  final confirmPasswordTextController =TextEditingController();
  File? imageFile;

  void displayError(String title, String desc) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text(title),
              content: Text(desc),
              actions: <Widget>[
                FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Try Again")
                )
              ],
            )
    );
  }

  //defualt image upload
  Future<void> uploadDefaultProfileImage(String userId) async {
    ByteData byteData = await rootBundle.load('lib/assets/default_profile_photo.jpg');
    List<int> imageData = byteData.buffer.asUint8List();
    Uint8List uint8ImageData = Uint8List.fromList(imageData);

    Reference storageRef =
    FirebaseStorage.instance.ref().child('profile_photos/$userId.jpg');
    await storageRef.putData(uint8ImageData);

    String imageUrl = await storageRef.getDownloadURL();

    // Update user's profile photo URL
    await FirebaseAuth.instance.currentUser?.updatePhotoURL(imageUrl);

    setState(() {
      imageFile = null;
    });
  }

  //sign up
  void signUp() async
  {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) =>
        const Center(
            child: CircularProgressIndicator()
        )
    );

    if (passwordTextController.text != confirmPasswordTextController.text) {
      //pop loading circle
      Navigator.pop(context);

      //show error
      displayError("Password dont't match",
          "The password you entered does not match. Please Try Again");
      return;
    }

    //creating user
    try {
      Navigator.pop(context);
          final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text, 
          password: passwordTextController.text
          );
          final currentUser = FirebaseAuth.instance.currentUser;
          await currentUser?.updateDisplayName(nameTextController.text);

          if (currentUser != null) {
            await uploadDefaultProfileImage(currentUser.uid);
          }

    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);

      //show error
      displayError("Invalid Email or Password",
          "The email or password you entered is invalid. Please Try Again");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15),
                SizedBox(
                  height: 280,
                  child: Image.asset("lib/assets/login.png"),
                ),
                SizedBox(height: 15),
                //welcome
                Text(
                  "Let's Create an Account",
                  style: TextStyle(
                      fontSize: 15
                  ),
                ),
                SizedBox(height: 20),
                //email
                MyTextField(
                    controller: emailTextController,
                    hintText: "Email",
                    obscureText: false,
                    icon: Icon(Icons.mail_rounded)
                ),
                //username
                MyTextField(
                    controller: nameTextController,
                    hintText: "Name",
                    obscureText: false,
                    icon: Icon(Icons.badge_rounded)
                ),
                //password
                MyTextField(
                    controller: passwordTextController,
                    hintText: "Password",
                    obscureText: true,
                    icon: Icon(Icons.password_rounded)
                ),
                //confirm password
                MyTextField(
                    controller: confirmPasswordTextController,
                    hintText: " Confirm Password",
                    obscureText: true,
                    icon: Icon(Icons.password_rounded)
                ),
                SizedBox(height: 20),
                //signin
                MyButton(
                    onTap: signUp,
                    label: "Sign Up"
                ),
                SizedBox(height: 10),
                //Register Now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a Member"),
                    SizedBox(width: 1),
                    Text("?"),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        " Login Now",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
