module Test::Compiler::PHP::Operations

import Compiler::PHP::Operations;
import Syntax::Abstract::PHP;

test bool shouldCompileToPlusOperation() = toCode(phpPlus()) == "+";
test bool shouldCompileToMinusOperation() = toCode(phpMinus()) == "-";
test bool shouldCompileToBitwiseAndOperation() = toCode(phpBitwiseAnd()) == "&";
test bool shouldCompileToBitwiseOrOperation() = toCode(phpBitwiseOr()) == "|";
test bool shouldCompileToBitwiseXorOperation() = toCode(phpBitwiseXor()) == "^";
test bool shouldCompileToConcatOperation() = toCode(phpConcat()) == ".";
test bool shouldCompileToDivOperation() = toCode(phpDiv()) == "/";
test bool shouldCompileToModOperation() = toCode(phpMod()) == "%";
test bool shouldCompileToMulOperation() = toCode(phpMul()) == "*";
test bool shouldCompileToRightShiftOperation() = toCode(phpRightShift()) == "\>\>";
test bool shouldCompileToLeftShiftOperation() = toCode(phpLeftShift()) == "\<\<";
test bool shouldCompileToBooleanAndOperation() = toCode(phpBooleanAnd()) == "&&";
test bool shouldCompileToBooleanOrOperation() = toCode(phpBooleanOr()) == "||";
test bool shouldCompileToBooleanNotOperation() = toCode(phpBooleanNot()) == "!";
test bool shouldCompileToBitwiseNotOperation() = toCode(phpBitwiseNot()) == "~";
test bool shouldCompileToGtOperation() = toCode(phpGt()) == "\>";
test bool shouldCompileToGeqOperation() = toCode(phpGeq()) == "\>=";
test bool shouldCompileToLogicalAndOperation() = toCode(phpLogicalAnd()) == "and";
test bool shouldCompileToLogicalOrOperation() = toCode(phpLogicalOr()) == "or";
test bool shouldCompileToLogicalXorOperation() = toCode(phpLogicalXor()) == "xor";
test bool shouldCompileToNotEqualOperation() = toCode(phpNotEqual()) == "!=";
test bool shouldCompileToNotIdenticalOperation() = toCode(phpNotIdentical()) == "!==";
test bool shouldCompileToPostDecOperation() = toCode(phpPostDec()) == "--";
test bool shouldCompileToPreDecOperation() = toCode(phpPreDec()) == "--";
test bool shouldCompileToPostIncOperation() = toCode(phpPostInc()) == "++";
test bool shouldCompileToPreIncOperation() = toCode(phpPreInc()) == "++";
test bool shouldCompileToLtOperation() = toCode(phpLt()) == "\<";
test bool shouldCompileToLeqOperation() = toCode(phpLeq()) == "\<=";
test bool shouldCompileToUnaryPlusOperation() = toCode(phpUnaryPlus()) == "+";
test bool shouldCompileToUnaryMinusOperation() = toCode(phpUnaryMinus()) == "-";
test bool shouldCompileToEqualOperation() = toCode(phpEqual()) == "==";
test bool shouldCompileToIdenticalOperation() = toCode(phpIdentical()) == "===";
