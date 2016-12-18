module Transform::Glagol2PHP::Annotations

import Transform::Glagol2PHP::Doctrine::Annotations;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
import List;

public PhpAnnotation toPhpAnnotation(annotation(str annotationName, list[Annotation] arguments), env)
    = phpAnnotation(toPhpAnnotationKey(annotationName, env)) when size(arguments) == 0;

public PhpAnnotation toPhpAnnotation(annotation(str annotationName, list[Annotation] arguments), env)
    = phpAnnotation(toPhpAnnotationKey(annotationName, env), toPhpAnnotation(annotationName, arguments, env)) 
    when size(arguments) > 0;
    
public default PhpAnnotation toPhpAnnotation(str name, list[Annotation] arguments, env) 
	= toPhpAnnotation(arguments, env);

public PhpAnnotation toPhpAnnotation("doc", list[Annotation] arguments, env: <Framework f, _>) 
	= toPhpAnnotation(arguments[0], env);

public PhpAnnotation toPhpAnnotation(list[Annotation] \list, env) 
	= phpAnnotationVal([toPhpAnnotation(l, env) | l <- \list]);

public PhpAnnotation toPhpAnnotation(annotationMap(map[str, Annotation] settings), env) 
	= phpAnnotationVal((s : toPhpAnnotation(settings[s], env) | s <- settings));
    
public PhpAnnotation toPhpAnnotation(annotationVal(annotationMap(\map)), env) = toPhpAnnotation(annotationMap(\map), env);
public PhpAnnotation toPhpAnnotation(m: annotationMap(\map), env) = toPhpAnnotationArgs(m, env);
public PhpAnnotation toPhpAnnotation(annotationVal(integer()), _) = phpAnnotationVal("integer");
public PhpAnnotation toPhpAnnotation(annotationVal(string()), _) = phpAnnotationVal("string");
public PhpAnnotation toPhpAnnotation(annotationVal(float()), _) = phpAnnotationVal("float");
public PhpAnnotation toPhpAnnotation(annotationVal(boolean()), _) = phpAnnotationVal("boolean");
public PhpAnnotation toPhpAnnotation(annotationVal(val), _) = phpAnnotationVal(val);

public default str toPhpAnnotationKey(str annotation, _) = annotation;

public set[PhpAnnotation] toPhpAnnotations(list[Annotation] annotations, env) =
	{toPhpAnnotation(a, env) | a <- annotations};
	
public set[PhpAnnotation] toPhpAnnotations(Declaration d, env) =
	(d@annotations?) ? toPhpAnnotations(d@annotations, env) : {};

public PhpStmt applyAnnotationsOnStmt(phpClassDef(PhpClassDef classDef), list[Annotation] annotations, env)
    = phpClassDef(classDef[
            @phpAnnotations=((classDef@phpAnnotations?) ? classDef@phpAnnotations : {}) + {toPhpAnnotation(a, env) | a <- annotations}
        ]
    );

public PhpClassItem applyAnnotationsOnClassItem(PhpClassItem classItem, list[Annotation] annotations, env)
    = classItem[
        @phpAnnotations=((classItem@phpAnnotations?) ? classItem@phpAnnotations : {}) + {toPhpAnnotation(a, env) | a <- annotations}
    ];
