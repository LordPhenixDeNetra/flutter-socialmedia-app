import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/helper/HelperMethods.dart';
import 'package:social_media/pages/ProfilePage.dart';
import 'package:social_media/widgets/NDrawer.dart';
import 'package:social_media/widgets/NTextField.dart';
import 'package:social_media/widgets/NWallPost.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  // Sign out
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // Post message
  void postMessage() {
    //only post if there is something in the TextField
    if (textController.text.isNotEmpty) {
      //Store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
      textController.text = '';
    }
  }

  void goToProfilePage() {
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        // backgroundColor: Colors.grey[900],
        title: Text(
          "The Wall",
          style: TextStyle(fontSize: 28),
        ),
        centerTitle: true,
        // actions: [IconButton(onPressed: signOut, icon: Icon(Icons.logout))],
      ),
      drawer: NDrawer(
        onProfileTap: goToProfilePage,
        onSignOutTap: signOut,
      ),

      body: Center(
        child: Column(
          children: [
            //The wall
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .orderBy("TimeStamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      //Get the message
                      final post = snapshot.data!.docs[index];

                      return NWallPost(
                        message: post["Message"],
                        user: post["UserEmail"],
                        postId: post.id,
                        likes: List<String>.from(post["Likes"] ?? []), 
                        time: HelperMethods.formatDate(post["TimeStamp"]),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error : ${snapshot.error}"),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              },
            )),

            //Post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                      child: NTextField(
                    controller: textController,
                    hintText: 'Write something of the wall',
                    obscureText: false,
                  )),
                  //Post button
                  IconButton(
                      onPressed: postMessage, icon: Icon(Icons.arrow_circle_up))
                ],
              ),
            ),

            //Logged in as
            Text(
              "Logged in as ${currentUser.email!}",
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
