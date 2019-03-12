/// 文件类型工具类
class FileFormatUtil {
  static mediaFormat(String mediaType) {
    return FileFormatMap[mediaType];
  }
}

/// 文件类型
const FileFormatMap = {
  'application/pdf': 'pdf',
  'application/msword': 'doc',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
      'docx'
};
