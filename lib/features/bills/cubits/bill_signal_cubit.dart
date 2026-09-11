import 'package:bloc/bloc.dart';

class BillSignalCubit extends Cubit<int> {
  BillSignalCubit() : super(0);

  void created() => emit(state + 1);
}
