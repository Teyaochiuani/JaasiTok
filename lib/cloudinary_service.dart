import 'dart:typed_data'; // Para Uint8List
import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = 'dnwmz8ss2';
  final String apiKey = '434394518526132';
  final String apiSecret = 'fJ264C15O4MyB0ONX6pK3B1nuqI';

  Future<String> uploadMedia(Uint8List fileBytes, String fileName, {required bool isVideo}) async {
    final url = Uri.parse(
      isVideo
          ? 'https://api.cloudinary.com/v1_1/$cloudName/video/upload'
          : 'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', url);

    // Configurar el preset
    request.fields['upload_preset'] = 'jasitok';

    // Adjuntar el archivo
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ),
    );

    // Enviar la solicitud
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(responseBody);
      return jsonResponse['secure_url']; // URL segura del archivo
    } else {
      throw Exception('Error al subir archivo: ${response.statusCode}');
    }
  }
}
