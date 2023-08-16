import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/post_text_field.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  //post text
  final messageTextController =TextEditingController();
  final subjectTextController =TextEditingController();
  File? imageFile; // To store the selected image
  String? imageUrl; // To store the image URL if available

  final currentUser = FirebaseAuth.instance.currentUser!;

  // Upload the image to Firebase Storage
  Future<void> uploadImage() async {
    Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.jpg');
    UploadTask uploadTask = storageReference.putFile(imageFile!);

    await uploadTask.whenComplete(() async {
      imageUrl = await storageReference.getDownloadURL();
    });
  }

  //post message
  Future<void> postMessage() async {
    if (imageFile != null) {
      await uploadImage();
    }

    //post only if message is not empty
    if(messageTextController.text.isNotEmpty && subjectTextController.text.isNotEmpty)
      {
        FirebaseFirestore.instance.collection("User Posts").add({
          "Name" : currentUser.displayName,
          "Subject": subjectTextController.text,
          "Message": messageTextController.text,
          "ProfilePhoto": currentUser.photoURL,
          "Image": imageUrl ?? null,
          "TimeStamp": Timestamp.now(),
          "Likes": []
        });
      }

    //clear textfield and image
    setState(() {
      subjectTextController.clear();
      messageTextController.clear();
      imageFile = null;
      imageUrl = null;
    });
  }

  //selecting image from device
  Future<void> selectImage() async {
    final selector = ImagePicker();
    final selectedFile = await selector.pickImage(source: ImageSource.gallery);

    if (selectedFile != null) {
      setState(() {
        imageFile = File(selectedFile.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.close_rounded),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: FilledButton(
                onPressed: postMessage,
                child: Text("Post")
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 15),
        child: Column(
          children: [
            //add photo
            if (imageFile != null) ...[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Image.file(imageFile!),
                ),
              ),
            ] else ...[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Center(
                      child: IconButton(
                          icon: Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 70,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          onPressed: selectImage
                      )
                  ),
                ),
              ),
            ],
            SizedBox(height: 15),
            //Write Subject(Short Message)
            Expanded(
                child: Container(
                  child: PostTextField(
                    controller: subjectTextController,
                    hintText: "Post Subject",
                    minHeight: 80,
                  ),
                )
            ),

            SizedBox(height: 15),
            //Write Descriptive Messege
            Expanded(
                child: Container(
                  child: PostTextField(
                    controller: messageTextController,
                    hintText: "Post Description",
                    minHeight: 150,
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}





//test code
/*
  Future<String?> fetchUsername() async {
    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
    if (docSnapshot.exists) {
      var data = docSnapshot.data() as Map<String, dynamic>;
      return data['username'];
    }
    return null;
  }


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

  String? get() {
    FutureBuilder<String?>(
      future: fetchUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Text('Username: ${snapshot.data}');
        } else {
          return Text('Username not found');
        }
      },
    );
  }
*/