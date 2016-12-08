module Transform::Glagol2PHP::Doctrine::Annotations

extend Transform::Glagol2PHP::Annotations;

private PhpAnnotation toPhpAnnotationArgs(list[Annotation] arguments, "table")
    = phpAnnotationVal(("name": convertAnnotationValue(arguments[0])));

private PhpAnnotation toPhpAnnotationArgs(list[Annotation] arguments, "doc")
    = convertAnnotationValue(arguments[0]);
    
private PhpAnnotation toPhpAnnotationArgs(list[Annotation] arguments, /field|column/)
    = toPhpAnnotationArgs(arguments[0]) when annotationMap(_) := arguments[0];
    
private str toPhpAnnotationKey("table") = "ORM\\Table";
private str toPhpAnnotationKey("id") = "ORM\\Id";
private str toPhpAnnotationKey("field") = "ORM\\Column";
private str toPhpAnnotationKey("column") = "ORM\\Column";
