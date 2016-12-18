module Test::Compiler::PHP::Annotations

import Compiler::PHP::Annotations;
import Syntax::Abstract::PHP;

test bool shouldReturnEmptyStringOnEmptyAnnotationList() =
	toCode({}, 0) == "";

test bool shouldCompileDocAnnotationBlock() =
	toCode({phpAnnotation("doc", phpAnnotationVal("This is a doc"))}, 0) == 
	"\n/**\n * This is a doc\n */";

test bool shouldCompileVarAnnotationBlock() =
	toCode({phpAnnotation("var", phpAnnotationVal("string"))}, 0) == 
	"\n/**\n * @var string\n */";

test bool shouldCompileMapAnnotationBlock() =
	toCode({phpAnnotation("BLAH", phpAnnotationVal(("key": phpAnnotationVal(true))))}, 0) == 
	"\n/**\n * @BLAH(key=true)\n */";
	
test bool shouldCompileKeyOnlyAnnotation() = 
	toCode(phpAnnotation("blah"), {}, 0) == " * @blah";
	
test bool shouldCompileDocAnnotation() = 
	toCode(phpAnnotation("doc", phpAnnotationVal("This is a doc")), {}, 0) == " * This is a doc";
	
test bool shouldCompileVarAnnotation() = 
	toCode(phpAnnotation("var", phpAnnotationVal("int")), {}, 0) == " * @var int";

test bool shouldCompileAnnotationWithArgs() = 
	toCode(phpAnnotation("blah", phpAnnotationVal(("key": phpAnnotationVal(false)))), {}, 0) == " * @blah(key=false)";
