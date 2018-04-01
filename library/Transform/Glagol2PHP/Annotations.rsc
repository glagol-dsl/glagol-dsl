module Transform::Glagol2PHP::Annotations

import Transform::Env;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;
import Transform::OriginAnnotator;
import List;
import Map;

public PhpAnnotation toPhpAnnotation("table", list[Annotation] arguments, TransformEnv env)
    = origin(phpAnnotationVal(("name": toPhpAnnotation(arguments[0], env))), getContext(env)) when usesDoctrine(env) && isInEntity(env);
    
public PhpAnnotation toPhpAnnotation("column", list[Annotation] arguments, TransformEnv env)
    = toPhpAnnotation(arguments[0], env) when annotationMap(_) := arguments[0] && usesDoctrine(env) && isInEntity(env);
    
public PhpAnnotation toPhpAnnotation("field", list[Annotation] arguments, TransformEnv env) = 
	toPhpAnnotation("column", arguments, env) when usesDoctrine(env) && isInEntity(env);

public PhpAnnotation toPhpAnnotation(a: annotation(str annotationName, list[Annotation] arguments), TransformEnv env)
    = origin(phpAnnotation(toPhpAnnotationKey(annotationName, env)), a) when size(arguments) == 0;

public PhpAnnotation toPhpAnnotation(a: annotation(str annotationName, list[Annotation] arguments), TransformEnv env)
    = origin(phpAnnotation(toPhpAnnotationKey(annotationName, env), toPhpAnnotation(annotationName, arguments, env)), a)
    when size(arguments) > 0;
    
public default PhpAnnotation toPhpAnnotation(str name, list[Annotation] arguments, TransformEnv env) 
	= toPhpAnnotation(arguments, env);

public PhpAnnotation toPhpAnnotation("doc", list[Annotation] arguments, TransformEnv env) 
	= toPhpAnnotation(arguments[0], env);

public PhpAnnotation toPhpAnnotation(list[Annotation] \list, TransformEnv env) 
	= origin(phpAnnotationVal([toPhpAnnotation(l, env) | l <- \list]), \list[0]);

public PhpAnnotation toPhpAnnotation(a: annotationMap(map[str, Annotation] settings), TransformEnv env) 
	= origin(phpAnnotationVal((s : toPhpAnnotation(settings[s], env) | s <- settings)), a);
    
public PhpAnnotation toPhpAnnotation(annotationVal(a: annotationMap(map[str, Annotation] \map)), TransformEnv env) = 
	toPhpAnnotation(origin(annotationMap(\map), a), env);
public PhpAnnotation toPhpAnnotation(a: annotationVal(integer()), TransformEnv env) = origin(phpAnnotationVal("integer"), a);
public PhpAnnotation toPhpAnnotation(a: annotationVal(string()), TransformEnv env) = origin(phpAnnotationVal("string"), a);
public PhpAnnotation toPhpAnnotation(a: annotationVal(float()), TransformEnv env) = origin(phpAnnotationVal("float"), a);
public PhpAnnotation toPhpAnnotation(a: annotationVal(boolean()), TransformEnv env) = origin(phpAnnotationVal("boolean"), a);
public PhpAnnotation toPhpAnnotation(a: annotationVal(val), TransformEnv env) = origin(phpAnnotationVal(val), a);

public str toPhpAnnotationKey("sequence", TransformEnv env) = "ORM\\GeneratedValue" when usesDoctrine(env) && isInEntity(env);
public str toPhpAnnotationKey("table", TransformEnv env) = "ORM\\Table" when usesDoctrine(env) && isInEntity(env);
public str toPhpAnnotationKey("id", TransformEnv env) = "ORM\\Id" when usesDoctrine(env) && isInEntity(env);
public str toPhpAnnotationKey("field", TransformEnv env) = "ORM\\Column" when usesDoctrine(env) && isInEntity(env);
public str toPhpAnnotationKey("column", TransformEnv env) = "ORM\\Column" when usesDoctrine(env) && isInEntity(env);
public default str toPhpAnnotationKey(str annotation, TransformEnv env) = annotation;

public set[PhpAnnotation] toPhpAnnotations(list[Annotation] annotations, TransformEnv env) = 
    {toPhpAnnotation(a, env) | a <- annotations};

public set[PhpAnnotation] toPhpAnnotations(Declaration d, TransformEnv env) =
	((d@annotations?) ? toPhpAnnotations(d@annotations, env) : {});
