module Test::Transform::Glagol2PHP::Annotations

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;
import Transform::Glagol2PHP::Annotations;
import Transform::Env;

test bool shouldTransformToTablePhpAnnotation() =
    toPhpAnnotation(annotation("table", [annotationVal("adsdsa")]), newTransformEnv(\module(namespace("Test"), [], entity("", [])))) ==
    phpAnnotation("ORM\\Table", phpAnnotationVal(("name":phpAnnotationVal("adsdsa")))) &&
    toPhpAnnotation(annotation("table", [annotationVal("adsdsa")]), setContext(\module(namespace("Test"), [], entity("", [])), newTransformEnv(anyFramework(), anyORM()))) ==
    phpAnnotation("table", phpAnnotationVal([phpAnnotationVal("adsdsa")]));
    
test bool shouldTransformDocToPhpAnnotation() =
    toPhpAnnotation(annotation("doc", [annotationVal("This is a doc")]), newTransformEnv(\module(namespace("Test"), [], entity("", [])))) ==
    phpAnnotation("doc", phpAnnotationVal("This is a doc"));
   
test bool shouldTransformDocToPhpAnnotationWithDiffEnv() =
    toPhpAnnotation(annotation("doc", [annotationVal("This is a doc")]), setContext(\module(namespace("Test"), [], entity("", [])), newTransformEnv(anyFramework(), anyORM()))) ==
    phpAnnotation("doc", phpAnnotationVal("This is a doc"));

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
                ))]), newTransformEnv(\module(namespace("Test"), [], entity("", [])))) ==
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
                ))]), newTransformEnv(\module(namespace("Test"), [], entity("", [])))) ==
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
    toPhpAnnotation(annotation("doc", [annotationVal("This is a comment")]), newTransformEnv(entity("", []))) ==
    phpAnnotation("doc", phpAnnotationVal("This is a comment"));
