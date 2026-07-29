import 'package:bloc/bloc.dart';

class AccountSignalCubit extends Cubit<int> {
  AccountSignalCubit() : super(0);

  void created() => emit(state + 1);
}
