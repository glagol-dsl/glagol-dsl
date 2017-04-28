module Test::Compiler::PHP::CastType

import Compiler::PHP::CastType;
import Syntax::Abstract::PHP;

test bool shouldCompileToTypeCastInt() = toCode(phpInt()) == "int";
test bool shouldCompileToTypeCastBool() = toCode(phpBool()) == "bool";
test bool shouldCompileToTypeCastFloat() = toCode(phpFloat()) == "float";
test bool shouldCompileToTypeCastString() = toCode(phpString()) == "string";
test bool shouldCompileToTypeCastArray() = toCode(phpArray()) == "array";
test bool shouldCompileToTypeCastObject() = toCode(phpObject()) == "object";
test bool shouldCompileToTypeCastUnset() = toCode(phpUnset()) == "unset";
