module Test::Compiler::PHP::Operations

import Compiler::PHP::Code;
import Compiler::PHP::Operations;
import Syntax::Abstract::PHP;

test bool shouldCompileToPlusOperation() = implode(toCode(phpPlus())) == "+";
test bool shouldCompileToMinusOperation() = implode(toCode(phpMinus())) == "-";
test bool shouldCompileToBitwiseAndOperation() = implode(toCode(phpBitwiseAnd())) == "&";
test bool shouldCompileToBitwiseOrOperation() = implode(toCode(phpBitwiseOr())) == "|";
test bool shouldCompileToBitwiseXorOperation() = implode(toCode(phpBitwiseXor())) == "^";
test bool shouldCompileToConcatOperation() = implode(toCode(phpConcat())) == ".";
test bool shouldCompileToDivOperation() = implode(toCode(phpDiv())) == "/";
test bool shouldCompileToModOperation() = implode(toCode(phpMod())) == "%";
test bool shouldCompileToMulOperation() = implode(toCode(phpMul())) == "*";
test bool shouldCompileToRightShiftOperation() = implode(toCode(phpRightShift())) == "\>\>";
test bool shouldCompileToLeftShiftOperation() = implode(toCode(phpLeftShift())) == "\<\<";
test bool shouldCompileToBooleanAndOperation() = implode(toCode(phpBooleanAnd())) == "&&";
test bool shouldCompileToBooleanOrOperation() = implode(toCode(phpBooleanOr())) == "||";
test bool shouldCompileToBooleanNotOperation() = implode(toCode(phpBooleanNot())) == "!";
test bool shouldCompileToBitwiseNotOperation() = implode(toCode(phpBitwiseNot())) == "~";
test bool shouldCompileToGtOperation() = implode(toCode(phpGt())) == "\>";
test bool shouldCompileToGeqOperation() = implode(toCode(phpGeq())) == "\>=";
test bool shouldCompileToLogicalAndOperation() = implode(toCode(phpLogicalAnd())) == "and";
test bool shouldCompileToLogicalOrOperation() = implode(toCode(phpLogicalOr())) == "or";
test bool shouldCompileToLogicalXorOperation() = implode(toCode(phpLogicalXor())) == "xor";
test bool shouldCompileToNotEqualOperation() = implode(toCode(phpNotEqual())) == "!=";
test bool shouldCompileToNotIdenticalOperation() = implode(toCode(phpNotIdentical())) == "!==";
test bool shouldCompileToPostDecOperation() = implode(toCode(phpPostDec())) == "--";
test bool shouldCompileToPreDecOperation() = implode(toCode(phpPreDec())) == "--";
test bool shouldCompileToPostIncOperation() = implode(toCode(phpPostInc())) == "++";
test bool shouldCompileToPreIncOperation() = implode(toCode(phpPreInc())) == "++";
test bool shouldCompileToLtOperation() = implode(toCode(phpLt())) == "\<";
test bool shouldCompileToLeqOperation() = implode(toCode(phpLeq())) == "\<=";
test bool shouldCompileToUnaryPlusOperation() = implode(toCode(phpUnaryPlus())) == "+";
test bool shouldCompileToUnaryMinusOperation() = implode(toCode(phpUnaryMinus())) == "-";
test bool shouldCompileToEqualOperation() = implode(toCode(phpEqual())) == "==";
test bool shouldCompileToIdenticalOperation() = implode(toCode(phpIdentical())) == "===";
