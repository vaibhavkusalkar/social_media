import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_material/components/comment_button.dart';
import 'package:social_media_material/components/like_button.dart';
import 'package:social_media_material/pages/comments_page.dart';

class PostsCard extends StatefulWidget {
  final String subject;
  final String message;
  final String user;
  final String profileURL;
  final String postId;
  final String? imageURL;
  final List<String> likes;
  final String time;
  const PostsCard({
    super.key,
    required this.subject,
    required this.message,
    required this.user,
    required this.profileURL,
    required this.postId,
    required this.imageURL,
    required this.likes,
    required this.time
  });

  @override
  State<PostsCard> createState() => _PostsCardState();
}

class _PostsCardState extends State<PostsCard> {
  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  //comment text controller
  final commentTextController = TextEditingController();

  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked =!isLiked;
    });

    //Access the document
    DocumentReference postRef=FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);
    if(isLiked) {
      //if the post is liked ,add user email to the likes field
      postRef.update({
        "Likes": FieldValue.arrayUnion([currentUser.email])
      });
    }
    else {
      //if the post is unliked remove user email from likes field
      postRef.update({
        "Likes": FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  //comments fullscreen dialog
  void showComments() {
    showDialog(
        context: context,
        builder: (context) => Dialog.fullscreen(
          child: CommentsPage(
            postId: widget.postId,
            user: widget.user,
          )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    String image = widget.imageURL ?? '';
    return Flexible(
        child: Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //post info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //profile photo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle
                          ),
                          child: ClipOval(
                            child: Image.network(
                              widget.profileURL,
                              fit: BoxFit.cover,
                            ),
                          )
                        ),
                        const SizedBox(width: 13),
                        //Email/username and time
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                                widget.user,
                              style: TextStyle(
                                fontSize: 14,
                                height: 0.9,
                                fontWeight: FontWeight.w500
                              ),
                            ), //email/username
                            Text(
                                widget.time,
                              style: TextStyle(
                                  fontSize: 13,
                                wordSpacing: 0.3,
                                fontWeight: FontWeight.w300
                              ),
                            )  //timestamp
                          ],
                        ),
                      ],
                    ),

                    //comment
                    Row(
                      children: [
                        //comment
                        Column(
                          children: [
                            CommentButton(
                                onTap: (){
                                  // Navigate to the Comments page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CommentsPage(
                                      postId: widget.postId,
                                      user: widget.user,
                                      )
                                    ),
                                  );
                                }
                            ),
                        /*
                        //comment count
                        Text(
                          widget.likes.length.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54
                            //fontWeight: FontWeight.w400
                              ),
                            )
                         */
                          ],
                        ),

                        SizedBox(width: 10),

                        //like
                        Column(
                          children: [
                            //like button
                            LikeButton(
                                isLiked: isLiked,
                                onTap: toggleLike
                            ),
                            //const SizedBox(height: 5),

                            //like count
                            /*
                        Text(
                          widget.likes.length.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54
                            //fontWeight: FontWeight.w400
                          ),
                        )
                         */
                          ],
                        )
                      ],
                    ),


                    /*Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white60,
                      ),
                      child: IconButton(
                        icon: Icon(
                            Icons.favorite_border_outlined,
                            size: 20,
                        ),
                        onPressed: (){},
                      ),
                    )*/
                  ],
                ),
                SizedBox(height: 8),
                Text(
                    widget.subject,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20
                  ),
                ),
                const SizedBox(height: 6),
                Text(widget.message),
                //const SizedBox(height: 8),
                Visibility(
                  visible: widget.imageURL != null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),

                        child: Image.network(image, fit: BoxFit.cover),
                      ),
                    ),
                  )
                )
              ],
            )
          ),
        )
    );
  }
}
