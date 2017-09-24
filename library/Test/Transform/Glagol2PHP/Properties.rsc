module Test::Transform::Glagol2PHP::Properties

import Transform::Glagol2PHP::Properties;
import Transform::Env;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;

test bool propertyShouldTransformToPhpPropertyHavingNoDefaultValueWhenGetIsUsed() =
    toPhpClassItem(property(artifact(fullName("SomeUtil", namespace("Example"), "SomeUtil")), "someUtil", get(selfie())), newTransformEnv(), entity("", [])) ==
    phpProperty({phpPrivate()}, [phpProperty("someUtil", phpNoExpr())]);

test bool propertyShouldTransformToPhpPropertyWithoutDefaultValue() =
    toPhpClassItem(property(artifact(fullName("SomeUtil", namespace("Example"), "SomeUtil")), "someUtil", emptyExpr()), newTransformEnv(), entity("", [])) ==
    phpProperty({phpPrivate()}, [phpProperty("someUtil", phpNoExpr())]);

test bool propertyShouldTransformToPhpPropertyWithDefaultValue() =
    toPhpClassItem(property(integer(), "id", integer(75)), newTransformEnv(), entity("", [])) ==
    phpProperty({phpPrivate()}, [phpProperty("id", phpSomeExpr(phpScalar(phpInteger(75))))]) && 
    
    toPhpClassItem(property(float(), "price", float(25.4)), newTransformEnv(), entity("", [])) ==
    phpProperty({phpPrivate()}, [phpProperty("price", phpSomeExpr(phpScalar(phpFloat(25.4))))]);
