module Compiler::PHP::Annotations

import Syntax::Abstract::PHP;
import Compiler::PHP::Glue;
import Compiler::PHP::Indentation;
import Compiler::PHP::NewLine;

public list[PhpAnnotation] annoSorter(set[PhpAnnotation] annotations) 
	= [a | a <- annotations, phpAnnotation("doc", _) := a] +
	  [a | a <- annotations, phpAnnotation("doc", _) !:= a];
	  
	  
public str toCode(set[PhpAnnotation] annotations, int i) =
	"<s(i)>/**" + nl() +
	("" | it + toCode(annotation, i) + nl() | annotation <- annoSorter(annotations)) +
	"<s(i)> */";

public str toCode(phpAnnotation(str key), int i) = "<s(i)> * @<key>";
public str toCode(phpAnnotation("doc", phpAnnotationVal(str desc)), int i) = "<s(i)> * <desc><nl()><s(i)> *";
public str toCode(phpAnnotation(str key, PhpAnnotation v), int i) = "<s(i)> * @<key>(<annotationValue(v, i)>)";
public str toCode(phpAnnotationVal(map[str, PhpAnnotation] options), int i)
	= glue(["<annotationKey(k)>=<annotationValue(options[k], i)>" | k <- options], ", ");

private str annotationKey(str k) = k;
private str annotationValue(phpAnnotationVal(str s), int i) = "\"<s>\"";
private str annotationValue(phpAnnotationVal(int number), int i) = "<number>";
private str annotationValue(phpAnnotationVal(real number), int i) = "<number>";
private str annotationValue(phpAnnotationVal(true), int i) = "true";
private str annotationValue(phpAnnotationVal(false), int i) = "false";
private str annotationValue(phpAnnotationVal(list[PhpAnnotation] items), int i) = "";
private str annotationValue(phpAnnotationVal(PhpAnnotation v), int i) = annotationValue(v, i);
private str annotationValue(a: phpAnnotationVal(map[str, PhpAnnotation] options), int i) = toCode(a, i);
	  
