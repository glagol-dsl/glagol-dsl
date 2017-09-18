module Transform::Glagol2PHP::Doctrine::Annotations

import Transform::Glagol2PHP::Annotations;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;
import List;
import Transform::Env;

public PhpAnnotation toPhpAnnotation("table", list[Annotation] arguments, TransformEnv env, e: entity(str name, list[Declaration] ds))
    = phpAnnotationVal(("name": toPhpAnnotation(arguments[0], env, e))) when usesDoctrine(env);
    
public PhpAnnotation toPhpAnnotation("column", list[Annotation] arguments, TransformEnv env, e: entity(str name, list[Declaration] ds))
    = toPhpAnnotation(arguments[0], env, e) when annotationMap(_) := arguments[0] && usesDoctrine(env);
    
public PhpAnnotation toPhpAnnotation("field", list[Annotation] arguments, TransformEnv env, e: entity(str name, list[Declaration] ds)) = 
	toPhpAnnotation("column", arguments, env, e) when usesDoctrine(env);

public str toPhpAnnotationKey("sequence", TransformEnv env, entity(str name, list[Declaration] ds)) = "ORM\\GeneratedValue" when usesDoctrine(env);
public str toPhpAnnotationKey("table", TransformEnv env, entity(str name, list[Declaration] ds)) = "ORM\\Table" when usesDoctrine(env);
public str toPhpAnnotationKey("id", TransformEnv env, entity(str name, list[Declaration] ds)) = "ORM\\Id" when usesDoctrine(env);
public str toPhpAnnotationKey("field", TransformEnv env, entity(str name, list[Declaration] ds)) = "ORM\\Column" when usesDoctrine(env);
public str toPhpAnnotationKey("column", TransformEnv env, entity(str name, list[Declaration] ds)) = "ORM\\Column" when usesDoctrine(env);
