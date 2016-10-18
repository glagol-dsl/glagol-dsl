module Transform::Glagol2PHP::Doctrine::Annotations

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

private PhpAnnotation toPhpAnnotation(annotation(str annotationName, list[Annotation] arguments))
    = phpAnnotation(toPhpAnnotationKey(annotationName)) when size(arguments) == 0;

private PhpAnnotation toPhpAnnotation(annotation(str annotationName, list[Annotation] arguments))
    = phpAnnotation(toPhpAnnotationKey(annotationName), toPhpAnnotationArgs(arguments, annotationName)) 
    when size(arguments) > 0;

private PhpAnnotation toPhpAnnotationArgs(list[Annotation] arguments, "table")
    = phpAnnotationVal(("name": convertAnnotationValue(arguments[0])));
    
private PhpAnnotation toPhpAnnotationArgs(list[Annotation] arguments, /field|column/)
    = toPhpAnnotationArgs(arguments[0]) when annotationMap(_) := arguments[0];
    
private PhpAnnotation toPhpAnnotationArgs(annotationMap(map[str, Annotation] settings))
    = phpAnnotationVal((s : convertAnnotationValue(settings[s]) | s <- settings));
    
private PhpAnnotation convertAnnotationValue(annotationVal(annotationMap(\map))) = toPhpAnnotationArgs(annotationMap(\map));
private PhpAnnotation convertAnnotationValue(annotationVal(integer())) = phpAnnotationVal("integer");
private PhpAnnotation convertAnnotationValue(annotationVal(string())) = phpAnnotationVal("string");
private PhpAnnotation convertAnnotationValue(annotationVal(float())) = phpAnnotationVal("float");
private PhpAnnotation convertAnnotationValue(annotationVal(boolean())) = phpAnnotationVal("boolean");
private default PhpAnnotation convertAnnotationValue(annotationVal(val)) = phpAnnotationVal(val);

private str toPhpAnnotationKey("table") = "ORM\\Table";
private str toPhpAnnotationKey("id") = "ORM\\Id";
private str toPhpAnnotationKey("field") = "ORM\\Column";
private str toPhpAnnotationKey("column") = "ORM\\Column";

private PhpStmt applyAnnotationsOnStmt(phpClassDef(PhpClassDef classDef), set[Annotation] annotations)
    = phpClassDef(classDef[
            @phpAnnotations=((classDef@phpAnnotations?) ? classDef@phpAnnotations : {}) + {toPhpAnnotation(a) | a <- annotations}
        ]
    );

private PhpClassItem applyAnnotationsOnClassItem(PhpClassItem classItem, set[Annotation] annotations)
    = classItem[
            @phpAnnotations=((classItem@phpAnnotations?) ? classItem@phpAnnotations : {}) + {toPhpAnnotation(a) | a <- annotations}
        ];
