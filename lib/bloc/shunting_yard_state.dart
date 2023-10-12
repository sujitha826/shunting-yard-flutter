part of 'shunting_yard_bloc.dart';

abstract class ShuntingYardState {}

final class ShuntingYardInitial extends ShuntingYardState {}

final class OnRunState extends ShuntingYardState {
  final double result;
  final String exp;
  OnRunState({required this.result, required this.exp});
}

final class ErrorState extends ShuntingYardState {
  final String? errMsg;
  ErrorState({this.errMsg});
}
