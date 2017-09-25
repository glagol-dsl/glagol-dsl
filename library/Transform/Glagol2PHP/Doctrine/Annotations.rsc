module Transform::Glagol2PHP::Doctrine::Annotations

import Transform::Glagol2PHP::Annotations;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;
import List;
import Transform::Env;

import IO;

public PhpAnnotation toPhpAnnotation("table", list[Annotation] arguments, TransformEnv env)
    = phpAnnotationVal(("name": toPhpAnnotation(arguments[0], env))) when usesDoctrine(env) && isInEntity(env);
    
public PhpAnnotation toPhpAnnotation("column", list[Annotation] arguments, TransformEnv env)
    = toPhpAnnotation(arguments[0], env) when annotationMap(_) := arguments[0] && usesDoctrine(env) && isInEntity(env);
    
public PhpAnnotation toPhpAnnotation("field", list[Annotation] arguments, TransformEnv env) = 
	toPhpAnnotation("column", arguments, env) when usesDoctrine(env) && isInEntity(env);

public str toPhpAnnotationKey("sequence", TransformEnv env) = "ORM\\GeneratedValue" when usesDoctrine(env) && isInEntity(env);
public str toPhpAnnotationKey("table", TransformEnv env) = "ORM\\Table" when usesDoctrine(env) && isInEntity(env);
public str toPhpAnnotationKey("id", TransformEnv env) = "ORM\\Id" when usesDoctrine(env) && isInEntity(env);
public str toPhpAnnotationKey("field", TransformEnv env) = "ORM\\Column" when usesDoctrine(env) && isInEntity(env);
public str toPhpAnnotationKey("column", TransformEnv env) = "ORM\\Column" when usesDoctrine(env) && isInEntity(env);
