import 'dart:math';

class ShuntingYard {
  static final Map<String, int> precedence = {
    '+': 1,
    '-': 1,
    '*': 2,
    '/': 2,
    '^': 3,
  };

  static List<String> shuntingYard(String expression) {
    print(expression);
    List<String> output = [];
    List<String> operators = [];
    String currentToken = "";
    int openParenthesesCount = 0;

    for (int i = 0; i < expression.length; i++) {
      final char = expression[i];

      if (isNumeric(char) || char == '.') {
        currentToken += char; // Add to the current token
      } else if (isOperator(char)) {
        // If the current token is not empty, add it to the output
        if (currentToken.isNotEmpty) {
          output.add(currentToken);
          currentToken = "";
        }

        // Handle the operator
        while (operators.isNotEmpty &&
            isOperator(operators.last) &&
            precedence[char]! <= precedence[operators.last]!) {
          output.add(operators.removeLast());
        }
        operators.add(char.toString());
      } else if (char == '(') {
        operators.add(char.toString());
        openParenthesesCount++;
      } else if (char == ')') {
        // If the current token is not empty, add it to the output
        if (currentToken.isNotEmpty) {
          output.add(currentToken);
          currentToken = "";
        }

        while (operators.isNotEmpty && operators.last != '(') {
          output.add(operators.removeLast());
        }
        if (operators.isNotEmpty && operators.last == '(') {
          operators.removeLast(); // Remove the '('
          openParenthesesCount--;
        } else {
          throw Exception("Mismatched parentheses: Too many ')' symbols");
        }
      } else {
        // Unknown character
        throw Exception("Unknown character: $char");
      }
    }

    // Check for mismatched parentheses
    if (openParenthesesCount > 0) {
      throw Exception("Mismatched parentheses: Too many '(' symbols");
    } else if (openParenthesesCount < 0) {
      throw Exception("Mismatched parentheses: Too many ')' symbols");
    }

    // Add the last token to the output if it's not empty
    if (currentToken.isNotEmpty) {
      output.add(currentToken);
    }

    // Add any remaining operators to the output
    while (operators.isNotEmpty) {
      output.add(operators.removeLast());
    }
    print(output);
    return output;
  }

  static double evaluatePostfix(List<String> postfix) {
    List<double> stack = [];

    for (String token in postfix) {
      if (isNumeric(token)) {
        stack.add(double.parse(token));
      } else if (isOperator(token)) {
        if (stack.isEmpty) {
          throw Exception(
              "Invalid expression: Not enough operands for operator $token");
        }

        if (token == '-') {
          // Check if it's a unary minus
          if (stack.length == 1) {
            double operand = stack.removeLast();
            stack.add(-operand); // Negate the single operand
          } else {
            if (stack.length < 2) {
              throw Exception(
                  "Invalid expression: Not enough operands for operator $token");
            }
            double operand2 = stack.removeLast();
            double operand1 = stack.removeLast();
            double result = applyOperator(operand1, operand2, token);
            stack.add(result);
          }
        } else {
          if (stack.length < 2) {
            throw Exception(
                "Invalid expression: Not enough operands for operator $token");
          }
          double operand2 = stack.removeLast();
          double operand1 = stack.removeLast();
          double result = applyOperator(operand1, operand2, token);
          stack.add(result);
        }
      }
    }

    if (stack.length != 1) {
      throw Exception("Invalid expression: Not enough operators");
    }

    return stack.first;
  }

  static bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  static bool isOperator(String str) {
    return precedence.containsKey(str);
  }

// ...

  static double applyOperator(double a, double b, String operator) {
    // print("Operator: $operator");
    switch (operator) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        if (b == 0) throw Exception("Division by zero");
        return a / b;
      case '^':
        return pow(a, b).toDouble();
      default:
        throw Exception("Invalid operator: $operator");
    }
  }
}

// Use cases
// Simple expressions with only numbers and operators (e.g., "2 + 3 * 4").
// Expressions with parentheses (e.g., "(2 + 3) * 4").
// Expressions with negative numbers (e.g., "-2 + 3 * 4").
// Expressions with exponentiation (e.g., "2 ^ 3").