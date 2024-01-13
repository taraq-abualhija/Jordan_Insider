import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordan_insider/Controller/NotiCubit/noti_state.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Models/notification.dart';
import 'package:jordan_insider/Shared/network/end_points.dart';
import 'package:jordan_insider/Shared/network/remote/dio_helper.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super(NotificationInitialState());

  static NotificationCubit? _cubit;
  static NotificationCubit getInstans() {
    _cubit ??= NotificationCubit();
    return _cubit!;
  }

  List<NotificationModel> userNoti = [];

  void getAllNotification() {
    emit(GetNotificationLoadingState());
    String uID = UserDataCubit.getInstans().userData!.getId().toString();
    DioHelper.getData(url: GetNotificationsByUserId + uID, query: {})
        .then((value) {
      userNoti.clear();
      for (var element in value.data) {
        userNoti.add(NotificationModel.fromJson(element));
      }
      emit(GetNotificationSuccessState());
    }).catchError((error) {
      emit(GetNotificationErrorState());
    });
  }

  void deleteNotification(int id) {
    emit(DeleteNotificationLoadingState());
    DioHelper.deleteData(url: DeleteNotification + id.toString()).then((value) {
      userNoti.removeWhere((element) => element.getNotificationId() == id);
      emit(DeleteNotificationSuccessState());
    }).catchError((error) {
      emit(DeleteNotificationErrorState());
    });
  }
}
