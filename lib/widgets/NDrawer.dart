import 'package:flutter/material.dart';
import 'package:social_media/widgets/NListTile.dart';

class NDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOutTap;
  const NDrawer(
      {super.key, required this.onProfileTap, required this.onSignOutTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column(
          children: [
            // header
            DrawerHeader(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 64,
              ),
            ),

            //home list tile
            NListTile(
                icon: Icons.home,
                text: "H O M E",
                onTap: () => Navigator.pop(context)),

                //Profile list tile
            NListTile(
                icon: Icons.person, 
                text: "P R O F I L", 
                onTap: onProfileTap),
          ],
        ),
        //logout list tile
        Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: NListTile(icon: Icons.logout, text: "L O G O U T", onTap: onSignOutTap),
        ), 
      ]),
    );
  }
}
