module Test::Transform::Glagol2PHP::Doctrine::Annotations

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

extend Transform::Glagol2PHP::Doctrine::Annotations;

test bool shouldTransformToTablePhpAnnotation() =
    toPhpAnnotation(annotation("table", [annotationVal("adsdsa")])) ==
    phpAnnotation("ORM\\Table", phpAnnotationVal(("name":phpAnnotationVal("adsdsa"))));
    
test bool shouldTransformToIdPhpAnnotation() =
    toPhpAnnotation(annotation("id", [])) ==
    phpAnnotation("ORM\\Id");

test bool shouldTransformToFieldPhpAnnotation() =
    toPhpAnnotation(annotation("field", [annotationMap((
                    "name": annotationVal("customer_id"),
                    "type": annotationVal(integer()),
                    "length": annotationVal(11),
                    "unique": annotationVal(true),
                    "options": annotationVal(annotationMap((
                        "comment": annotationVal("This is the primary key")
                    ))),
                    "scale": annotationVal(12.35)
                ))])) ==
    phpAnnotation("ORM\\Column",
        phpAnnotationVal((
            "name": phpAnnotationVal("customer_id"),
            "type": phpAnnotationVal("integer"),
            "length": phpAnnotationVal(11),
            "unique": phpAnnotationVal(true),
            "options": phpAnnotationVal((
                "comment": phpAnnotationVal("This is the primary key")
            )),
            "scale": phpAnnotationVal(12.35)
    )));

test bool shouldTransformToFieldPhpAnnotation2() =
    toPhpAnnotation(annotation("column", [annotationMap((
                    "name": annotationVal("customer_id"),
                    "type": annotationVal(integer()),
                    "length": annotationVal(11),
                    "unique": annotationVal(true),
                    "options": annotationVal(annotationMap((
                        "comment": annotationVal("This is the primary key")
                    ))),
                    "scale": annotationVal(12.35)
                ))])) ==
    phpAnnotation("ORM\\Column",
        phpAnnotationVal((
            "name": phpAnnotationVal("customer_id"),
            "type": phpAnnotationVal("integer"),
            "length": phpAnnotationVal(11),
            "unique": phpAnnotationVal(true),
            "options": phpAnnotationVal((
                "comment": phpAnnotationVal("This is the primary key")
            )),
            "scale": phpAnnotationVal(12.35)
    )));

test bool shouldTransformToDocPhpAnnotation() =
    toPhpAnnotation(annotation("doc", [annotationVal("This is a comment")])) ==
    phpAnnotation("doc",
        phpAnnotationVal("This is a comment"));
