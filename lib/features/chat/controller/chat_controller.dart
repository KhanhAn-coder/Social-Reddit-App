import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/chat/repository/chat_repository.dart';
import 'package:reddit_app/models/chat_model.dart';
import 'package:reddit_app/models/user_model.dart';
import 'package:uuid/uuid.dart';

import '../../../core/ultis.dart';

final chatControllerProvider = StateNotifierProvider<ChatController,bool>((ref) {
  return ChatController(chatRepository: ref.read(chatRepositoryProvider), ref: ref);
});

final getMessagesProvider = StreamProvider.family((ref, String friendId) {
  return ref.watch(chatControllerProvider.notifier).getMessages(friendId);
});


final getLatestMessagesProvider = StreamProvider.family((ref, String friendId) {
  return ref.watch(chatControllerProvider.notifier).getLatestMessages(friendId);
});

class ChatController extends StateNotifier<bool>{
  ChatRepository _chatRepository;
  Ref _ref;

  ChatController({
    required ChatRepository chatRepository,
    required Ref ref
  }): _chatRepository = chatRepository,
      _ref = ref,
      super(false);

  void sendMessage({
    required String friendId,
    required String senderId,
    required String text,
    required String senderProfilePic,
    required BuildContext context
  }) async{
    String id = const Uuid().v1();
    Chat chat = Chat(
        senderId: senderId,
        friendId: friendId,
        text: text,
        id: id,
        senderProfilePic: senderProfilePic,
        createdAt: DateTime.now()
    );
    final res = await _chatRepository.sendMessage(chat);
    res.fold((l) => showSnackBar(context,l.message), (r) => null);
  }

  void addFriend(UserModel user, UserModel friend) async{
    await _chatRepository.addFriend(user, friend);
  }

  Stream<List<Chat>> getMessages(String friendId){
    String senderId = _ref.watch(userProvider)!.uid;
    return _chatRepository.getMessages(senderId, friendId);
  }



  Stream<List<Chat>> getLatestMessages(String friendId){
    UserModel user = _ref.watch(userProvider)!;
    return _chatRepository.getLatestMessages(user.uid, friendId);
  }

}