import 'package:admin_app/core/network/api_helper.dart';
import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart'; // ✅ Make sure this path is correct
import 'package:admin_app/core/network/api_response.dart';

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
