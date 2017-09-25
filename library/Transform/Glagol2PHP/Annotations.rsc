module Transform::Glagol2PHP::Annotations

import Transform::Env;
import Transform::Glagol2PHP::Doctrine::Annotations;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;
import List;
import Map;

public PhpAnnotation toPhpAnnotation(annotation(str annotationName, list[Annotation] arguments), TransformEnv env)
    = phpAnnotation(toPhpAnnotationKey(annotationName, env)) when size(arguments) == 0;

public PhpAnnotation toPhpAnnotation(annotation(str annotationName, list[Annotation] arguments), TransformEnv env)
    = phpAnnotation(toPhpAnnotationKey(annotationName, env), toPhpAnnotation(annotationName, arguments, env)) 
    when size(arguments) > 0;
    
public default PhpAnnotation toPhpAnnotation(str name, list[Annotation] arguments, TransformEnv env) 
	= toPhpAnnotation(arguments, env);

public PhpAnnotation toPhpAnnotation("doc", list[Annotation] arguments, TransformEnv env) 
	= toPhpAnnotation(arguments[0], env);

public PhpAnnotation toPhpAnnotation(list[Annotation] \list, TransformEnv env) 
	= phpAnnotationVal([toPhpAnnotation(l, env) | l <- \list]);

public PhpAnnotation toPhpAnnotation(annotationMap(map[str, Annotation] settings), TransformEnv env) 
	= phpAnnotationVal((s : toPhpAnnotation(settings[s], env) | s <- settings));
    
public PhpAnnotation toPhpAnnotation(annotationVal(annotationMap(map[str, Annotation] \map)), TransformEnv env) = toPhpAnnotation(annotationMap(\map), env);
public PhpAnnotation toPhpAnnotation(annotationVal(integer()), TransformEnv env) = phpAnnotationVal("integer");
public PhpAnnotation toPhpAnnotation(annotationVal(string()), TransformEnv env) = phpAnnotationVal("string");
public PhpAnnotation toPhpAnnotation(annotationVal(float()), TransformEnv env) = phpAnnotationVal("float");
public PhpAnnotation toPhpAnnotation(annotationVal(boolean()), TransformEnv env) = phpAnnotationVal("boolean");
public PhpAnnotation toPhpAnnotation(annotationVal(val), TransformEnv env) = phpAnnotationVal(val);

public default str toPhpAnnotationKey(str annotation, TransformEnv env) = annotation;

public set[PhpAnnotation] toPhpAnnotations(list[Annotation] annotations, TransformEnv env) = 
    {toPhpAnnotation(a, env) | a <- annotations};

public set[PhpAnnotation] toPhpAnnotations(Declaration d, TransformEnv env) =
	((d@annotations?) ? toPhpAnnotations(d@annotations, env) : {});
