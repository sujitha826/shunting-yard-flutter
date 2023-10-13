import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shunting_yard_flutter/constants/app_constants.dart';
import 'package:shunting_yard_flutter/bloc/shunting_yard_bloc.dart';
import 'package:shunting_yard_flutter/screens/app_utils.dart';

class HomeBlocScreen extends StatefulWidget {
  const HomeBlocScreen({super.key});

  @override
  State<HomeBlocScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeBlocScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? expression;
  double? result;
  bool error = false;
  String? errMsg;
  RegExp pattern = RegExp(r'(\d+(\.\d+)?)|([+\-*/()^])');

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShuntingYardBloc(),
      child: Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          title: Text(
            TextConstants.appTitle,
            style: const TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
          ),
          backgroundColor: const Color.fromARGB(96, 104, 58, 183),
          foregroundColor: const Color.fromARGB(255, 73, 19, 19),
        ),
        body: BlocConsumer<ShuntingYardBloc, ShuntingYardState>(
          listener: (context, state) {
            if (state is OnRunState) {
              result = state.result;
              error = false;
              expression = state.exp;
            }
            if (state is ErrorState) {
              error = true;
              errMsg = state.errMsg ?? "Invalid Format";
              expression = '';
              result = null;
            }
            if (state is ShuntingYardInitial) {
              error = false;
              expression = '';
              result = null;
            }
          },
          builder: (context, state) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    inputFormatters: const [],
                    decoration: _buildInputDecoration(),
                    onChanged: _handleInputChange,
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<ShuntingYardBloc>().add(
                                  OnRunEvent(exp: _controller.text.trim()),
                                );
                            _controller.clear();
                            FocusScope.of(context).unfocus();
                          },
                          child: Text(
                            TextConstants.run,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 15,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<ShuntingYardBloc>().add(ResetEvent());
                            _controller.clear();
                          },
                          child: Text(
                            TextConstants.reset,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Text(
                        TextConstants.infix,
                        style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Text(
                        expression ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                    children: [
                      Text(
                        TextConstants.result,
                        style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Text(
                        '${result ?? ''}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 96, 230, 103),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleInputChange(value) {
    setState(() {
      // Check the format of the text as the user types
      if (value.isNotEmpty &&
          pattern.hasMatch(value.trim()) &&
          !"+*/^".contains(value[0])) {
        error = false;
        errMsg = null;
      } else {
        error = true;
        errMsg = "Invalid Format";
      }
    });
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      errorText: error ? errMsg : null,
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 65, 33, 243),
        ),
      ),
      border: const OutlineInputBorder(),
      isDense: true,
      labelText: TextConstants.enterExpression,
    );
  }
}
