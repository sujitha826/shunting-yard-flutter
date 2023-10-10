part of 'shunting_yard_bloc.dart';

abstract class ShuntingYardEvent {}

final class OnRunEvent extends ShuntingYardEvent {
  final String exp;
  OnRunEvent({required this.exp});
}
