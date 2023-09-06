import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/helper/HelperMethods.dart';
import 'package:social_media/widgets/NComment.dart';
import 'package:social_media/widgets/NCommentButton.dart';
import 'package:social_media/widgets/NDeleteButton.dart';
import 'package:social_media/widgets/NLikeButton.dart';

class NWallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> likes;

  const NWallPost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes,
      required this.time});

  @override
  State<NWallPost> createState() => _NWallPostState();
}

class _NWallPostState extends State<NWallPost> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final _commentTextController = TextEditingController();
  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.likes.contains(currentUser?.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //Access the document in Firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);
    if (isLiked) {
      // If the post is now liked, add the user's email to the "Like" field
      postRef.update({
        "Likes": FieldValue.arrayUnion([currentUser?.email])
      });
    } else {
      // If the post is now unliked, remove the user's email from the "Like" field
      postRef.update({
        "Likes": FieldValue.arrayRemove([currentUser?.email])
      });
    }
  }

  // Add comment
  void addComment(String commentText) {
    // Write the comment to firebase under the comment collections for this post
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser?.email,
      "CommentTime":
          Timestamp.now(), // Remember to format this whene displaying
    });
  }

  // Show a dialog box for adding a comment
  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Add Comment"),
              content: TextField(
                controller: _commentTextController,
                decoration: InputDecoration(hintText: "Write a comment..."),
              ),
              actions: [
                // Cancel button
                TextButton(
                  onPressed: () {
                    // Pop box
                    Navigator.pop(context);
                    // Clear controller
                    _commentTextController.clear();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    // Add comment
                    addComment(_commentTextController.text);
                    // Pop box
                    Navigator.pop(context);
                    // Clear controller
                    _commentTextController.clear();
                  },
                  child: Text(
                    "Post",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ));
  }

  // Delete post
  void deletePost() {
    // show a dialog box asking for confirmation before deleting the post
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Delete post"),
              content: Text("Are you sure you want to delete this post ?"),
              actions: [
                // CANCEL BUTTON
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),

                TextButton(
                  onPressed: () async {
                    // Delete the post from firestore first
                    final commentDocs = await FirebaseFirestore.instance
                        .collection("User Posts")
                        .doc(widget.postId)
                        .collection("Comments")
                        .get();
                    for (var doc in commentDocs.docs) {
                      await FirebaseFirestore.instance
                        .collection("User Posts")
                        .doc(widget.postId)
                        .collection("Comments")
                        .doc(doc.id)
                        .delete();
                    }

                    // Then delete the post
                    FirebaseFirestore.instance
                        .collection("User Posts")
                        .doc(widget.postId)
                        .delete()
                        .then((value) => print("Post deleted"))
                        .catchError((error) => print("Failed to delete post : ${error}"));

                    // Dimiss the dialog
                    Navigator.pop(context);

                  },
                  child: Text("Delete"),
                ),

                // DELETE BUTTON
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        // color: Colors.grey[200],
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wall post
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // group of text (message + user email)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Message
                  Text(widget.message, overflow: TextOverflow.clip,),

                  SizedBox(
                    height: 5,
                  ),

                  //User
                  //User, time
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(".", style: TextStyle(color: Colors.grey[400])),
                      Text(widget.time,
                          style: TextStyle(color: Colors.grey[400])),
                    ],
                  ),
                ],
              ),

              // Delete button
              if (widget.user == currentUser?.email)
                NDeleteButton(
                  onTap: deletePost,
                )
            ],
          ),

          SizedBox(
            width: 20,
          ),

          // Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LIKE
              Column(
                children: [
                  //Like button
                  NLikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //Like count
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              SizedBox(
                width: 15,
              ),

              // COMMENT
              Column(
                children: [
                  //Like button
                  NCommentButton(
                    onTap: showCommentDialog,
                  ),

                  SizedBox(
                    height: 5,
                  ),
                  //Comment count
                  Text(
                    "0",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(
            height: 20,
          ),

          //Comment under the post
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .orderBy("CommentTime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // Show loading circle if no data yet
                if (!snapshot.hasData) {
                  return CircularProgressIndicator(
                    color: Colors.black,
                  );
                }

                return ListView(
                  shrinkWrap: true, // For nested lists
                  physics: NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    // Get the comment
                    final commentData = doc.data() as Map<String, dynamic>;
                    // Return the comment
                    return NComment(
                        text: commentData["CommentText"],
                        user: commentData["CommentedBy"],
                        time: HelperMethods.formatDate(
                            commentData["CommentTime"]));
                  }).toList(),
                );
              }),
        ],
      ),
    );
  }
}
