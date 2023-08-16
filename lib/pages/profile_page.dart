import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/fetch_username.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //user details fetching
  final currentUser = FirebaseAuth.instance.currentUser!;
  File? imageFile; // To store the selected image
  String? imageUrl; // To store the image URL if available

  //sign out
  void signOut()
  {
    FirebaseAuth.instance.signOut();
  }

  //selecting image for profile photo
  Future<void> selectImage() async {
    final selectedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (selectedFile != null) {
      setState(() {
        imageFile = File(selectedFile.path);
      });
    }

    updateProfilePhoto();
  }


  Future<void> updateProfilePhoto() async {
    if (imageFile != null) {
      String userId = currentUser.uid;

      // Upload image to Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref().child('profile_photos/$userId.jpg');
      await storageRef.putFile(imageFile!);

      // Update profile photo URL in Firebase Authentication
      imageUrl = await storageRef.getDownloadURL();
      await currentUser.updatePhotoURL(imageUrl);

      setState(() {
        imageFile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic)
    {
      return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back),
          title: Text("Account"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              color: Theme.of(context).colorScheme.onBackground,
              onPressed: signOut,
            )
          ],
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: 20),

            //profile photo
            GestureDetector(
              onTap: selectImage,
              child: CircleAvatar(
                radius: 73,
                backgroundImage: NetworkImage(currentUser.photoURL!)
              ),
            ),

            SizedBox(height: 10,),
            Text(
              currentUser.displayName.toString(),
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Text(
              currentUser.email.toString(),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            SizedBox(height: 15),

            //useerPosts
            Center(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: SizedBox(
                  width: (MediaQuery.of(context).size.width) - 10,
                  height: (MediaQuery.of(context).size.height) - 450,
                  child: Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Container()
                  ),
                ),
              ),
            )
          ),
          ]
          )
        );
      }
    );
  }
}



//test code
//Account Info
/*
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  height: 150,
                  child: Card(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //profile pic
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              shape: BoxShape.circle
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: ClipOval(child: Image.asset("lib/assets/profile_photo.png",height: 70,width: 70,)),
                            ),
                          ),

                          //account information
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: "Name: ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black
                                    ),
                                    children: <TextSpan> [
                                      TextSpan(
                                        text: currentUser.displayName!,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                        ),
                                      )
                                    ]
                                ),
                              ),
                              SizedBox(height: 12),
                              RichText(
                                  text: TextSpan(
                                    text: "Email: ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black
                                      ),
                                    children: <TextSpan> [
                                      TextSpan(
                                        text: currentUser.email!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                        ),
                                      )
                                    ]
                                  ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ),
                ),
              ),
            ),
             */
/*
  //getting username
  Future<String?> fetchUsername() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        return data['username'];
      }
    }
    return null;
  }

  String? getUser()
  {
    String? username;
    try {
      username = fetchUsername() as String?;
      return username;
    } catch (e) {
      return "Error fetching username: $e";
    }
  }

  Container(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white54,
                        shape: BoxShape.circle
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: ClipOval(child: Image.asset("lib/assets/profile_photo.png",height: 130,width: 130,)),
                    ),
                  ),
                ],
              ),
            ),

currentUser.photoURL != null &&
                          currentUser.photoURL!.isNotEmpty
                          ? NetworkImage(currentUser.photoURL!)
                          : AssetImage("lib/assets/default_profile_photo.jpg") as ImageProvider

  */