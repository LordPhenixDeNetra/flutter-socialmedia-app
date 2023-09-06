import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/widgets/NTextBox.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //Current user
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollections = FirebaseFirestore.instance.collection("Users");

  //edit field
  Future<void> editField(String field) async {
    String newValue = "";

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(
                "Edit ${field}",
                style: TextStyle(color: Colors.white),
              ),
              content: TextField(
                decoration: InputDecoration(
                    hintText: "Enter a ${field}",
                    hintStyle: TextStyle(color: Colors.grey)),
                style: TextStyle(color: Colors.black),
                autofocus: true,
                onChanged: (value) {
                  newValue = value;
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(newValue),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ));

    // Update in firestore
    if (newValue.trim().length > 0) {
      // Only update if is something in the textfield
      await userCollections.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.grey[300],
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          // backgroundColor: Colors.grey[900],
          title: Text(
            "Profile",
            style: TextStyle(fontSize: 28),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              // Get user data
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;

                return ListView(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    // profile pic
                    Icon(
                      Icons.person,
                      size: 72,
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    // User mail
                    Text(
                      currentUser.email!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),

                    SizedBox(
                      height: 18,
                    ),
                    // User detail

                    Padding(
                      padding: EdgeInsets.only(left: 25),
                      child: Text("My Details",
                          style: TextStyle(color: Colors.grey[600])),
                    ),

                    // User name
                    NTextBox(
                      text: userData["username"] ??
                          "", // Use an empty string if userData["username"] is null
                      sectionName: "username",
                      onPressed: () => editField('username'),
                    ),

// Bio
                    NTextBox(
                      text: userData["bio"] ??
                          "", // Use an empty string if userData["bio"] is null
                      sectionName: "Bio",
                      onPressed: () => editField('bio'),
                    ),

                    SizedBox(
                      height: 18,
                    ),

                    // User Posts
                    Padding(
                      padding: EdgeInsets.only(left: 25),
                      child: Text("My Posts",
                          style: TextStyle(color: Colors.grey[600])),
                    ),
                  ],
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
            }));
  }
}
