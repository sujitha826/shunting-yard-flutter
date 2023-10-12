import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shunting_yard_flutter/models/shunting_yard.dart';
import 'package:shunting_yard_flutter/constants/app_constants.dart';
// import 'package:shunting_yard_flutter/bloc/shunting_yard_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? expression;
  double? result;
  bool error = false;
  String? errMsg;
  RegExp pattern = RegExp(r'(\d+(\.\d+)?)|([+\-*/()^])');

  void _convertAndEvaluate() {
    try {
      List<String> postfixExpression =
          ShuntingYard.shuntingYard(_controller.text.trim());
      // print("Postfix Expression: ${postfixExpression.join(' ')}");
      setState(() {
        result = ShuntingYard.evaluatePostfix(postfixExpression);
        error = false;
        errMsg = null;
        expression = _controller.text;
      });
      print("Result: $result");
    } catch (e) {
      setState(() {
        error = true;
        errMsg = e.toString();
        result = null;
        expression = '';
      });
    }
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _resetFields() {
    setState(() {
      error = false;
      errMsg = null;
      expression = '';
      result = null;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TextConstants.appTitle,
        ),
        backgroundColor: const Color.fromARGB(96, 104, 58, 183),
        foregroundColor: const Color.fromARGB(255, 185, 27, 27),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ElevatedButton(
                    onPressed: _convertAndEvaluate,
                    child: Text(
                      TextConstants.run,
                      style: const TextStyle(
                          fontSize: 18, color: Colors.deepPurple),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                  ),
                  child: ElevatedButton(
                    onPressed: _resetFields,
                    child: Text(
                      TextConstants.reset,
                      style: const TextStyle(
                          fontSize: 18, color: Colors.deepPurple),
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
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Text(
                  TextConstants.result,
                  style: const TextStyle(
                    fontSize: 22,
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
      labelText: TextConstants.enterExpression,
    );
  }
}
