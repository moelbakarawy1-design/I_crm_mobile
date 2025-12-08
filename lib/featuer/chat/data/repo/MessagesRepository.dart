import 'package:admin_app/core/network/api_helper.dart';
import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';
import 'package:admin_app/core/network/api_response.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class MessagesRepository {
  final APIHelper _apiHelper = APIHelper();
  Future<ChatMessagesModel> getMessages(String chatId, {String? cursor}) async {
    Map<String, dynamic> queryParams = {'limit': 20};
    if (cursor != null) {
      queryParams['cursor'] = cursor;
    }
    final ApiResponse response = await _apiHelper.getRequest(
      endPoint: '${EndPoints.getAllChat}/$chatId/messages',
      queryParameters: queryParams,
    );
    if (response.status) {
      return ChatMessagesModel.fromJson(response.data);
    } else {
      throw Exception(response.message);
    }
  }

  Future<Map<String, dynamic>> sendMessage(
    String chatId,
    String message,
  ) async {
    final ApiResponse response = await _apiHelper.postRequest(
      endPoint: '${EndPoints.getAllChat}/$chatId/messages',
      isFormData: false,
      data: {'content': message},
    );

    if (response.status) {
      return response.data;
    } else {
      throw Exception(response.message);
    }
  }

  Future<Map<String, dynamic>> sendAudioMessage(
    String chatId,
    String audioFilePath,
  ) async {
    try {
      // Verify file exists
      final audioFile = File(audioFilePath);
      if (!audioFile.existsSync()) {
        throw Exception("Audio file not found: $audioFilePath");
      }

      print('📤 Sending audio file: $audioFilePath');

      // Get original filename
      String filename = audioFile.path.split('/').last;

      print('📝 Filename: $filename');

      // Determine MIME type based on file extension
      String mimeType = 'audio/wav';
      if (filename.endsWith('.wav')) {
        mimeType = 'audio/wav';
      } else if (filename.endsWith('.m4a')) {
        mimeType = 'audio/mp4';
      } else if (filename.endsWith('.mp4')) {
        mimeType = 'audio/mp4';
      } else if (filename.endsWith('.ogg')) {
        mimeType = 'audio/ogg';
      } else if (filename.endsWith('.opus')) {
        mimeType = 'audio/opus';
      } else if (filename.endsWith('.webm')) {
        mimeType = 'audio/webm';
      }

      final data = {
        'files': await MultipartFile.fromFile(
          audioFilePath,
          filename: filename,
          contentType: DioMediaType.parse(mimeType),
        ),
        'type': 'audio',
      };

      print(
        '📝 Form data fields: file (audio: $filename, mimeType: $mimeType), type=audio',
      );

      final ApiResponse response = await _apiHelper.postRequest(
        endPoint: '${EndPoints.getAllChat}/$chatId/messages',
        isFormData: true,
        data: data,
      );

      if (response.status) {
        print('✅ Audio message sent successfully');
        return response.data;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('❌ Error sending audio message: $e');
      throw Exception("Failed to send audio: $e");
    }
  }

  Future<Map<String, dynamic>> sendImageMessage(
    String chatId,
    String imagePath,
    String caption,
  ) async {
    try {
      final file = File(imagePath);
      if (!file.existsSync()) {
        throw Exception("Image file not found");
      }

      String filename = file.path.split('/').last;

      // Determine Mime Type
      String mimeType = 'image/jpeg';
      if (filename.endsWith('.png')) {
        mimeType = 'image/png';
      } else if (filename.endsWith('.jpg') || filename.endsWith('.jpeg')) {
        mimeType = 'image/jpeg';
      }

      final data = {
        'files': await MultipartFile.fromFile(
          imagePath,
          filename: filename,
          contentType: DioMediaType.parse(mimeType),
        ),
        'type': 'image',
        'caption': caption,
        'content': filename, // ✅ Added content field
      };

      print('📤 Sending Image: $filename, Caption: $caption');

      final ApiResponse response = await _apiHelper.postRequest(
        endPoint: '${EndPoints.getAllChat}/$chatId/messages',
        isFormData: true,
        data: data,
      );

      if (response.status) {
        return response.data;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('❌ Error sending image: $e');
      throw Exception("Failed to send image: $e");
    }
  }

  Future<ApiResponse?> createChat(String phone, String name) async {
    try {
      final response = await _apiHelper.postRequest(
        endPoint: "${EndPoints.baseUrl}/chats",
        isFormData: false,
        data: {"name": name, "phone": phone},
      );
      return response;
    } catch (e) {
      print('❌ Error creating chat: $e');
      return null;
    }
  }

  Future<ApiResponse> deleteChat(String chatId) async {
    try {
      final response = await _apiHelper.deleteRequest(
        endPoint: '${EndPoints.getAllChat}/$chatId',
        isFormData: false,
      );

      print('🗑️ DELETE /chats/$chatId -> ${response.status}');

      return response;
    } catch (e) {
      print('❌ Error deleting chat: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendVideoMessage(
    String chatId,
    String videoPath,
    String caption,
  ) async {
    try {
      final file = File(videoPath);
      if (!file.existsSync()) throw Exception("Video file not found");

      String filename = file.path.split('/').last;

      // تحديد نوع الفيديو بدقة
      String mimeType = 'video/mp4'; // Default
      if (filename.endsWith('.avi')) {
        mimeType = 'video/x-msvideo';
      } else if (filename.endsWith('.mov'))
        mimeType = 'video/quicktime';
      else if (filename.endsWith('.mkv'))
        mimeType = 'video/x-matroska';

      final data = {
        'files': await MultipartFile.fromFile(
          videoPath,
          filename: filename,
          contentType: DioMediaType.parse(mimeType),
        ),
        'type': 'video',
        'caption': caption,
        'content': filename, // ✅ Added content field
      };

      print('📤 Sending Video: $filename');

      final ApiResponse response = await _apiHelper.postRequest(
        endPoint: '${EndPoints.getAllChat}/$chatId/messages',
        isFormData: true,
        data: data,
      );

      if (response.status) {
        return response.data;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('❌ Error sending video: $e');
      throw Exception("Failed to send video: $e");
    }
  }

  Future<Map<String, dynamic>> sendDocumentMessage(
    String chatId,
    String filePath,
  ) async {
    try {
      final file = File(filePath);
      if (!file.existsSync()) throw Exception("Document file not found");

      String filename = file.path.split('/').last;

      // تحديد نوع الملف بدقة
      String mimeType = 'application/octet-stream';
      if (filename.endsWith('.pdf')) {
        mimeType = 'application/pdf';
      } else if (filename.endsWith('.doc'))
        mimeType = 'application/msword';
      else if (filename.endsWith('.docx'))
        mimeType =
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      else if (filename.endsWith('.xls'))
        mimeType = 'application/vnd.ms-excel';
      else if (filename.endsWith('.txt'))
        mimeType = 'text/plain';

      final data = {
        'files': await MultipartFile.fromFile(
          filePath,
          filename: filename,
          contentType: DioMediaType.parse(mimeType),
        ),
        'type': 'document',
        'content': filename,
      };

      print('📤 Sending Document: $filename');

      final ApiResponse response = await _apiHelper.postRequest(
        endPoint: '${EndPoints.getAllChat}/$chatId/messages',
        isFormData: true,
        data: data,
      );

      if (response.status) {
        return response.data;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('❌ Error sending document: $e');
      throw Exception("Failed to send document: $e");
    }
  }

  Future<Map<String, dynamic>> sendLocationMessage(
    String chatId,
    double latitude,
    double longitude,
  ) async {
    try {
      final data = {
        'lat': '$latitude',
        'long': '$longitude',
        'type': 'location',
      };
      final ApiResponse response = await _apiHelper.postRequest(
        endPoint: '${EndPoints.getAllChat}/$chatId/messages',
        isFormData: true,
        data: data,
      );
      if (response.status) {
        return response.data;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('❌ Error sending location: $e');
      throw Exception("Failed to send location");
    }
  }

  //  Send Contact
  Future<Map<String, dynamic>> sendContactMessage(
    String chatId,
    String name,
    String phone,
  ) async {
    try {
      // Construct the specific JSON structure the backend wants
      final contactData = [
        {
          "name": {
            "first_name": name.split(" ").first,
            "last_name": name.split(" ").length > 1 ? name.split(" ").last : "",
            "formatted_name": name,
          },
          "phones": [
            {"phone": phone, "type": "MOBILE"},
          ],
        },
      ];

      final data = {
        'type': 'contacts', // Type is plural 'contacts' usually
        'contacts': contactData, // The backend expects this array
      };
      final ApiResponse response = await _apiHelper.postRequest(
        endPoint: '${EndPoints.getAllChat}/$chatId/messages',
        isFormData: false,
        data: data,
      );

      if (response.status) {
        return response.data;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      throw Exception("Failed to send contact");
    }
  }
}
