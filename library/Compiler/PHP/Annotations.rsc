module Compiler::PHP::Annotations

import Compiler::PHP::Code;
import Syntax::Abstract::PHP;
import Utils::Glue;
import Utils::Indentation;
import Utils::NewLine;
import Set;
import List;

private list[PhpAnnotation] annoSorter(set[PhpAnnotation] annotations) 
	= [a | a <- annotations, phpAnnotation("doc", _) := a] +
	  [a | a <- annotations, phpAnnotation("var", _) := a] +
	  [a | a <- annotations, phpAnnotation(/^((?!(doc|var)).)*$/, _) := a || phpAnnotation(/^((?!(doc|var)).)*$/) := a];

public Code toCode(set[PhpAnnotation] annotations, int i) = code() when size(annotations) == 0;
public Code toCode(set[PhpAnnotation] annotations, int i) = 
	code(nl()) + 
	code("<s(i)>/**") + 
	code(nl()) + 
	(code() | it + toCode(annotation, annotations, i) + code(nl()) | annotation <- annoSorter(annotations)) + 
	code("<s(i)> */");

public Code toCode(a: phpAnnotation(str key), set[PhpAnnotation] annotations, int i) = code("<s(i)> * @<key>", a);
public Code toCode(a: phpAnnotation("doc", phpAnnotationVal(str desc)), set[PhpAnnotation] annotations, int i) = 
	code("<s(i)> * <desc>", a) +
	(hasNonDocAnnotations(annotations) ? code(nl()) + code("<s(i)> *") : code());
	
public Code toCode(a: phpAnnotation("var", phpAnnotationVal(str t)), set[PhpAnnotation] annotations, int i) = code("<s(i)> * @var <t>", a);
	
public Code toCode(a: phpAnnotation(str key, PhpAnnotation v), set[PhpAnnotation] annotations, int i) = 
	code("<s(i)> * @<key>(<annotationValue(v, annotations, i)>)", a);
	
public Code toCode(a: phpAnnotationVal(map[str, PhpAnnotation] options), set[PhpAnnotation] annotations, int i)
	= code(toString(options, annotations, i), a);

private str toString(map[str, PhpAnnotation] options, set[PhpAnnotation] annotations, int i) = 
	glue(["<annotationKey(k)>=<annotationValue(options[k], annotations, i)>" | k <- options], ", ");
	
private str annotationKey(str k) = k;
private str annotationValue(phpAnnotationVal(str s), set[PhpAnnotation] annotations, int i) = "\"<s>\"";
private str annotationValue(phpAnnotationVal(int number), set[PhpAnnotation] annotations, int i) = "<number>";
private str annotationValue(phpAnnotationVal(real number), set[PhpAnnotation] annotations, int i) = "<number>";
private str annotationValue(phpAnnotationVal(true), set[PhpAnnotation] annotations, int i) = "true";
private str annotationValue(phpAnnotationVal(false), set[PhpAnnotation] annotations, int i) = "false";
private str annotationValue(phpAnnotationVal(list[PhpAnnotation] items), set[PhpAnnotation] annotations, int i) = "";
private str annotationValue(phpAnnotationVal(PhpAnnotation v), set[PhpAnnotation] annotations, int i) = annotationValue(v, annotations, i);
private str annotationValue(a: phpAnnotationVal(map[str, PhpAnnotation] options), set[PhpAnnotation] annotations, int i) = toString(options, annotations, i);

private bool hasNonDocAnnotations(set[PhpAnnotation] annotations)
	= size([a | a <- annotations, phpAnnotation("doc", _) !:= a]) > 0;
