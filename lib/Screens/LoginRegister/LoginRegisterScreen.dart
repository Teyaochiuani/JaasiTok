import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:floein_social_app/cloudinary_service.dart';

class LoginRegisterScreen extends StatefulWidget {
  static String routeName = "/login_register";

  const LoginRegisterScreen({Key? key}) : super(key: key);

  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();
  String? _profileImageURL;

  bool isLogin = true;

  Future<void> _selectProfileImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final fileBytes = result.files.first.bytes;
        final fileName = result.files.first.name;

        final uploadedUrl = await CloudinaryService().uploadMedia(
          fileBytes!,
          fileName,
          isVideo: false,
        );

        setState(() {
          _profileImageURL = uploadedUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Imagen de perfil subida correctamente")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al seleccionar imagen: $e")),
      );
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      if (isLogin) {
        // Login
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        // Register
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final userId = userCredential.user!.uid;

        // Save user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'email': _emailController.text.trim(),
          'nickname': _nicknameController.text.trim(),
          'profileimageURL': _profileImageURL ?? '', // Default if no image selected
        });

        Navigator.pushReplacementNamed(context, "/home");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLogin ? "Iniciar Sesión" : "Registrarse",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!isLogin)
                    GestureDetector(
                      onTap: _selectProfileImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        backgroundImage: _profileImageURL != null
                            ? NetworkImage(_profileImageURL!)
                            : null,
                        child: _profileImageURL == null
                            ? const Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.blue,
                              )
                            : null,
                      ),
                    ),
                  if (!isLogin) const SizedBox(height: 20),
                  _buildInputField(
                    controller: _emailController,
                    labelText: "Correo Electrónico",
                  ),
                  const SizedBox(height: 15),
                  _buildInputField(
                    controller: _passwordController,
                    labelText: "Contraseña",
                    obscureText: true,
                  
                  ),
                  if (!isLogin) const SizedBox(height: 15),
                  if (!isLogin)
                    _buildInputField(
                      controller: _nicknameController,
                      labelText: "Nombre de Usuario",
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isLogin ? "Iniciar Sesión" : "Registrarse",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin
                          ? "¿No tienes cuenta? Regístrate"
                          : "¿Ya tienes cuenta? Inicia Sesión",
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }
}
