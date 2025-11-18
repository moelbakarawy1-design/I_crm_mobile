import 'package:admin_app/core/network/api_helper.dart';
import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';
import 'package:admin_app/core/network/api_response.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class MessagesRepository {
  final APIHelper _apiHelper = APIHelper();

  /// ⭐️ FIXED: Changed return type to ChatMessagesModel
  Future<ChatMessagesModel> getMessages(String chatId) async {
    final ApiResponse response = await _apiHelper.getRequest(
      endPoint: '${EndPoints.getAllChat}/$chatId/messages',
    );

    if (response.status) {
      // ⭐️ FIXED: Parse the full response model, not just one message
      return ChatMessagesModel.fromJson(response.data);
    } else {
      throw Exception(response.message);
    }
  }

  Future<Map<String, dynamic>> sendMessage(String chatId, String message) async {
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

  Future<Map<String, dynamic>> sendAudioMessage(String chatId, String audioFilePath) async {
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
        'file': await MultipartFile.fromFile(
          audioFilePath,
          filename: filename,
          contentType: DioMediaType.parse(mimeType),
        ),
        'type': 'audio',
      };

      print('📝 Form data fields: file (audio: $filename, mimeType: $mimeType), type=audio');

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

  Future<ApiResponse?> createChat(String phone, String name) async {
    try {
      final response = await _apiHelper.postRequest(
        endPoint: "${EndPoints.baseUrl}/chats",
        isFormData: false,
        data: {
          "name" :name,
          "phone": phone},
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
     isFormData: false
      );

      print('🗑️ DELETE /chats/$chatId -> ${response.status}');

      return response;
    } catch (e) {
      print('❌ Error deleting chat: $e');
      rethrow;
    }
  }
}
