import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:floein_social_app/cloudinary_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String? _mediaUrl;
  bool _isVideo = false;

  Future<void> _pickMedia() async {
    try {
      // Usar FilePicker para seleccionar imágenes o videos
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media, // Seleccionar cualquier archivo multimedia
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final fileBytes = result.files.first.bytes;
        final fileName = result.files.first.name;

        // Determinar si el archivo es un video o una imagen
        final fileExtension = fileName.split('.').last.toLowerCase();
        _isVideo = fileExtension == 'mp4' || fileExtension == 'mov' || fileExtension == 'avi';

        // Subir a Cloudinary
        final uploadedMediaUrl = await CloudinaryService().uploadMedia(
          fileBytes!,
          fileName,
          isVideo: _isVideo,
        );

        setState(() {
          _mediaUrl = uploadedMediaUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Archivo subido correctamente")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No se seleccionó ningún archivo")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al seleccionar archivo: $e")),
      );
    }
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate() || _mediaUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor completa todos los campos e incluye un archivo")),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      // Obtener datos del usuario desde Firebase
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

      if (!userDoc.exists) {
        throw Exception("Usuario no encontrado en la base de datos");
      }

      await FirebaseFirestore.instance.collection('posts').add({
        'des': _descriptionController.text.trim(),
        'mediaUrl': _mediaUrl,
        'isVideo': _isVideo,
        'hash': _hashtagsController.text.trim().split(','),
        'userID': user.uid,
        'nickname': userDoc['nickname'],
        'profileimageURL': userDoc['profileimageURL'],
        'likes': {}, // Mapa vacío para inicializar likes
        'likesCount': 1, // Contador inicializado en 0
        'comments': [], // Lista vacía para comentarios
        'timestamp': FieldValue.serverTimestamp(),
      });


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Publicación creada exitosamente")),
      );

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
                  "Archivo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                if (_mediaUrl != null)
                  Center(
                    child: _isVideo
                        ? Container(
                            height: 200,
                            child: Center(child: Text("Vista previa del video no soportada")),
                          )
                        : Image.network(
                            _mediaUrl!,
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
