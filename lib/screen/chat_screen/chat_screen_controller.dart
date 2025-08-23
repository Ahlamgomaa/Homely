import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/confirmation_dialog.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/chat/chat_user.dart';
import 'package:homely/model/chat/conversation.dart';
import 'package:homely/model/property/fetch_saved_property.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/upload_file.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/chat_screen/widget/property_list_sheet.dart';
import 'package:homely/screen/chat_screen/widget/select_item_sheet.dart';
import 'package:homely/screen/chat_screen/widget/send_media_sheet.dart';
import 'package:homely/screen/chat_screen/widget/send_property_sheet.dart';
import 'package:homely/screen/report_screen/report_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/app_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/fire_res.dart';
import 'package:homely/utils/url_res.dart';
import 'package:image_picker/image_picker.dart';

/// textMsg = 1;
/// imageMsg = 2;
/// videoMsg = 3;
/// property = 4;

class ChatScreenController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<DocumentSnapshot<Chat>> chatList = [];
  List<int?> deletedChatList = [];
  List<int> propertyIdsList = [];
  Conversation conversation;
  UserData? savedUser;
  UserData? conversationUser;
  PropertyMessage? propertyMessage;

  static String notificationUserId = '';
  late CollectionReference<Map<String, dynamic>> dChatMessage;
  DocumentReference<Map<String, dynamic>>? dReceiver;
  DocumentReference<Map<String, dynamic>>? dSender;
  Function(List<PropertyData>)? listenPropertyData;

  StreamSubscription<DocumentSnapshot<Conversation>>? userListener;
  StreamSubscription<QuerySnapshot<Chat>>? chatStream;
  TextEditingController textMessageController = TextEditingController();
  TextEditingController sendMediaController = TextEditingController();
  ScrollController scrollController = ScrollController();
  ImagePicker picker = ImagePicker();
  PrefService prefService = PrefService();

  List<PropertyData> propertyList = [];

  ScrollController propertyScrollController = ScrollController();

  int deletedId = 0;

  // track if products fetching
  bool isLoading = false;
  bool isPropertyFetching = false;

  // flag for more products available or not
  bool hasMore = true;
  bool hasMoreProperty = true;

  // flag for last document from where next {Your document limit} records to be fetched
  DocumentSnapshot<Chat>? lastDocument;

  int screen;
  bool isBlock = false;
  bool isDeletedMsg = false;
  Function(int blockUnBlock)? onUpdateUser;

  ChatScreenController(this.conversation, this.propertyMessage, this.screen, this.onUpdateUser);

  @override
  void onReady() {
    notificationUserId = conversation.conversationId ?? '';
    initFirebase();
    _loadMoreData();
    super.onReady();
  }

  void fetchProfile() {
    CommonUI.loader();
    ApiService().call(
      url: UrlRes.fetchProfileDetail,
      param: {uUserId: PrefService.id, uMyUserId: PrefService.id},
      completion: (response) {
        Get.back();
        FetchUser result = FetchUser.fromJson(response);
        if (result.status == true) {
          savedUser = result.data;
          propertyIdsList.addAll(savedUser?.userPropertyIds ?? []);
          if ((savedUser?.blockUserIds?.split(',') ?? [])
              .contains(conversation.user?.userID.toString())) {
            isBlock = true;
            blockUnblockUserFirebase(status: true);
          } else {
            isBlock = false;
            blockUnblockUserFirebase(status: false);
          }
          update();
          if (!isBlock && propertyMessage != null && screen == 0) {
            sendFirebaseMessage(messageType: 4, propertyMessage: propertyMessage);
          }
        } else {}
      },
    );
    ApiService().call(
        completion: (response) {
          FetchUser result = FetchUser.fromJson(response);
          if (result.status == true) {
            conversationUser = result.data;
            propertyIdsList.addAll(conversationUser?.userPropertyIds ?? []);
            update();
          }
        },
        url: UrlRes.fetchProfileDetail,
        param: {
          uUserId: conversation.user?.userID,
          uMyUserId: PrefService.id,
        });
  }

  void initFirebase() async {
    chatList = [];
    CommonUI.loader();
    await prefService.init();
    savedUser = prefService.getUserData();
    dReceiver = db
        .collection(FireRes.user)
        .doc(conversation.user?.userID.toString())
        .collection(FireRes.userList)
        .doc(savedUser?.id.toString());
    dSender = db
        .collection(FireRes.user)
        .doc(savedUser?.id.toString())
        .collection(FireRes.userList)
        .doc(conversation.user?.userID.toString());

    if (conversation.conversationId != null) {
      conversation.setConversationId(conversation.conversationId ?? '');
    } else {
      conversation
          .setConversationId(CommonFun.getConversationId(savedUser?.id, conversation.user?.userID));
    }
    dChatMessage =
        db.collection(FireRes.chat).doc(conversation.conversationId).collection(FireRes.chatList);

    getChat();
    Get.back();
    fetchProfile();
    getUserListListener();
    fetchMyPropertyApiCall();
    fetchScrollProperties();
  }

  void getUserListListener() {
    userListener = dSender
        ?.withConverter(
          fromFirestore: (snapshot, options) => Conversation.fromJson(snapshot.data()!),
          toFirestore: (Conversation value, options) {
            return value.toJson();
          },
        )
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        conversation = event.data()!;
        update();
      }
    });
  }

  void getChat() {
    dSender
        ?.withConverter(
          fromFirestore: (snapshot, options) => Conversation.fromJson(snapshot.data()!),
          toFirestore: (Conversation value, options) => value.toJson(),
        )
        .get()
        .then((value) {
      deletedId = value.data()?.deletedId ?? 0;
    });

    chatStream = dChatMessage
        .where(FireRes.notDeletedIdentity, arrayContains: savedUser?.id)
        .where(FireRes.timeId, isGreaterThan: deletedId)
        .withConverter(
          fromFirestore: (snapshot, options) => Chat.fromJson(snapshot.data()!),
          toFirestore: (Chat value, options) => value.toJson(),
        )
        .orderBy(FireRes.timeId, descending: true)
        .limit(cFirebaseDocumentLimit)
        .snapshots()
        .listen((event) {
      for (var element in event.docChanges) {
        switch (element.type) {
          case DocumentChangeType.added:
            // log('Added');
            chatList.add(element.doc);
            chatList.sort(
              (a, b) {
                return b.id.compareTo(a.id);
              },
            );
            update();
            break;
          case DocumentChangeType.modified:
            // log('Modified');
            break;
          case DocumentChangeType.removed:
            // log('Remove');
            break;
        }
      }
      if (event.docs.isNotEmpty) {
        lastDocument = event.docs.last;
      }
    });
  }

  // Chat Send firebase message

  Future<void> sendFirebaseMessage({
    required int messageType,
    String? message,
    String? videoMessage,
    String? imageMessage,
    PropertyMessage? propertyMessage,
  }) async {
    int time = DateTime.now().millisecondsSinceEpoch;
    List<int> noDeletedIdentity = [savedUser?.id ?? -1, conversation.user?.userID ?? -1];
    ChatUser senderUser = ChatUser(
        identity: savedUser?.email,
        image: savedUser?.profile,
        msgCount: 1,
        name: savedUser?.fullname,
        userID: savedUser?.id,
        userType: savedUser?.userType,
        verificationStatus: savedUser?.verificationStatus);
    await dChatMessage.doc(time.toString()).set(Chat(
          timeId: time,
          message: message,
          notDeletedIdentity: noDeletedIdentity,
          msgType: messageType,
          senderUser: senderUser,
          propertyCard: propertyMessage,
          imageMessage: imageMessage,
          videoMessage: videoMessage,
        ).toJson());

    String userMessage = messageType == 1
        ? (message ?? '')
        : messageType == 2
            ? FireRes.photoMessage
            : messageType == 3
                ? FireRes.videoMessage
                : messageType == 4
                    ? '${propertyMessage?.message == null || propertyMessage!.message!.isEmpty ? FireRes.propertyMessage : propertyMessage.message}'
                    : '';

    Map<String, dynamic> con = conversation.toJson();
    con[FireRes.newMessage] = userMessage;
    dSender?.get().then((value) async {
      if (!value.exists) {
        await dSender?.set(con);
        await dReceiver?.set(Conversation(
          user: ChatUser(
              userID: savedUser?.id,
              identity: savedUser?.email,
              name: savedUser?.fullname,
              image: savedUser?.profile,
              userType: savedUser?.userType,
              msgCount: 0,
              verificationStatus: savedUser?.verificationStatus),
          time: conversation.time,
          newMessage: userMessage,
          lastMessage: userMessage,
          isDeleted: false,
          iAmBlocked: false,
          iBlocked: false,
          deletedId: 0,
          conversationId: conversation.conversationId,
        ).toJson());
      } else {
        dReceiver
            ?.withConverter(
              fromFirestore: (snapshot, options) => Conversation.fromJson(snapshot.data()!),
              toFirestore: (Conversation value, options) => value.toJson(),
            )
            .get()
            .then((value) {
          ChatUser? user = value.data()?.user;
          user?.msgCount = (user.msgCount ?? 0) + 1;
          dReceiver?.update({
            FireRes.newMessage: userMessage,
            FireRes.deletedId: 0,
            FireRes.isDeleted: false,
            FireRes.time: time,
            FireRes.user.toLowerCase(): user?.toJson()
          });
          dSender?.update({
            FireRes.newMessage: userMessage,
            FireRes.isDeleted: false,
            FireRes.deletedId: 0,
            FireRes.time: time,
          });
        });
      }
      if (conversationUser != null) {
        String body = messageType == 1
            ? message.toString()
            : messageType == 2
                ? FireRes.photoMessage.toString()
                : messageType == 3
                    ? FireRes.videoMessage.toString()
                    : '${propertyMessage?.message == null || propertyMessage!.message!.isEmpty ? FireRes.propertyMessage : propertyMessage.message}';
        ApiService().pushNotification(
            title: senderUser.name?.trim() ?? '',
            deviceType: conversationUser?.deviceType,
            body: body,
            conversationId: conversation.conversationId ?? '',
            token: conversationUser?.deviceToken);
      }
    });
  }

  // Chat Text Message

  void onTextFieldTap() {
    if (deletedChatList.isNotEmpty) {
      onDeleteMessageCancel();
    }
  }

  void onTextMsgSend() {
    if (conversation.iBlocked == true) {
      CommonUI.snackBar(title: '${S.current.youAreBlockFrom} ${conversation.user?.name}');
      textMessageController.clear();
      return;
    }
    if (textMessageController.text.trim().isEmpty) {
      return;
    }
    sendFirebaseMessage(
      messageType: 1,
      message: textMessageController.text.trim(),
    );
    textMessageController.clear();
  }

  // Chat Plus Button

  void onPlusButtonClick() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (conversation.iBlocked == true) {
      CommonUI.snackBar(title: '${S.current.youAreBlockFrom} ${conversation.user?.name}');
      textMessageController.clear();
      return;
    }
    if (deletedChatList.isNotEmpty) {
      onDeleteMessageCancel();
    }
    Get.bottomSheet(
        SelectItemSheet(
          onTap: selectItem,
        ),
        isScrollControlled: true);
  }

  void selectItem(int index) async {
    // BottomSheet close
    Get.back();
    if (index == 1) {
      Get.bottomSheet(PropertyListSheet(
        data: propertyList,
        controller: propertyScrollController,
        fetchData: fetchProperty,
        onPropertySend: (data) {
          Get.back();
          Get.bottomSheet(
            SendPropertySheet(
              data: data,
              onSendBtnClick: (p0, p1) {
                Get.back();
                List<String> propertyImage = [];
                data.media?.forEach((element) {
                  if (element.mediaTypeId != 7) {
                    propertyImage.add(element.content ?? '');
                  }
                });
                PropertyMessage property = PropertyMessage(
                    title: data.title,
                    propertyId: data.id,
                    message: p1,
                    image: propertyImage,
                    address: data.address,
                    propertyType: data.propertyAvailableFor);
                sendFirebaseMessage(
                  messageType: 4,
                  propertyMessage: property,
                  message: p1,
                );
              },
            ),
            isScrollControlled: true,
          );
        },
      ));
    } else if (index == 2) {
      Get.bottomSheet(
        SelectMediaSheet(
          onTap: onSelectMedia,
        ),
      );
    } else if (index == 3) {
      try {
        picker
            .pickImage(
                source: ImageSource.camera,
                imageQuality: cQualityImage,
                maxHeight: cMaxHeightImage,
                maxWidth: cMaxWidthImage)
            .then((value) {
          if (value == null) return;
          sendMediaSheet(image: value, messageType: 2);
        });
      } catch (e) {
        CommonUI.snackBar(title: S.current.youNotAllowPhotoAccess);
      }
    } else {
      selectVideo(0);
    }
  }

  void selectVideo(int type) {
    picker
        .pickVideo(
            source: type == 1 ? ImageSource.gallery : ImageSource.camera,
            maxDuration: const Duration(minutes: 5))
        .then((value) {
      if (value == null) return;
      if (CommonFun.getSizeInMb(value) <= maximumVideoSizeInMb) {
        VideoThumbnail.thumbnailFile(
                video: value.path,
                imageFormat: ImageFormat.JPEG,
                quality: cQualityVideo,
                maxWidth: cMaxWidthVideo,
                maxHeight: cMaxHeightVideo)
            .then((v) {
          sendMediaSheet(image: v, messageType: 3, video: value);
        });
      } else {
        Get.dialog(
          ConfirmationDialog(
            title1: S.current.tooLargeVideo,
            title2: AppRes.thisVideoIsGreaterThanEtc,
            onPositiveTap: () {
              Get.back();
              selectVideo(type);
            },
            aspectRatio: 1 / 0.5,
          ),
        );
      }
    });
  }

  void onSelectMedia(int index) {
    Get.back();
    if (index == 1) {
      picker
          .pickImage(
              source: ImageSource.gallery,
              imageQuality: cQualityImage,
              maxHeight: cMaxHeightImage,
              maxWidth: cMaxWidthImage)
          .then((value) {
        if (value == null) return;
        sendMediaSheet(image: value, messageType: 2);
      });
    } else {
      selectVideo(1);
    }
  }

  void sendMediaSheet({required XFile image, required int messageType, XFile? video}) {
    Get.bottomSheet(
            SendMediaSheet(
              image: image.path,
              onSendBtnClick: () => uploadFileGivePathApi(
                  image: image,
                  messageType: messageType,
                  video: video,
                  message: sendMediaController.text.trim()),
              sendMediaController: sendMediaController,
            ),
            isScrollControlled: true)
        .then((value) {
      sendMediaController.clear();
    });
  }

  void uploadFileGivePathApi(
      {required XFile image, required int messageType, XFile? video, String? message}) async {
    Get.back();
    CommonUI.loader();
    if (video != null) {
      ApiService().multiPartCallApi(
        url: UrlRes.uploadFileGivePath,
        filesMap: {
          uUploadFile: [video]
        },
        completion: (response) {
          UploadFile f = UploadFile.fromJson(response);
          if (f.status == true) {
            uploadFile(image: image, messageType: messageType, video: f.data, message: message);
          }
        },
      );
    } else {
      uploadFile(image: image, messageType: messageType, message: message);
    }
  }

  void uploadFile({
    required XFile image,
    required int messageType,
    String? video,
    String? message,
  }) {
    ApiService().multiPartCallApi(
      url: UrlRes.uploadFileGivePath,
      filesMap: {
        uUploadFile: [image]
      },
      completion: (response) {
        Get.back();
        UploadFile f = UploadFile.fromJson(response);
        if (f.status == true) {
          sendFirebaseMessage(
              messageType: messageType,
              imageMessage: f.data,
              message: message,
              videoMessage: video);
        }
      },
    );
  }

  void fetchChatList() async {
    if (!hasMore) {
      return;
    }
    if (isLoading) {
      return;
    }
    isLoading = true;
    update();

    QuerySnapshot<Chat> querySnapshot = await dChatMessage
        .where(FireRes.notDeletedIdentity, arrayContains: savedUser?.id)
        .where(FireRes.timeId, isGreaterThan: deletedId)
        .withConverter(
            fromFirestore: (snapshot, options) => Chat.fromJson(snapshot.data()!),
            toFirestore: (Chat value, options) => value.toJson())
        .orderBy(FireRes.timeId, descending: true)
        .startAfterDocument(lastDocument!)
        .limit(cFirebaseDocumentLimit)
        .get();
    if (querySnapshot.docs.length < cFirebaseDocumentLimit) {
      hasMore = false;
    }
    if (querySnapshot.docs.length.toInt() == 0) {
      return;
    }
    lastDocument = querySnapshot.docs.last;
    chatList.addAll(querySnapshot.docs);
    isLoading = false;
    update();
  }

  // Chat Report And Block

  void onMoreBtnClick(
    int index,
    ChatUser? userData,
  ) {
    int userId = userData?.userID ?? -1;

    if (index == 0) {
      // Report
      if (userData != null) {
        Get.to(
          () => ReportScreen(
            reportUserData: UserData(
              id: userData.userID,
              fullname: userData.name,
              profile: userData.image,
              email: userData.identity,
              userType: userData.userType,
            ),
            reportType: ReportType.user,
          ),
        );
      } else {
        CommonUI.snackBar(title: S.current.userNotFound);
      }
    } else {
      //Block Unblock
      if (userId == -1) {
        CommonUI.snackBar(title: S.current.userIdNotFound);
        return;
      }

      Get.dialog(
        ConfirmationDialog(
          aspectRatio: 2.1,
          positiveText: conversation.iAmBlocked == true ? S.current.unblock : S.current.block,
          title1: AppRes.blockUnblockTitle(
              isBlock: conversation.iAmBlocked == true, name: conversation.user?.name),
          title2: AppRes.blockUnblockMessage(
              isBlock: conversation.iAmBlocked == true, name: conversation.user?.name),
          onPositiveTap: () {
            Get.back();
            List<String> blockId = savedUser?.blockUserIds?.split(',') ?? [];
            String blockUserIds = savedUser?.blockUserIds ?? '';
            if (blockUserIds.isEmpty) {
              blockUserIds = userId.toString();
            } else {
              if (blockId.contains(userId.toString())) {
                blockId.remove(userId.toString());
              } else {
                blockId.add(userId.toString());
              }
              blockUserIds = blockId.join(',');
            }

            CommonUI.loader();
            ApiService().multiPartCallApi(
              url: UrlRes.editProfile,
              filesMap: {},
              param: {
                uUserId: PrefService.id.toString(),
                uBlockUserIds: blockUserIds,
              },
              completion: (response) async {
                Get.back();
                FetchUser result = FetchUser.fromJson(response);
                if (result.status == true) {
                  savedUser = result.data;
                  if ((savedUser?.blockUserIds?.split(',') ?? [])
                      .contains(conversation.user?.userID.toString())) {
                    isBlock = true;
                    blockUnblockUserFirebase(status: true);
                  } else {
                    isBlock = false;
                    blockUnblockUserFirebase(status: false);
                  }
                  update();
                  await prefService.saveUser(result.data);
                  CommonUI.snackBar(
                      title: !isBlock
                          ? AppRes.unblockSnackBarMessage(name: conversation.user?.name)
                          : AppRes.blockSnackBarMessage(name: conversation.user?.name));
                } else {
                  CommonUI.snackBar(title: result.message.toString());
                }
              },
            );
          },
        ),
      );
    }
  }

  void blockUnblockUserFirebase({required bool status}) {
    dSender?.get().then((value) {
      if (value.exists) {
        dSender?.update({FireRes.iAmBlocked: status});
        dReceiver?.update({FireRes.iBlocked: status});
        onUpdateUser?.call(status ? 1 : 0);
      }
    });
  }

  // Chat Delete

  void onLongPressToDeleteChat(Chat? p1) {
    isDeletedMsg = true;
    if (!deletedChatList.contains(p1?.timeId)) {
      deletedChatList.add(p1?.timeId);
    } else {
      deletedChatList.remove(p1?.timeId);
    }
    update();
  }

  void deleteMessageDialog() {
    Get.dialog(
      ConfirmationDialog(
        aspectRatio: 1.9,
        title1: deletedChatList.length == 1
            ? S.current.deleteMessage
            : AppRes.deleteMessages(value: deletedChatList.length.numberFormat),
        title2: AppRes.deleteMessage(value: deletedChatList.length),
        positiveText: S.current.delete,
        onPositiveTap: onDeleteBtnClick,
      ),
    );
  }

  void onDeleteBtnClick() async {
    // for dialog dismiss
    Get.back();
    for (int i = 0; i < deletedChatList.length; i++) {
      chatList.removeWhere((element) => int.parse(element.id) == deletedChatList[i]);
      dChatMessage.doc('${deletedChatList[i]}').update({
        FireRes.notDeletedIdentity: FieldValue.arrayRemove([savedUser?.id])
      });
    }
    isDeletedMsg = false;
    update();
    deletedChatList = [];
  }

  void onDeleteMessageCancel() {
    isDeletedMsg = false;
    deletedChatList = [];
    update();
  }

  // Chat Property Fetch

  void fetchProperty(Function(List<PropertyData>) data) {
    listenPropertyData = data;
  }

  void fetchMyPropertyApiCall() {
    if (!hasMoreProperty) {
      return;
    }
    isPropertyFetching = true;
    ApiService().call(
      url: UrlRes.fetchMyProperties,
      param: {
        uUserId: savedUser?.id.toString(),
        uStart: propertyList.length.toString(),
        uLimit: cPaginationLimit
      },
      completion: (response) {
        FetchSavedProperty data = FetchSavedProperty.fromJson(response);
        if (data.status == true) {
          if ((data.data?.length ?? 0) < int.parse(cPaginationLimit)) {
            hasMoreProperty = false;
          }
          propertyList.addAll(data.data ?? []);
          listenPropertyData?.call(propertyList);
          isPropertyFetching = false;
          update();
        }
      },
    );
  }

  void fetchScrollProperties() {
    propertyScrollController.addListener(
      () {
        if (propertyScrollController.offset >= propertyScrollController.position.maxScrollExtent) {
          if (!isPropertyFetching) {
            fetchMyPropertyApiCall();
          }
        }
      },
    );
  }

  void _loadMoreData() {
    scrollController.addListener(() {
      if (scrollController.offset == scrollController.position.maxScrollExtent) {
        fetchChatList();
      }
    });
  }

  @override
  void onClose() async {
    notificationUserId = '';
    dSender
        ?.withConverter(
          fromFirestore: (snapshot, options) => Conversation.fromJson(snapshot.data()!),
          toFirestore: (Conversation value, options) => value.toJson(),
        )
        .get()
        .then((value) {
      if (value.exists) {
        ChatUser? user = value.data()?.user;
        user?.msgCount = 0;
        dSender?.update(
          {
            FireRes.user.toLowerCase(): user?.toJson(),
          },
        );
      }
    });
    userListener?.cancel();
    chatStream?.cancel();
    super.onClose();
  }
}
