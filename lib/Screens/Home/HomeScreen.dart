import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:floein_social_app/Screens/Home/home_card.dart';
import 'package:floein_social_app/components/Custom_NavBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:floein_social_app/components/enums.dart';


class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  late Map<String, dynamic> userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userSnapshot.exists) {
          setState(() {
            userData = userSnapshot.data()!;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar los datos del usuario: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Header con el nombre y foto de perfil
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/menu.svg",
                                    color: Color(0xff651CE5),
                                    height: 50,
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 150,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                      color: Colors.black.withOpacity(0.05),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: Colors.white,
                                            ),
                                            height: 45,
                                            width: 45,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                userData['profileimageURL'] ?? 'https://via.placeholder.com/150',
                                              ),
                                              radius: 25,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            userData['nickname'] ?? 'Usuario desconocido',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            // StreamBuilder para publicaciones
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return Center(child: Text("No hay publicaciones disponibles"));
                                }

                                final posts = snapshot.data!.docs;

                                return Column(
                                  children: posts.map((post) {
                                    return FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(post['userID'])
                                          .get(),
                                      builder: (context, userSnapshot) {
                                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                                          return Center(child: CircularProgressIndicator());
                                        }
                                        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                                          return Text("Usuario no encontrado");
                                        }

                                        final user = userSnapshot.data!;

                                        return HomeCard(
                                          postId: post.id,
                                          profileImageURL: user['profileimageURL'] ?? 'https://via.placeholder.com/150',
                                          nickname: user['nickname'] ?? 'Usuario desconocido',
                                          des: post['des'] ?? '',
                                          mediaUrl: post['mediaUrl'] ?? '',
                                          isVideo: post['isVideo'] ?? false,
                                          likesCount: post['likesCount'] ?? 0,
                                          isLiked: post['likes']?[FirebaseAuth.instance.currentUser!.uid] ?? false,
                                        );
                                      },
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: CustomNavBar(
                        selectedMenu: MenuState.home,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
