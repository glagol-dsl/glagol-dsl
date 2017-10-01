module Compiler::PHP::Operations

import Compiler::PHP::Code;
import Syntax::Abstract::PHP;

public Code toCode(p: phpPlus()) = code("+", p);
public Code toCode(p: phpMinus()) = code("-", p);
public Code toCode(p: phpBitwiseAnd()) = code("&", p);
public Code toCode(p: phpBitwiseOr()) = code("|", p);
public Code toCode(p: phpBitwiseXor()) = code("^", p);
public Code toCode(p: phpConcat()) = code(".", p);
public Code toCode(p: phpDiv()) = code("/", p);
public Code toCode(p: phpMod()) = code("%", p);
public Code toCode(p: phpMul()) = code("*", p);
public Code toCode(p: phpRightShift()) = code("\>\>", p);
public Code toCode(p: phpLeftShift()) = code("\<\<", p);
public Code toCode(p: phpBooleanAnd()) = code("&&", p);
public Code toCode(p: phpBooleanOr()) = code("||", p);
public Code toCode(p: phpBooleanNot()) = code("!", p);
public Code toCode(p: phpBitwiseNot()) = code("~", p);
public Code toCode(p: phpGt()) = code("\>", p);
public Code toCode(p: phpGeq()) = code("\>=", p);
public Code toCode(p: phpLogicalAnd()) = code("and", p);
public Code toCode(p: phpLogicalOr()) = code("or", p);
public Code toCode(p: phpLogicalXor()) = code("xor", p);
public Code toCode(p: phpNotEqual()) = code("!=", p);
public Code toCode(p: phpNotIdentical()) = code("!==", p);
public Code toCode(p: phpPostDec()) = code("--", p);
public Code toCode(p: phpPreDec()) = code("--", p);
public Code toCode(p: phpPostInc()) = code("++", p);
public Code toCode(p: phpPreInc()) = code("++", p);
public Code toCode(p: phpUnaryPlus()) = code("+", p);
public Code toCode(p: phpUnaryMinus()) = code("-", p);
public Code toCode(p: phpLt()) = code("\<", p);
public Code toCode(p: phpLeq()) = code("\<=", p);
public Code toCode(p: phpEqual()) = code("==", p);
public Code toCode(p: phpIdentical()) = code("===", p);
