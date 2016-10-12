module Test::Transform::Glagol2PHP::Doctrine

import Transform::Glagol2PHP::Doctrine;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;

test bool shouldTransformSimpleEntityToPhpScriptUsingDoctrine()
    = toPHPScript(<zend(), doctrine()>, \module(namespace("User", namespace("Entity")), {
        \import("Money", namespace("Currency", namespace("Value")), "Money"),
        \import("Currency", namespace("Currency", namespace("Value")), "CurrencyVB")
    }, entity("Customer", {
        property(integer(), "id", {})
    })))
    == phpScript([
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
    ]);

test bool shouldTransformSimpleAnnotatedEntityToPhpScriptUsingDoctrine()
    = toPHPScript(<zend(), doctrine()>, \module(namespace("User", namespace("Entity")), {
        \import("Money", namespace("Currency", namespace("Value")), "Money"),
        \import("Currency", namespace("Currency", namespace("Value")), "CurrencyVB")
    }, annotated({
        annotation("table", [])
    }, entity("Customer", {
        property(integer(), "id", {})
    }))))
    == phpScript([
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
                phpAnnotation("table")
            }])
        ])
    ]);
    
test bool shouldTransformSimpleAnnotatedWithValueEntityToPhpScriptUsingDoctrine()
    = toPHPScript(<zend(), doctrine()>, \module(namespace("User", namespace("Entity")), {
        \import("Money", namespace("Currency", namespace("Value")), "Money"),
        \import("Currency", namespace("Currency", namespace("Value")), "CurrencyVB")
    }, annotated({
        annotation("table", [annotationVal("customers")])
    }, entity("Customer", {
        property(integer(), "id", {})
    }))))
    == phpScript([
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
                phpAnnotation("table", ("name": "customers"))
            }])
        ])
    ]);
    
