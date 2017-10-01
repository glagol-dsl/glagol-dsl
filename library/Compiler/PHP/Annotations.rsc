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

public Code toCode(phpAnnotation(str key), _, int i) = code("<s(i)> * @<key>");
public Code toCode(phpAnnotation("doc", phpAnnotationVal(str desc)), set[PhpAnnotation] annotations, int i) = 
	code("<s(i)> * <desc>") +
	(hasNonDocAnnotations(annotations) ? code(nl()) + code("<s(i)> *") : code());
	
public Code toCode(phpAnnotation("var", phpAnnotationVal(str t)), annotations, int i) = code("<s(i)> * @var <t>");
	
public Code toCode(phpAnnotation(str key, PhpAnnotation v), annotations, int i) = 
	code("<s(i)> * @<key>(<annotationValue(v, annotations, i)>)");
	
public Code toCode(phpAnnotationVal(map[str, PhpAnnotation] options), annotations, int i)
	= code(toString(options, annotations, i));

private str toString(map[str, PhpAnnotation] options, annotations, int i) = 
	glue(["<annotationKey(k)>=<annotationValue(options[k], annotations, i)>" | k <- options], ", ");
	
private str annotationKey(str k) = k;
private str annotationValue(phpAnnotationVal(str s), _, int i) = "\"<s>\"";
private str annotationValue(phpAnnotationVal(int number), _, int i) = "<number>";
private str annotationValue(phpAnnotationVal(real number), _, int i) = "<number>";
private str annotationValue(phpAnnotationVal(true), _, int i) = "true";
private str annotationValue(phpAnnotationVal(false), _, int i) = "false";
private str annotationValue(phpAnnotationVal(list[PhpAnnotation] items), _, int i) = "";
private str annotationValue(phpAnnotationVal(PhpAnnotation v), annotations, int i) = annotationValue(v, annotations, i);
private str annotationValue(a: phpAnnotationVal(map[str, PhpAnnotation] options), annotations, int i) = toString(options, annotations, i);

private bool hasNonDocAnnotations(set[PhpAnnotation] annotations)
	= size([a | a <- annotations, phpAnnotation("doc", _) !:= a]) > 0;
