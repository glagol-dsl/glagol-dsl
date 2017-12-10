module Test::Compiler::PHP::CastType

import Compiler::PHP::Code;
import Compiler::PHP::CastType;
import Syntax::Abstract::PHP;

test bool shouldCompileToTypeCastInt() = implode(toCode(phpInt())) == "int";
test bool shouldCompileToTypeCastBool() = implode(toCode(phpBool())) == "bool";
test bool shouldCompileToTypeCastFloat() = implode(toCode(phpFloat())) == "float";
test bool shouldCompileToTypeCastString() = implode(toCode(phpString())) == "string";
test bool shouldCompileToTypeCastArray() = implode(toCode(phpArray())) == "array";
test bool shouldCompileToTypeCastObject() = implode(toCode(phpObject())) == "object";
test bool shouldCompileToTypeCastUnset() = implode(toCode(phpUnset())) == "unset";
