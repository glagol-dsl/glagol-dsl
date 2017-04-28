module Compiler::PHP::Operations

import Syntax::Abstract::PHP;
               
public str toCode(phpPlus()) = "+";
public str toCode(phpMinus()) = "-";
public str toCode(phpBitwiseAnd()) = "&";
public str toCode(phpBitwiseOr()) = "|";
public str toCode(phpBitwiseXor()) = "^";
public str toCode(phpConcat()) = ".";
public str toCode(phpDiv()) = "/";
public str toCode(phpMod()) = "%";
public str toCode(phpMul()) = "*";
public str toCode(phpRightShift()) = "\>\>";
public str toCode(phpLeftShift()) = "\<\<";
public str toCode(phpBooleanAnd()) = "&&";
public str toCode(phpBooleanOr()) = "||";
public str toCode(phpBooleanNot()) = "!";
public str toCode(phpBitwiseNot()) = "~";
public str toCode(phpGt()) = "\>";
public str toCode(phpGeq()) = "\>=";
public str toCode(phpLogicalAnd()) = "and";
public str toCode(phpLogicalOr()) = "or";
public str toCode(phpLogicalXor()) = "xor";
public str toCode(phpNotEqual()) = "!=";
public str toCode(phpNotIdentical()) = "!==";
public str toCode(phpPostDec()) = "--";
public str toCode(phpPreDec()) = "--";
public str toCode(phpPostInc()) = "++";
public str toCode(phpPreInc()) = "++";
public str toCode(phpUnaryPlus()) = "+";
public str toCode(phpUnaryMinus()) = "-";
public str toCode(phpLt()) = "\<";
public str toCode(phpLeq()) = "\<=";
public str toCode(phpEqual()) = "==";
public str toCode(phpIdentical()) = "===";
