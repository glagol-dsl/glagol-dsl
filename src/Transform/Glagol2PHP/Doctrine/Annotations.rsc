module Transform::Glagol2PHP::Doctrine::Annotations

extend Transform::Glagol2PHP::Annotations;

private PhpAnnotation toPhpAnnotation("table", list[Annotation] arguments)
    = phpAnnotationVal(("name": toPhpAnnotation(arguments[0])));

private PhpAnnotation toPhpAnnotation("doc", list[Annotation] arguments) = toPhpAnnotation(arguments[0]);
    
private PhpAnnotation toPhpAnnotation("column", list[Annotation] arguments)
    = toPhpAnnotation(arguments[0]) when annotationMap(_) := arguments[0];
    
private PhpAnnotation toPhpAnnotation("field", list[Annotation] arguments) = toPhpAnnotation("column", arguments);
    
private str toPhpAnnotationKey("table") = "ORM\\Table";
private str toPhpAnnotationKey("id") = "ORM\\Id";
private str toPhpAnnotationKey("field") = "ORM\\Column";
private str toPhpAnnotationKey("column") = "ORM\\Column";
