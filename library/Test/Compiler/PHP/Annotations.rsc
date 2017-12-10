module Test::Compiler::PHP::Annotations

import Compiler::PHP::Code;
import Compiler::PHP::Annotations;
import Syntax::Abstract::PHP;

test bool shouldReturnEmptyStringOnEmptyAnnotationList() =
	implode(toCode({}, 0)) == "";

test bool shouldCompileDocAnnotationBlock() =
	implode(toCode({phpAnnotation("doc", phpAnnotationVal("This is a doc"))}, 0)) == 
	"\n/**\n * This is a doc\n */";

test bool shouldCompileVarAnnotationBlock() =
	implode(toCode({phpAnnotation("var", phpAnnotationVal("string"))}, 0)) == 
	"\n/**\n * @var string\n */";

test bool shouldCompileMapAnnotationBlock() =
	implode(toCode({phpAnnotation("BLAH", phpAnnotationVal(("key": phpAnnotationVal(true))))}, 0)) == 
	"\n/**\n * @BLAH(key=true)\n */";
	
test bool shouldCompileKeyOnlyAnnotation() = 
	implode(toCode(phpAnnotation("blah"), {}, 0)) == " * @blah";
	
test bool shouldCompileDocAnnotation() = 
	implode(toCode(phpAnnotation("doc", phpAnnotationVal("This is a doc")), {}, 0)) == " * This is a doc";
	
test bool shouldCompileVarAnnotation() = 
	implode(toCode(phpAnnotation("var", phpAnnotationVal("int")), {}, 0)) == " * @var int";

test bool shouldCompileAnnotationWithArgs() = 
	implode(toCode(phpAnnotation("blah", phpAnnotationVal(("key": phpAnnotationVal(false)))), {}, 0)) == " * @blah(key=false)";
