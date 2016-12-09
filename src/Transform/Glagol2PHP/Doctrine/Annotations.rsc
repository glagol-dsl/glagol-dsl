module Transform::Glagol2PHP::Doctrine::Annotations

extend Transform::Glagol2PHP::Annotations;

private PhpAnnotation toPhpAnnotation("table", list[Annotation] arguments, env: <Framework f, orm: doctrine()>)
    = phpAnnotationVal(("name": toPhpAnnotation(arguments[0], env)));
    
private PhpAnnotation toPhpAnnotation("column", list[Annotation] arguments, env: <Framework f, orm: doctrine()>)
    = toPhpAnnotation(arguments[0], env) when annotationMap(_) := arguments[0];
    
private PhpAnnotation toPhpAnnotation("field", list[Annotation] arguments, env: <Framework f, orm: doctrine()>) = toPhpAnnotation("column", arguments, env);
    
private str toPhpAnnotationKey("table", env: <Framework f, orm: doctrine()>) = "ORM\\Table";
private str toPhpAnnotationKey("id", env: <Framework f, orm: doctrine()>) = "ORM\\Id";
private str toPhpAnnotationKey("field", env: <Framework f, orm: doctrine()>) = "ORM\\Column";
private str toPhpAnnotationKey("column", env: <Framework f, orm: doctrine()>) = "ORM\\Column";
