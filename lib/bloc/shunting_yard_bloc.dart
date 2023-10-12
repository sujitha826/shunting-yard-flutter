import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shunting_yard_flutter/models/shunting_yard.dart';

part 'shunting_yard_event.dart';
part 'shunting_yard_state.dart';

class ShuntingYardBloc extends Bloc<ShuntingYardEvent, ShuntingYardState> {
  ShuntingYardBloc() : super(ShuntingYardInitial()) {
    on<OnRunEvent>((event, emit) {
      try {
        List<String> postfixExpression = ShuntingYard.shuntingYard(event.exp);
        final result = ShuntingYard.evaluatePostfix(postfixExpression);
        emit(OnRunState(result: result, exp: event.exp));
      } catch (e) {
        emit(ErrorState(errMsg: e.toString()));
      }
    });

    on<ResetEvent>((event, emit) {
      emit(ShuntingYardInitial());
    });
  }
}
