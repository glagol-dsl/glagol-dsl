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
                phpUse(phpName("Currency\\Value\\Currency"), phpSomeName(phpName("CurrencyVB")))
            }),
            phpClassDef(phpClass(
                "Customer", {}, phpNoName(), [], [
                    phpProperty({phpPrivate()}, [phpProperty("id", phpNoExpr())])
                ]
            ))
        ])
    ]);
