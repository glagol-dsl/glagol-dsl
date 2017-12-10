module Test::Compiler::PHP::Modifiers

import Compiler::PHP::Code;
import Compiler::PHP::Modifiers;
import Syntax::Abstract::PHP;

test bool testModifiersToCode() = 
	"private static public final abstract protected " == 
	implode(toCode({phpPublic(), phpPrivate(), phpProtected(), phpStatic(), phpFinal(), phpAbstract()}));

test bool testPublicModifierToCode() = "public" == implode(toCode(phpPublic()));
test bool testPrivateModifierToCode() = "private" == implode(toCode(phpPrivate()));
test bool testProtectedModifierToCode() = "protected" == implode(toCode(phpProtected()));
test bool testStaticModifierToCode() = "static" == implode(toCode(phpStatic()));
test bool testFinalModifierToCode() = "final" == implode(toCode(phpFinal()));
test bool testAbstractModifierToCode() = "abstract" == implode(toCode(phpAbstract()));
