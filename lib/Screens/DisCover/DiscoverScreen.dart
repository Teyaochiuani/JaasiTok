import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floein_social_app/components/Custom_NavBar.dart';
import 'package:floein_social_app/components/enums.dart';
import 'package:flutter/material.dart';

class Discover extends StatefulWidget {
  static String routeName = "/discover";
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('friends').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No hay amigos disponibles"));
                  }

                  final friends = snapshot.data!.docs;

                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    itemCount: friends.length,
                    itemBuilder: (BuildContext context, int index) {
                      final friend = friends[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                            height: 55,
                            width: 55,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(friend['dp']),
                              ),
                            ),
                          ),
                          contentPadding: EdgeInsets.all(0),
                          title: Text(friend['name']),
                          subtitle: Text(friend['status']),
                          trailing: friend['isAccept']
                              ? _buildButton("Unfollow", Colors.grey)
                              : _buildButton("Follow", Color(0xff651CE5)),
                          onTap: () {},
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: CustomNavBar(
                selectedMenu: MenuState.discover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color) {
    return Container(
      width: 100.0,
      height: 38.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.9],
          colors: [
            color.withOpacity(0.5),
            color,
          ],
        ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
