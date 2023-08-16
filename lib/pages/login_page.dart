import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_material/components/login_button.dart';
import 'package:social_media_material/components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap
  });
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controller
  final emailTextController =TextEditingController();
  final passwordTextController =TextEditingController();

  //sign in
  void signIn() async
  {
    //loading indicator
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator()
        )
    );

    try
    {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text
      );
      //pop loading circle
      if(context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch(e)
    {
      //pop loading circle
      Navigator.pop(context);
      displayError(e.code);
    }
  }

  //display error
  void displayError(String message)
  {
    String errorDesc="";
    if(message == "wrong-password" || message == "invalid-email" )
    {
      message="Incorrect Email or Password";
      errorDesc="The email or password you entered is incorrect. Please Try Again";
    }
    else if(message == "too-many-requests")
    {
      message="Too Many Request";
      errorDesc="You have exceeded the limit. Please Try Again Later";
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message),
          content: Text(errorDesc),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Forgot Password")
            ),
            FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Try Again")
            )
          ],
        )
    );
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset("lib/assets/login.png"),
                ),
                SizedBox(height: 20),
                //welcome
                Text(
                  "Welcome back, you've been missed !",
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
                //password
                MyTextField(
                    controller: passwordTextController,
                    hintText: "Password",
                    obscureText: true,
                    icon: Icon(Icons.password_rounded)
                ),
                SizedBox(height: 20),
                //signin
                MyButton(
                    onTap: signIn,
                    label: "Sign In"
                ),
                SizedBox(height: 10),
                //Register Now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a Member"),
                    SizedBox(width: 1),
                    Text("?"),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        " Register Now",
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
