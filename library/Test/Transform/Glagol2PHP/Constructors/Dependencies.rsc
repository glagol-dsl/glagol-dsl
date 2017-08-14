module Test::Transform::Glagol2PHP::Constructors::Dependencies

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;
import Transform::Glagol2PHP::Utils;

test bool shouldCreateConstructorWhenUtilHasDependencies() = 
    toPhpClassDef(util("UserCreator", [
        property(repository(local("User")), "users", get(repository(local("User")))),
        property(repository(local("Customer")), "customers", get(repository(local("Customer"))))
    ]), <zend(), doctrine()>) == 
    phpClassDef(phpClass(
        "UserCreator", {}, phpNoName(), [], [
        	phpProperty({phpPrivate()}, [phpProperty("users", phpNoExpr())]),
        	phpProperty({phpPrivate()}, [phpProperty("customers", phpNoExpr())]),
            phpMethod("__construct", {phpPublic()}, false, [
            	phpParam("users", phpNoExpr(), phpSomeName(phpName("UserRepository")), false, false),
            	phpParam("customers", phpNoExpr(), phpSomeName(phpName("CustomerRepository")), false, false)
        	], [
                phpExprstmt(phpAssign(phpPropertyFetch(
                	phpVar(phpName(phpName("this"))), phpName(phpName("users"))), phpVar(phpName(phpName("users"))))),
                phpExprstmt(phpAssign(phpPropertyFetch(
                	phpVar(phpName(phpName("this"))), phpName(phpName("customers"))), phpVar(phpName(phpName("customers")))))
            ], phpNoName())
        ]
    ));
