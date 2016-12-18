module Test::Compiler::PHP::Expressions

import Compiler::PHP::Expressions;
import Syntax::Abstract::PHP;

test bool shouldCompileScalarClassConstant() = toCode(phpScalar(phpClassConstant())) == "__CLASS__";
test bool shouldCompileScalarDirConstant() = toCode(phpScalar(phpDirConstant())) == "__DIR__";
test bool shouldCompileScalarFileConstant() = toCode(phpScalar(phpFileConstant())) == "__FILE__";
test bool shouldCompileScalarFuncConstant() = toCode(phpScalar(phpFuncConstant())) == "__FUNCTION__";
test bool shouldCompileScalarLineConstant() = toCode(phpScalar(phpLineConstant())) == "__LINE__";
test bool shouldCompileScalarMethodConstant() = toCode(phpScalar(phpMethodConstant())) == "__METHOD__";
test bool shouldCompileScalarNamespaceConstant() = toCode(phpScalar(phpNamespaceConstant())) == "__NAMESPACE__";
test bool shouldCompileScalarTraitConstant() = toCode(phpScalar(phpTraitConstant())) == "__TRAIT__";
test bool shouldCompileScalarNull() = toCode(phpScalar(phpNull())) == "null";
test bool shouldCompileScalarFloat() = toCode(phpScalar(phpFloat(1.88))) == "1.88";
test bool shouldCompileScalarInteger() = toCode(phpScalar(phpInteger(323))) == "323";
test bool shouldCompileScalarString() = toCode(phpScalar(phpString("haha"))) == "\"haha\"";
test bool shouldCompileScalarBoolean() = toCode(phpScalar(phpBoolean(true))) == "true";
test bool shouldCompileScalarBoolean() = toCode(phpScalar(phpBoolean(false))) == "false";
