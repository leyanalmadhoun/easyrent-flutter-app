import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  CloudinaryService._();

  static const cloudName = 'uor2czxn';
  static const uploadPreset = 'easyrent_unsigned';

  static Future<String> uploadImage(XFile image) async {
    final bytes = await image.readAsBytes();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
    );
    request.fields['upload_preset'] = uploadPreset;
    request.fields['folder'] = 'easyrent/cars';
    request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: image.name));
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Image upload failed (${response.statusCode}).');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final url = data['secure_url'] as String?;
    if (url == null || url.isEmpty) throw Exception('Cloudinary did not return an image URL.');
    return url;
  }
}
