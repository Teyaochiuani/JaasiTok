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
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                isLogin ? "Iniciar Sesión" : "Registrarse",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              if (!isLogin)
                GestureDetector(
                  onTap: _selectProfileImage,
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImageURL != null
                          ? NetworkImage(_profileImageURL!)
                          : AssetImage("assets/images/default-avatar.png") as ImageProvider,
                      child: _profileImageURL == null
                          ? Icon(Icons.camera_alt, size: 50)
                          : null,
                    ),
                  ),
                ),
              if (!isLogin) SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Correo electrónico"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa un correo";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Contraseña"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa una contraseña";
                  }
                  return null;
                },
              ),
              if (!isLogin) SizedBox(height: 10),
              if (!isLogin)
                TextFormField(
                  controller: _nicknameController,
                  decoration: InputDecoration(labelText: "Nombre de usuario"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor ingresa un nombre de usuario";
                    }
                    return null;
                  },
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text(isLogin ? "Iniciar Sesión" : "Registrarse"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(isLogin ? "¿No tienes cuenta? Regístrate" : "¿Ya tienes cuenta? Inicia Sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
