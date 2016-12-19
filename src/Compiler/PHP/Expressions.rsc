module Compiler::PHP::Expressions

import Syntax::Abstract::PHP;

public str toCode(phpScalar(phpClassConstant())) = "__CLASS__";
public str toCode(phpScalar(phpDirConstant())) = "__DIR__";
public str toCode(phpScalar(phpFileConstant())) = "__FILE__";
public str toCode(phpScalar(phpFuncConstant())) = "__FUNCTION__";
public str toCode(phpScalar(phpLineConstant())) = "__LINE__";
public str toCode(phpScalar(phpMethodConstant())) = "__METHOD__";
public str toCode(phpScalar(phpNamespaceConstant())) = "__NAMESPACE__";
public str toCode(phpScalar(phpTraitConstant())) = "__TRAIT__";
public str toCode(phpScalar(phpNull())) = "null";
public str toCode(phpScalar(phpFloat(real realVal))) = "<realVal>";
public str toCode(phpScalar(phpInteger(int intVal))) = "<intVal>";
public str toCode(phpScalar(phpString(str strVal))) = "\"<strVal>\"";
public str toCode(phpScalar(phpBoolean(true))) = "true";
public str toCode(phpScalar(phpBoolean(false))) = "false";

// TODO test
public str toCode(phpNoExpr()) = "";
