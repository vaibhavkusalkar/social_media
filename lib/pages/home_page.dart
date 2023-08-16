import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:social_media_material/components/posts_card.dart';
import 'package:social_media_material/helper/time_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.only(top: 7,left: 13,right: 13),
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 50,
                  clipBehavior: Clip.none,
                  flexibleSpace:SearchAnchor.bar(
                      barElevation: MaterialStateProperty.all(0),
                      barBackgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondaryContainer),
                    barTrailing: <Widget>[
                        IconButton(
                          icon: Icon(Icons.account_circle_rounded,weight: 0.05,size: 30,),
                          onPressed: (){},
                        ),
                      ],
                      barHintText: 'Search',
                      suggestionsBuilder: (BuildContext context, SearchController controller) {
                        return <Widget>[
                          SizedBox(height: 20),
                          const Center(
                            child: Text("No Search History."),
                          )
                        ];
                      },
                    )
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        child: Expanded(
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("User Posts")
                                      .orderBy("TimeStamp",descending: false)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if(snapshot.hasData) {
                                      return  ListView.builder(
                                        padding: const EdgeInsets.symmetric(vertical: 13),
                                        itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            //get message
                                            final post = snapshot.data!.docs[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 10),
                                              child: PostsCard(
                                                  message: post["Message"],
                                                  user: post["Name"],
                                                  subject: post["Subject"],
                                                  profileURL: post["ProfilePhoto"],
                                                  time: formatTimestamp(post["TimeStamp"]),
                                                  postId: post.id,
                                                  imageURL: post["Image"],
                                                  likes: List<String>.from(post["Likes"] ?? []),
                                              ),
                                            );
                                          }
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text("Error: ${snapshot.error}")
                                      );
                                    }
                                    return const Center(
                                      child:  CircularProgressIndicator(),
                                    );
                                  },
                                )
                            ),
                      ),
                    ],
                  )
                  ),
              ),
            ),
          );
        }
    );
  }
}