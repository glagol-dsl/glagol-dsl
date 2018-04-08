module Transform::Glagol2PHP::Annotations

import Transform::Env;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;
import Transform::OriginAnnotator;
import List;
import Map;

private list[str] PROCESSABLE_KEYS = ["sequence", "id", "field", "column", "table", "doc"];

public PhpAnnotation toPhpAnnotation("table", list[Annotation] arguments, Declaration d, TransformEnv env)
    = origin(phpAnnotationVal(("name": toPhpAnnotation(arguments[0], d, env))), getContext(env)) when usesDoctrine(env) && isInEntity(env);
    
public PhpAnnotation toPhpAnnotation("column", list[Annotation] arguments, Declaration d, TransformEnv env)
    = toPhpAnnotation(arguments[0], d, env) when annotationMap(_) := arguments[0] && usesDoctrine(env) && isInEntity(env);
    
public PhpAnnotation toPhpAnnotation("field", list[Annotation] arguments, Declaration d, TransformEnv env) = 
	toPhpAnnotation("column", arguments, d, env) when usesDoctrine(env) && isInEntity(env);

public PhpAnnotation toPhpAnnotation(a: annotation(str annotationName, list[Annotation] arguments), Declaration d, TransformEnv env)
    = origin(phpAnnotation(toPhpAnnotationKey(annotationName, env)), a) when size(arguments) == 0;

public PhpAnnotation toPhpAnnotation(a: annotation(str annotationName, list[Annotation] arguments), Declaration d, TransformEnv env)
    = origin(phpAnnotation(toPhpAnnotationKey(annotationName, env), toPhpAnnotation(annotationName, arguments, d, env)), a)
    when size(arguments) > 0;

public PhpAnnotation toPhpAnnotation("doc", list[Annotation] arguments, Declaration d, TransformEnv env) 
	= toPhpAnnotation(arguments[0], d, env);

public default PhpAnnotation toPhpAnnotation(str name, list[Annotation] arguments, Declaration d, TransformEnv env) 
	= toPhpAnnotation(arguments, d, env);
	
public PhpAnnotation toPhpAnnotation(list[Annotation] \list, Declaration d, TransformEnv env) 
	= origin(phpAnnotationVal([toPhpAnnotation(l, d, env) | l <- \list]), \list[0]);

public PhpAnnotation toPhpAnnotation(a: annotationMap(map[str, Annotation] settings), Declaration d, TransformEnv env) 
	= origin(phpAnnotationVal((s : toPhpAnnotation(settings[s], d, env) | s <- settings)), a);
    
public PhpAnnotation toPhpAnnotation(annotationVal(a: annotationMap(map[str, Annotation] \map)), Declaration d, TransformEnv env) = 
	toPhpAnnotation(origin(annotationMap(\map), a), d, env);
public PhpAnnotation toPhpAnnotation(a: annotationVal(integer()), Declaration d, TransformEnv env) = origin(phpAnnotationVal("integer"), a);
public PhpAnnotation toPhpAnnotation(a: annotationVal(string()), Declaration d, TransformEnv env) = origin(phpAnnotationVal("string"), a);
public PhpAnnotation toPhpAnnotation(a: annotationVal(float()), Declaration d, TransformEnv env) = origin(phpAnnotationVal("float"), a);
public PhpAnnotation toPhpAnnotation(a: annotationVal(boolean()), Declaration d, TransformEnv env) = origin(phpAnnotationVal("boolean"), a);
public PhpAnnotation toPhpAnnotation(a: annotationVal(val), Declaration d, TransformEnv env) = origin(phpAnnotationVal(val), a);

public str toPhpAnnotationKey("sequence", TransformEnv env) = "ORM\\GeneratedValue" when usesDoctrine(env) && isInEntity(env);
public str toPhpAnnotationKey("table", TransformEnv env) = "ORM\\Table" when usesDoctrine(env) && isInEntity(env);
public str toPhpAnnotationKey("id", TransformEnv env) = "ORM\\Id" when usesDoctrine(env) && isInEntity(env);
public str toPhpAnnotationKey("field", TransformEnv env) = "ORM\\Column" when usesDoctrine(env) && isInEntity(env);
public str toPhpAnnotationKey("column", TransformEnv env) = "ORM\\Column" when usesDoctrine(env) && isInEntity(env);
public default str toPhpAnnotationKey(str annotation, TransformEnv env) = annotation;

public set[PhpAnnotation] toPhpAnnotations(list[Annotation] annotations, Declaration d, TransformEnv env) = 
    {toPhpAnnotation(a, d, env) | a <- annotations, a.annotationName in PROCESSABLE_KEYS};

public set[PhpAnnotation] toPhpAnnotations(Declaration d, TransformEnv env) =
	((d@annotations?) ? toPhpAnnotations(d@annotations, d, env) : {});
