import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:floein_social_app/cloudinary_service.dart';

class CreatePostScreen extends StatefulWidget {
  static String routeName = "/create_post";

  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _hashtagsController = TextEditingController();
  Uint8List? _fileBytes;
  String? _fileName;
  bool _isVideo = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userSnapshot.exists) {
        setState(() {
          userData = userSnapshot.data();
        });
      }
    }
  }

  Future<void> _pickMedia() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _fileBytes = result.files.first.bytes;
          _fileName = result.files.first.name;

          final fileExtension = _fileName!.split('.').last.toLowerCase();
          _isVideo = fileExtension == 'mp4' || fileExtension == 'mov' || fileExtension == 'avi';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Archivo seleccionado correctamente")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al seleccionar archivo: $e")),
      );
    }
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor completa todos los campos.")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null || userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuario no autenticado o datos no cargados.")),
      );
      return;
    }

    // Crear la estructura de la publicación con todos los campos requeridos
    final post = {
      'des': _descriptionController.text.trim(),
      'hash': _hashtagsController.text.trim().split(','),
      'isVideo': _isVideo,
      'userID': user.uid,
      'nickname': userData!['nickname'],
      'profileimageURL': userData!['profileimageURL'],
      'likes': {}, // Inicializar likes como un mapa vacío
      'likesCount': 0, // Inicializar contador de likes en 0
      'comments': [], // Lista vacía para comentarios
      'timestamp': DateTime.now().toIso8601String(), // Usar ISO 8601 para la marca de tiempo
      'mediaUrl': '', // Media URL vacío por defecto
    };

    try {
      // Detectar conexión a Internet
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        // Guardar publicación localmente
        final prefs = await SharedPreferences.getInstance();
        final cachedPosts = prefs.getStringList('cached_posts') ?? [];
        if (_fileBytes != null) {
          post['fileBytes'] = base64Encode(_fileBytes!);
          post['fileName'] = _fileName!;
        }
        cachedPosts.add(jsonEncode(post));
        await prefs.setStringList('cached_posts', cachedPosts);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Publicación guardada localmente.")),
        );
      } else {
        // Subir archivo a Cloudinary si hay conexión
        if (_fileBytes != null) {
          final uploadedMediaUrl = await CloudinaryService().uploadMedia(
            _fileBytes!,
            _fileName!,
            isVideo: _isVideo,
          );
          post['mediaUrl'] = uploadedMediaUrl;
        }

        // Subir publicación a Firebase
        await FirebaseFirestore.instance.collection('posts').add({
          ...post,
          'timestamp': FieldValue.serverTimestamp(), // Usar Firebase FieldValue en Firebase
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Publicación subida exitosamente.")),
        );
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al crear publicación: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Publicación"),
        backgroundColor: Color(0xff651CE5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Descripción",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Escribe una descripción para tu publicación",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "La descripción no puede estar vacía";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  "Archivo (opcional)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                if (_fileBytes != null)
                  Center(
                    child: _isVideo
                        ? Container(
                            height: 200,
                            child: Center(child: Text("Vista previa del video no soportada")),
                          )
                        : Image.memory(
                            _fileBytes!,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                  ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: _pickMedia,
                    child: Text("Seleccionar Archivo"),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Hashtags",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _hashtagsController,
                  decoration: InputDecoration(
                    hintText: "Agrega hashtags separados por comas",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff651CE5),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "Publicar",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
