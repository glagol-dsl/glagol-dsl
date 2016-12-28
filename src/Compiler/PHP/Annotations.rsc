module Compiler::PHP::Annotations

import Syntax::Abstract::PHP;
import Utils::Glue;
import Utils::Indentation;
import Utils::NewLine;
import Set;
import List;

public list[PhpAnnotation] annoSorter(set[PhpAnnotation] annotations) 
	= [a | a <- annotations, phpAnnotation("doc", _) := a] +
	  [a | a <- annotations, phpAnnotation("var", _) := a] +
	  [a | a <- annotations, phpAnnotation(/^((?!(doc|var)).)*$/, _) := a || phpAnnotation(/^((?!(doc|var)).)*$/) := a];

public str toCode(set[PhpAnnotation] annotations, int i) = "" when size(annotations) == 0;
public str toCode(set[PhpAnnotation] annotations, int i) =
	"<nl()><s(i)>/**" + nl() +
	("" | it + toCode(annotation, annotations, i) + nl() | annotation <- annoSorter(annotations)) +
	"<s(i)> */";

public str toCode(phpAnnotation(str key), _, int i) = "<s(i)> * @<key>";
public str toCode(phpAnnotation("doc", phpAnnotationVal(str desc)), set[PhpAnnotation] annotations, int i) = 
	"<s(i)> * <desc><if (hasNonDocAnnotations(annotations)) {><nl()><s(i)> *<}>";
	
public str toCode(phpAnnotation("var", phpAnnotationVal(str t)), annotations, int i) = 
	"<s(i)> * @var <t>";
	
public str toCode(phpAnnotation(str key, PhpAnnotation v), annotations, int i) = 
	"<s(i)> * @<key>(<annotationValue(v, annotations, i)>)";
	
public str toCode(phpAnnotationVal(map[str, PhpAnnotation] options), annotations, int i)
	= glue(["<annotationKey(k)>=<annotationValue(options[k], annotations, i)>" | k <- options], ", ");

private str annotationKey(str k) = k;
private str annotationValue(phpAnnotationVal(str s), _, int i) = "\"<s>\"";
private str annotationValue(phpAnnotationVal(int number), _, int i) = "<number>";
private str annotationValue(phpAnnotationVal(real number), _, int i) = "<number>";
private str annotationValue(phpAnnotationVal(true), _, int i) = "true";
private str annotationValue(phpAnnotationVal(false), _, int i) = "false";
private str annotationValue(phpAnnotationVal(list[PhpAnnotation] items), _, int i) = "";
private str annotationValue(phpAnnotationVal(PhpAnnotation v), annotations, int i) = annotationValue(v, annotations, i);
private str annotationValue(a: phpAnnotationVal(map[str, PhpAnnotation] options), annotations, int i) = toCode(a, annotations, i);

private bool hasNonDocAnnotations(set[PhpAnnotation] annotations)
	= size([a | a <- annotations, phpAnnotation("doc", _) !:= a]) > 0;
