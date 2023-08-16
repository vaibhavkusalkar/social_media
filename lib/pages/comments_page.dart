import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_material/components/comment_card.dart';
import '../helper/time_helper.dart';

class CommentsPage extends StatefulWidget {
  final String user;
  final String postId;
  const CommentsPage({
    super.key,
    required this.user,
    required this.postId
  });

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  //comment text controller
  final commentTextController = TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser!;
  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText" : commentText,
      "CommentedByEmail" : currentUser.email,
      "CommentedByName" : currentUser.displayName,
      "CommentTime" : Timestamp.now()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.all(10),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Comments"),
          centerTitle: false,
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close")
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
            .collection("User Posts")
            .doc(widget.postId)
            .collection("Comments")
            .orderBy("CommentTime", descending: false)
            .snapshots(),
          builder: (context, snapshot) {
            //show loading circle
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              shrinkWrap: true,  //for nested lists
              physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((doc) {
                //fetch the comments
                final commentData = doc.data() as Map<String, dynamic>;
                //return comments
                return CommentCard(
                    text: commentData["CommentText"],
                    user: commentData["CommentedByEmail"],
                    time: formatTimestamp(commentData["CommentTime"]),
                    name: commentData["CommentedByName"],
                );
              }).toList(),
            );
          }
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
          child: Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.surfaceVariant
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
              child: TextField(
                controller: commentTextController,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write a comment...",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send_rounded),
                    onPressed: (){
                      //post
                      addComment(commentTextController.text);

                      //clear controller
                      commentTextController.clear();
                    },
                  )
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}