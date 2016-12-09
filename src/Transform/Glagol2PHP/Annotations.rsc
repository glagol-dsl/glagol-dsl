module Transform::Glagol2PHP::Annotations

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
import List;

private PhpAnnotation toPhpAnnotation(annotation(str annotationName, list[Annotation] arguments), env)
    = phpAnnotation(toPhpAnnotationKey(annotationName, env)) when size(arguments) == 0;

private PhpAnnotation toPhpAnnotation(annotation(str annotationName, list[Annotation] arguments), env)
    = phpAnnotation(toPhpAnnotationKey(annotationName, env), toPhpAnnotation(annotationName, arguments, env)) 
    when size(arguments) > 0;
    
private default PhpAnnotation toPhpAnnotation(str name, list[Annotation] arguments, env) = toPhpAnnotation(arguments, env);

private PhpAnnotation toPhpAnnotation(list[Annotation] \list, env) = phpAnnotationVal([toPhpAnnotation(l, env) | l <- \list]);

private PhpAnnotation toPhpAnnotation(annotationMap(map[str, Annotation] settings), env) = phpAnnotationVal((s : toPhpAnnotation(settings[s], env) | s <- settings));
    
private PhpAnnotation toPhpAnnotation(annotationVal(annotationMap(\map)), env) = toPhpAnnotation(annotationMap(\map), env);
private PhpAnnotation toPhpAnnotation(m: annotationMap(\map), env) = toPhpAnnotationArgs(m, env);
private PhpAnnotation toPhpAnnotation(annotationVal(integer()), _) = phpAnnotationVal("integer");
private PhpAnnotation toPhpAnnotation(annotationVal(string()), _) = phpAnnotationVal("string");
private PhpAnnotation toPhpAnnotation(annotationVal(float()), _) = phpAnnotationVal("float");
private PhpAnnotation toPhpAnnotation(annotationVal(boolean()), _) = phpAnnotationVal("boolean");
private PhpAnnotation toPhpAnnotation(annotationVal(val), _) = phpAnnotationVal(val);

private default str toPhpAnnotationKey(str annotation, _) = annotation;

public PhpStmt applyAnnotationsOnStmt(phpClassDef(PhpClassDef classDef), list[Annotation] annotations, env)
    = phpClassDef(classDef[
            @phpAnnotations=((classDef@phpAnnotations?) ? classDef@phpAnnotations : {}) + {toPhpAnnotation(a, env) | a <- annotations}
        ]
    );

public PhpClassItem applyAnnotationsOnClassItem(PhpClassItem classItem, list[Annotation] annotations, env)
    = classItem[
        @phpAnnotations=((classItem@phpAnnotations?) ? classItem@phpAnnotations : {}) + {toPhpAnnotation(a, env) | a <- annotations}
    ];
