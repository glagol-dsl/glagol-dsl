module Test::Compiler::PHP::Modifiers

import Compiler::PHP::Modifiers;
import Syntax::Abstract::PHP;

test bool testModifiersToCode() = 
	"private static public final abstract protected " == 
	toCode({phpPublic(), phpPrivate(), phpProtected(), phpStatic(), phpFinal(), phpAbstract()});

test bool testPublicModifierToCode() = "public" == toCode(phpPublic());
test bool testPrivateModifierToCode() = "private" == toCode(phpPrivate());
test bool testProtectedModifierToCode() = "protected" == toCode(phpProtected());
test bool testStaticModifierToCode() = "static" == toCode(phpStatic());
test bool testFinalModifierToCode() = "final" == toCode(phpFinal());
test bool testAbstractModifierToCode() = "abstract" == toCode(phpAbstract());
