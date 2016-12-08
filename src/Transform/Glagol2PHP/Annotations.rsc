module Transform::Glagol2PHP::Annotations

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import List;
import IO;

private PhpAnnotation toPhpAnnotation(annotation(str annotationName, list[Annotation] arguments))
    = phpAnnotation(toPhpAnnotationKey(annotationName)) when size(arguments) == 0;

private PhpAnnotation toPhpAnnotation(annotation(str annotationName, list[Annotation] arguments))
    = phpAnnotation(toPhpAnnotationKey(annotationName), toPhpAnnotationArgs(arguments, annotationName)) 
    when size(arguments) > 0;
    
private PhpAnnotation toPhpAnnotationArgs(list[Annotation] arguments, str name) = toPhpAnnotationArgs(arguments);

private PhpAnnotation toPhpAnnotationArgs(list[Annotation] \list) = phpAnnotationVal([convertAnnotationValue(l) | l <- \list]);

private PhpAnnotation toPhpAnnotationArgs(annotationMap(map[str, Annotation] settings)) = phpAnnotationVal((s : convertAnnotationValue(settings[s]) | s <- settings));
    
private PhpAnnotation convertAnnotationValue(annotationVal(annotationMap(\map))) = toPhpAnnotationArgs(annotationMap(\map));
private PhpAnnotation convertAnnotationValue(m: annotationMap(\map)) = toPhpAnnotationArgs(m);
private PhpAnnotation convertAnnotationValue(annotationVal(integer())) = phpAnnotationVal("integer");
private PhpAnnotation convertAnnotationValue(annotationVal(string())) = phpAnnotationVal("string");
private PhpAnnotation convertAnnotationValue(annotationVal(float())) = phpAnnotationVal("float");
private PhpAnnotation convertAnnotationValue(annotationVal(boolean())) = phpAnnotationVal("boolean");
private PhpAnnotation convertAnnotationValue(annotationVal(val)) = phpAnnotationVal(val);

private default str toPhpAnnotationKey(str annotation) = annotation;

public PhpStmt applyAnnotationsOnStmt(phpClassDef(PhpClassDef classDef), list[Annotation] annotations)
    = phpClassDef(classDef[
            @phpAnnotations=((classDef@phpAnnotations?) ? classDef@phpAnnotations : {}) + {toPhpAnnotation(a) | a <- annotations}
        ]
    );

public PhpClassItem applyAnnotationsOnClassItem(PhpClassItem classItem, list[Annotation] annotations)
    = classItem[
            @phpAnnotations=((classItem@phpAnnotations?) ? classItem@phpAnnotations : {}) + {toPhpAnnotation(a) | a <- annotations}
        ];
