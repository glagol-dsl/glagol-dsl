module Transform::Glagol2PHP::Doctrine::Annotations

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

private PhpAnnotation toDoctrineAnnotation(annotation(str annotationName, list[Annotation] arguments))
    = phpAnnotation(toDoctrineAnnotationKey(annotationName)) when size(arguments) == 0;

private PhpAnnotation toDoctrineAnnotation(annotation(str annotationName, list[Annotation] arguments))
    = phpAnnotation(toDoctrineAnnotationKey(annotationName), toDoctrineAnnotationArgs(arguments, annotationName)) 
    when size(arguments) > 0;

private map[str,value] toDoctrineAnnotationArgs(list[Annotation] arguments, "table")
    = ("name": convertAnnotationValue(arguments[0]));
    
private map[str,value] toDoctrineAnnotationArgs(list[Annotation] arguments, /field|column/)
    = toDoctrineAnnotationArgs(arguments[0]) when annotationMap(_) := arguments[0];
    
private map[str,value] toDoctrineAnnotationArgs(annotationMap(map[str, Annotation] settings))
    = (s : convertAnnotationValue(settings[s]) | s <- settings);
    
private value convertAnnotationValue(annotationVal(list[Annotation] listValue)) 
    = [convertAnnotationValue(l) | l <- listValue];
private value convertAnnotationValue(annotationVal(str strValue)) = strValue;
private value convertAnnotationValue(annotationVal(bool boolValue)) = boolValue;
private value convertAnnotationValue(annotationVal(int intValue)) = intValue;
private value convertAnnotationValue(annotationVal(real floatValue)) = floatValue;
private value convertAnnotationValue(annotationVal(annotationMap(\map))) = toDoctrineAnnotationArgs(annotationMap(\map));
private value convertAnnotationValue(annotationVal(integer())) = "integer";
private value convertAnnotationValue(annotationVal(string())) = "string";
private value convertAnnotationValue(annotationVal(float())) = "float";
private value convertAnnotationValue(annotationVal(boolean())) = "boolean";

private str toDoctrineAnnotationKey("table") = "ORM\\Table";
private str toDoctrineAnnotationKey("id") = "ORM\\Id";
private str toDoctrineAnnotationKey("field") = "ORM\\Column";
private str toDoctrineAnnotationKey("column") = "ORM\\Column";

private PhpStmt applyAnnotationsOnStmt(phpClassDef(PhpClassDef classDef), set[Annotation] annotations)
    = phpClassDef(classDef[
            @phpAnnotations=((classDef@phpAnnotations?) ? classDef@phpAnnotations : {}) + {toDoctrineAnnotation(a) | a <- annotations}
        ]
    );

private PhpClassItem applyAnnotationsOnClassItem(PhpClassItem classItem, set[Annotation] annotations)
    = classItem[
            @phpAnnotations=((classItem@phpAnnotations?) ? classItem@phpAnnotations : {}) + {toDoctrineAnnotation(a) | a <- annotations}
        ];
