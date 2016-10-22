module Test::Transform::Glagol2PHP::Doctrine

import Transform::Glagol2PHP::Doctrine;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
import IO;

test bool shouldTransformSimpleEntityToPhpScriptUsingDoctrine()
    = toPHPScript(<zend(), doctrine()>, \module(namespace("User", namespace("Entity")), [
        \import("Money", namespace("Currency", namespace("Value")), "Money"),
        \import("Currency", namespace("Currency", namespace("Value")), "CurrencyVB")
    ], entity("Customer", [
        property(integer(), "id", {})
    ])))
    == ("User/Entity/Customer.php": phpScript([
        phpNamespace(phpSomeName(phpName("User\\Entity")), [
            phpUse({
                phpUse(phpName("Currency\\Value\\Money"), phpNoName()),
                phpUse(phpName("Currency\\Value\\Currency"), phpSomeName(phpName("CurrencyVB"))),
                phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName("ORM")))
            }),
            phpClassDef(phpClass(
                "Customer", {}, phpNoName(), [], [
                    phpProperty({phpPrivate()}, [phpProperty("id", phpNoExpr())])
                ]
            ))
        ])
    ]));

test bool shouldTransformSimpleAnnotatedEntityToPhpScriptUsingDoctrine()
    = toPHPScript(<zend(), doctrine()>, \module(namespace("User", namespace("Entity")), [
        \import("Money", namespace("Currency", namespace("Value")), "Money"),
        \import("Currency", namespace("Currency", namespace("Value")), "CurrencyVB")
    ], annotated([
        annotation("table", [])
    ], entity("Customer", [
        property(integer(), "id", {})
    ]))))
    == ("User/Entity/Customer.php": phpScript([
        phpNamespace(phpSomeName(phpName("User\\Entity")), [
            phpUse({
                phpUse(phpName("Currency\\Value\\Money"), phpNoName()),
                phpUse(phpName("Currency\\Value\\Currency"), phpSomeName(phpName("CurrencyVB"))),
                phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName("ORM")))
            }),
            phpClassDef(phpClass(
                "Customer", {}, phpNoName(), [], [
                    phpProperty({phpPrivate()}, [phpProperty("id", phpNoExpr())])
                ]
            )[@phpAnnotations={
                phpAnnotation("ORM\\Table")
            }])
        ])
    ]));
    
test bool shouldTransformSimpleAnnotatedWithValueEntityToPhpScriptUsingDoctrine() {
    map[str, PhpScript] asts = toPHPScript(<zend(), doctrine()>, \module(namespace("User", namespace("Entity")), [
        \import("Money", namespace("Currency", namespace("Value")), "Money"),
        \import("Currency", namespace("Currency", namespace("Value")), "CurrencyVB")
    ], annotated([
        annotation("table", [annotationVal("customers")])
    ], entity("Customer", [
        annotated([
            annotation("id", []),
            annotation("field", [
                annotationMap((
                    "name": annotationVal("customer_id"),
                    "type": annotationVal(integer()),
                    "length": annotationVal(11),
                    "unique": annotationVal(true),
                    "options": annotationVal(annotationMap((
                        "comment": annotationVal("This is the primary key")
                    ))),
                    "scale": annotationVal(12.35)
                ))
            ])
        ], property(integer(), "id", {}))
    ]))));
    
    PhpScript ast = asts["User/Entity/Customer.php"];
    
    return ast.body[0].body[1].classDef@phpAnnotations == {
              phpAnnotation("ORM\\Entity"),
              phpAnnotation(
                "ORM\\Table",
                phpAnnotationVal(("name":phpAnnotationVal("customers"))))
            } &&
           ast.body[0].body[1].classDef.members[0]@phpAnnotations == {
                  phpAnnotation(
                    "ORM\\Column",
                    phpAnnotationVal((
                        "name": phpAnnotationVal("customer_id"),
                        "type": phpAnnotationVal("integer"),
                        "length": phpAnnotationVal(11),
                        "unique": phpAnnotationVal(true),
                        "options": phpAnnotationVal((
                            "comment": phpAnnotationVal("This is the primary key")
                        )),
                        "scale": phpAnnotationVal(12.35)
                    ))),
                  phpAnnotation("ORM\\Id")
           };
}
