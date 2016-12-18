module Transform::Glagol2PHP::Doctrine::Annotations

import Transform::Glagol2PHP::Annotations;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
import List;

public PhpAnnotation toPhpAnnotation("table", list[Annotation] arguments, env: <Framework f, orm: doctrine()>, e: entity(_, _))
    = phpAnnotationVal(("name": toPhpAnnotation(arguments[0], env, e)));
    
public PhpAnnotation toPhpAnnotation("column", list[Annotation] arguments, env: <Framework f, orm: doctrine()>, e: entity(_, _))
    = toPhpAnnotation(arguments[0], env, e) when annotationMap(_) := arguments[0];
    
public PhpAnnotation toPhpAnnotation("field", list[Annotation] arguments, env: <Framework f, orm: doctrine()>, e: entity(_, _)) = 
	toPhpAnnotation("column", arguments, env, e);
    
public str toPhpAnnotationKey("table", env: <Framework f, orm: doctrine()>, entity(_, _)) = "ORM\\Table";
public str toPhpAnnotationKey("id", env: <Framework f, orm: doctrine()>, entity(_, _)) = "ORM\\Id";
public str toPhpAnnotationKey("field", env: <Framework f, orm: doctrine()>, entity(_, _)) = "ORM\\Column";
public str toPhpAnnotationKey("column", env: <Framework f, orm: doctrine()>, entity(_, _)) = "ORM\\Column";
