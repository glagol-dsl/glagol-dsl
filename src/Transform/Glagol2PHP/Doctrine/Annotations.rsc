module Transform::Glagol2PHP::Doctrine::Annotations

import Transform::Glagol2PHP::Annotations;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
import List;

public PhpAnnotation toPhpAnnotation("table", list[Annotation] arguments, env: <Framework f, orm: doctrine()>)
    = phpAnnotationVal(("name": toPhpAnnotation(arguments[0], env)));
    
public PhpAnnotation toPhpAnnotation("column", list[Annotation] arguments, env: <Framework f, orm: doctrine()>)
    = toPhpAnnotation(arguments[0], env) when annotationMap(_) := arguments[0];
    
public PhpAnnotation toPhpAnnotation("field", list[Annotation] arguments, env: <Framework f, orm: doctrine()>) = toPhpAnnotation("column", arguments, env);
    
public str toPhpAnnotationKey("table", env: <Framework f, orm: doctrine()>) = "ORM\\Table";
public str toPhpAnnotationKey("id", env: <Framework f, orm: doctrine()>) = "ORM\\Id";
public str toPhpAnnotationKey("field", env: <Framework f, orm: doctrine()>) = "ORM\\Column";
public str toPhpAnnotationKey("column", env: <Framework f, orm: doctrine()>) = "ORM\\Column";
