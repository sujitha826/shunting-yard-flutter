part of 'shunting_yard_bloc.dart';

abstract class ShuntingYardState {}

final class ShuntingYardInitial extends ShuntingYardState {}

final class OnRunState extends ShuntingYardState {
  final double result;
  OnRunState({required this.result});
}

final class ErrorState extends ShuntingYardState {}
