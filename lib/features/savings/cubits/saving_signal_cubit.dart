import 'package:bloc/bloc.dart';

class SavingSignalCubit extends Cubit<int> {
  SavingSignalCubit() : super(0);

  void created() => emit(state + 1);
}
