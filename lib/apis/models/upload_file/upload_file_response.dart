class UploadFileResponse {
  final String fileId;
  final String filePath;

  UploadFileResponse(this.fileId, this.filePath);

  UploadFileResponse.fromJson(Map<String, dynamic> json)
      : fileId = json['file_ID'] as String,
        filePath = json['file_Path'] as String;
}
