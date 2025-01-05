import 'package:hive/hive.dart';

part 'attachment.g.dart';

@HiveType(typeId: 1)
class Attachment extends HiveObject {
  @HiveField(0)
  final String fileName;

  @HiveField(1)
  final String filePath;

  @HiveField(2)
  final DateTime uploadDate;

  @HiveField(3)
  final String fileType;

  Attachment({
    required this.fileName,
    required this.filePath,
    required this.uploadDate,
    required this.fileType,
  });
}
