module Transform::Glagol2PHP::Annotations

import Transform::Glagol2PHP::Doctrine::Annotations;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
import List;

public PhpAnnotation toPhpAnnotation(annotation(str annotationName, list[Annotation] arguments), env, context)
    = phpAnnotation(toPhpAnnotationKey(annotationName, env, context)) when size(arguments) == 0;

public PhpAnnotation toPhpAnnotation(annotation(str annotationName, list[Annotation] arguments), env, context)
    = phpAnnotation(toPhpAnnotationKey(annotationName, env, context), 
    	toPhpAnnotation(annotationName, arguments, env, context)) 
    when size(arguments) > 0;
    
public default PhpAnnotation toPhpAnnotation(str name, list[Annotation] arguments, env, context) 
	= toPhpAnnotation(arguments, env, context);

public PhpAnnotation toPhpAnnotation("doc", list[Annotation] arguments, env: <Framework f, _>, context) 
	= toPhpAnnotation(arguments[0], env, context);

public PhpAnnotation toPhpAnnotation(list[Annotation] \list, env, context) 
	= phpAnnotationVal([toPhpAnnotation(l, env, context) | l <- \list]);

public PhpAnnotation toPhpAnnotation(annotationMap(map[str, Annotation] settings), env, context) 
	= phpAnnotationVal((s : toPhpAnnotation(settings[s], env, context) | s <- settings));
    
public PhpAnnotation toPhpAnnotation(annotationVal(annotationMap(\map)), env, context) = toPhpAnnotation(annotationMap(\map), env, context);
public PhpAnnotation toPhpAnnotation(m: annotationMap(\map), env, _) = toPhpAnnotationArgs(m, env);
public PhpAnnotation toPhpAnnotation(annotationVal(integer()), _, _) = phpAnnotationVal("integer");
public PhpAnnotation toPhpAnnotation(annotationVal(string()), _, _) = phpAnnotationVal("string");
public PhpAnnotation toPhpAnnotation(annotationVal(float()), _, _) = phpAnnotationVal("float");
public PhpAnnotation toPhpAnnotation(annotationVal(boolean()), _, _) = phpAnnotationVal("boolean");
public PhpAnnotation toPhpAnnotation(annotationVal(val), _, _) = phpAnnotationVal(val);

public default str toPhpAnnotationKey(str annotation, _, _) = annotation;

public set[PhpAnnotation] toPhpAnnotations(list[Annotation] annotations, env, context) =
	{toPhpAnnotation(a, env, context) | a <- annotations};
	
public set[PhpAnnotation] toPhpAnnotations(Declaration d, env) =
	(d@annotations?) ? toPhpAnnotations(d@annotations, env, d) : {};
	
public set[PhpAnnotation] toPhpAnnotations(Declaration d, env, context) =
	(d@annotations?) ? toPhpAnnotations(d@annotations, env, context) : {};
