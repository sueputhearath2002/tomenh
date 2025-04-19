import 'package:tomnenh/datas/datasource/remote_response.dart';

abstract class RemoteDataSource {
  //organization
  // Future<ApiResponse> getOrganization({required String url});
  // //login
  Future<ApiResponse> login({Map? params});
  Future<ApiResponse> register({Map? params});
  //
  // //user
  // Future<ApiResponse> getUserProfile({Map? params});
  // Future<ApiResponse> updateUserInfo({Map? params, XFile? file});
  // Future<ApiResponse> changeLanguage({Map? params});
  // Future<ApiResponse> changePassword({Map? params});
  // Future<ApiResponse> checkUserForgotPasswordScreen({Map? params});
  // Future<ApiResponse> fotgotPassword({Map? params});
  //
  // //notification
  // Future<ApiResponse> getNotification({Map? params});
  //
  // //chat
  // Future<ApiResponse> getConversations({Map? frmDatas});
  // Future<ApiResponse> getConversation({Map? frmDatas});
  // Future<ApiResponse> conversation({
  //   Map? frmDatas,
  //   List<XFile>? filePath,
  //   File? file,
  // });
  //
  // //order
  // Future<ApiResponse> getOrderDetail({Map? frmDatas});
  // Future<ApiResponse> getDirection({Map? frmDatas});
  // Future<ApiResponse> getRecentOrder({Map? params});
  // Future<ApiResponse> rejectOrder({Map? params});
  // Future<ApiResponse> confirmOrder({Map? params});
  // Future<ApiResponse> orderHistory({Map? params});
  // Future<ApiResponse> totalPendingAndCompleted({Map? params});
  // Future<ApiResponse> completeOrder({Map? params});
  //
  // //otp
  // Future<ApiResponse> getOtpCode({Map? frmDatas});
  // Future<ApiResponse> verifyOtpCode({Map? frmDatas});
  //
  // //open file
  // Future<ApiResponse> onOpenFile({required Map arg});
}
