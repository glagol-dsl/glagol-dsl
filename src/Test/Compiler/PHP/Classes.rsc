module Test::Compiler::PHP::Classes

import Compiler::PHP::Classes;
import Syntax::Abstract::PHP;

test bool shouldCompileBasicClass() =
	toCode(phpClassDef(phpClass("Test", {}, phpNoName(), [], [])), 0) ==
	"\nclass Test \n{}";
	
test bool shouldCompileClassWithModifiers() =
	toCode(phpClassDef(phpClass("Test", {phpAbstract()}, phpNoName(), [], [])), 0) ==
	"\nabstract class Test \n{}";
	
test bool shouldCompileClassWithModifiers() =
	toCode(phpClassDef(phpClass("Luke", {}, phpSomeName(phpName("DarthVader")), [], [])), 0) ==
	"\nclass Luke extends DarthVader \n{}";
	
test bool shouldCompileClassWithOneImplementation() =
	toCode(phpClassDef(phpClass("Test", {}, phpNoName(), [phpName("ArrayAccess")], [])), 0) ==
	"\nclass Test implements ArrayAccess \n{}";
	
test bool shouldCompileClassWithTwoImplementation() =
	toCode(phpClassDef(phpClass("Test", {}, phpNoName(), [phpName("ArrayAccess"), phpName("Iterator")], [])), 0) ==
	"\nclass Test implements ArrayAccess, Iterator \n{}";
	
test bool shouldCompileClassWithMembers() =
	toCode(phpClassDef(phpClass("Test", {}, phpNoName(), [], [phpProperty({phpPrivate()}, [
		phpProperty("id", phpNoExpr())
	])[@phpAnnotations={phpAnnotation("var", phpAnnotationVal("integer"))}]])), 0) ==
	"\nclass Test \n{\n    /**\n     * @var integer\n     */\n    private $id;\n}";
