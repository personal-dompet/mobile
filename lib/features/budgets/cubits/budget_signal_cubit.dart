import 'package:bloc/bloc.dart';

class BudgetSignalCubit extends Cubit<int> {
  BudgetSignalCubit() : super(0);

  void created() => emit(state + 1);
}
