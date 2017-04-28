module Test::Transform::Glagol2PHP::Properties

import Transform::Glagol2PHP::Properties;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;

test bool propertyShouldTransformToPhpPropertyHavingNoDefaultValueWhenGetIsUsed() =
    toPhpClassItem(property(artifact("SomeUtil"), "someUtil", {}, get(selfie())), <zend(), doctrine()>, entity("", [])) ==
    phpProperty({phpPrivate()}, [phpProperty("someUtil", phpNoExpr())]);

test bool propertyShouldTransformToPhpPropertyWithoutDefaultValue() =
    toPhpClassItem(property(artifact("SomeUtil"), "someUtil", {}, emptyExpr()), <zend(), doctrine()>, entity("", [])) ==
    phpProperty({phpPrivate()}, [phpProperty("someUtil", phpNoExpr())]);

test bool propertyShouldTransformToPhpPropertyWithDefaultValue() =
    toPhpClassItem(property(integer(), "id", {}, integer(75)), <zend(), doctrine()>, entity("", [])) ==
    phpProperty({phpPrivate()}, [phpProperty("id", phpSomeExpr(phpScalar(phpInteger(75))))]) && 
    
    toPhpClassItem(property(float(), "price", {}, float(25.4)), <zend(), doctrine()>, entity("", [])) ==
    phpProperty({phpPrivate()}, [phpProperty("price", phpSomeExpr(phpScalar(phpFloat(25.4))))]);
