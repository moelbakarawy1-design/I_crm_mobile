import 'package:admin_app/core/network/api_helper.dart';
import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/core/network/api_response.dart' show ApiResponse;
import 'package:admin_app/featuer/chat/data/model/chat_model12.dart';

class ChatRepository {
  final APIHelper _apiHelper = APIHelper();

  // Fetch all chats
  Future<ChatModelNEW> getAllChats() async {
    try {
      final response = await _apiHelper.getRequest(endPoint: EndPoints.getAllChat);
      return ChatModelNEW.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch chats: $e');
    }
  }

  // Fetch messages for specific chat ID
  Future<Data> getChatMessages(String chatId) async {
    try {
      final response = await _apiHelper.getRequest(endPoint: '${EndPoints.getAllChat}/$chatId/messages');
      return Data.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to fetch chat messages: $e');
    }
  }
 
  Future<ApiResponse> deleteChat(String chatId) async {
    try {
      final response = await _apiHelper.deleteRequest(
        endPoint: "${EndPoints.baseUrl}/chats/$chatId",
      );
      return response;
    } catch (e) {
      print('❌ Error deleting chat: $e');
      return ApiResponse(
        status: false,
        statusCode: 500,
        message: e.toString(),
      );
    }
  }

}
