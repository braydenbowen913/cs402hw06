import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PhotoService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> takePhoto() async {
    final XFile? file =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (file == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}${extension(file.path)}';
    final newPath = join(dir.path, fileName);
    await File(file.path).copy(newPath);
    return newPath;
  }
}
