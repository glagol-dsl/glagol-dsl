module Test::Transform::Glagol2PHP::Properties

import Transform::Glagol2PHP::Properties;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;

test bool propertyShouldTransformToPhpPropertyHavingNoDefaultValueWhenGetIsUsed() =
    toPhpClassItem(property(artifactType("SomeUtil"), "someUtil", {}, get(selfie())), <zend(), doctrine()>, entity("", [])) ==
    phpProperty({phpPrivate()}, [phpProperty("someUtil", phpNoExpr())]);

test bool propertyShouldTransformToPhpPropertyWithoutDefaultValue() =
    toPhpClassItem(property(artifactType("SomeUtil"), "someUtil", {}), <zend(), doctrine()>, entity("", [])) ==
    phpProperty({phpPrivate()}, [phpProperty("someUtil", phpNoExpr())]);

test bool propertyShouldTransformToPhpPropertyWithDefaultValue() =
    toPhpClassItem(property(integer(), "id", {}, intLiteral(75)), <zend(), doctrine()>, entity("", [])) ==
    phpProperty({phpPrivate()}, [phpProperty("id", phpSomeExpr(phpScalar(phpInteger(75))))]) && 
    
    toPhpClassItem(property(float(), "price", {}, floatLiteral(25.4)), <zend(), doctrine()>, entity("", [])) ==
    phpProperty({phpPrivate()}, [phpProperty("price", phpSomeExpr(phpScalar(phpFloat(25.4))))]);
