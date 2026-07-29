import 'package:bloc/bloc.dart';

class ActivitySignalCubit extends Cubit<int> {
  ActivitySignalCubit() : super(0);

  void created() => emit(state + 1);
}
