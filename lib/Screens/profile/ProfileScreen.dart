import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floein_social_app/components/Custom_NavBar.dart';
import 'package:floein_social_app/components/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? currentUser;
  late DocumentSnapshot? userData;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (currentUser != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      setState(() {
        userData = doc;
      });
    }
  }

  Future<void> handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, "/login_register");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cerrar sesión: $e")),
      );
    }
  }

  void navigateToCreatePost(BuildContext context) {
    Navigator.pushNamed(context, "/create_post");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header del perfil
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/back-arrow.svg",
                              color: Colors.black,
                              height: 25,
                            ),
                            Text(
                              userData?['nickname'] ?? "Cargando...",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 25,
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/icons/dots.svg",
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      // Avatar del perfil
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          height: 200,
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                userData?['profileimageURL'] ??
                                    'https://via.placeholder.com/150',
                              ),
                              radius: 25,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      // Nombre de usuario
                      Text(
                        "@${userData?['nickname'] ?? "Cargando..."}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Estadísticas del perfil
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 55),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "29",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Following",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "140k",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Followers",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "5M",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Likes",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Botones de "Log Out" y "Crear Publicación"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Botón de Cerrar Sesión
                          Container(
                            width: 100.0,
                            height: 43.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff651CE5).withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: Offset(0, 5),
                                ),
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                stops: [0.1, 0.9],
                                colors: [
                                  Color(0xff651CE5),
                                  Color(0xff811ce5),
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
                              onPressed: () => handleLogout(context),
                              child: Text(
                                'Log Out',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          // Botón de Crear Publicación
                          Container(
                            width: 150.0,
                            height: 43.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff651CE5).withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: Offset(0, 5),
                                ),
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                stops: [0.1, 0.9],
                                colors: [
                                  Color(0xff651CE5),
                                  Color(0xff811ce5),
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
                              onPressed: () => navigateToCreatePost(context),
                              child: Text(
                                'New Post',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      // Publicaciones del usuario
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('userID', isEqualTo: currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Text("No hay publicaciones aún.");
                          }
                          final posts = snapshot.data!.docs;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            primary: false,
                            padding: EdgeInsets.all(5),
                            itemCount: posts.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 200 / 300,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              final post = posts[index];
                              return Padding(
                                padding: EdgeInsets.all(5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.network(
                                    post['mediaUrl'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 300),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomNavBar(
                    selectedMenu: MenuState.profile,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
