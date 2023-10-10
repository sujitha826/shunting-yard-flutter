import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shunting_yard_flutter/models/shunting_yard.dart';

part 'shunting_yard_event.dart';
part 'shunting_yard_state.dart';

class ShuntingYardBloc extends Bloc<ShuntingYardEvent, ShuntingYardState> {
  ShuntingYardBloc() : super(ShuntingYardInitial()) {
   // on<OnRunEvent>(onRunEvent);
  }

}
