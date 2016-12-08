module Transform::Glagol2PHP::Annotations

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import List;
import IO;

private PhpAnnotation toPhpAnnotation(annotation(str annotationName, list[Annotation] arguments))
    = phpAnnotation(toPhpAnnotationKey(annotationName)) when size(arguments) == 0;

private PhpAnnotation toPhpAnnotation(annotation(str annotationName, list[Annotation] arguments))
    = phpAnnotation(toPhpAnnotationKey(annotationName), toPhpAnnotation(annotationName, arguments)) 
    when size(arguments) > 0;
    
private default PhpAnnotation toPhpAnnotation(str name, list[Annotation] arguments) = toPhpAnnotation(arguments);

private PhpAnnotation toPhpAnnotation(list[Annotation] \list) = phpAnnotationVal([toPhpAnnotation(l) | l <- \list]);

private PhpAnnotation toPhpAnnotation(annotationMap(map[str, Annotation] settings)) = phpAnnotationVal((s : toPhpAnnotation(settings[s]) | s <- settings));
    
private PhpAnnotation toPhpAnnotation(annotationVal(annotationMap(\map))) = toPhpAnnotation(annotationMap(\map));
private PhpAnnotation toPhpAnnotation(m: annotationMap(\map)) = toPhpAnnotationArgs(m);
private PhpAnnotation toPhpAnnotation(annotationVal(integer())) = phpAnnotationVal("integer");
private PhpAnnotation toPhpAnnotation(annotationVal(string())) = phpAnnotationVal("string");
private PhpAnnotation toPhpAnnotation(annotationVal(float())) = phpAnnotationVal("float");
private PhpAnnotation toPhpAnnotation(annotationVal(boolean())) = phpAnnotationVal("boolean");
private PhpAnnotation toPhpAnnotation(annotationVal(val)) = phpAnnotationVal(val);

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
