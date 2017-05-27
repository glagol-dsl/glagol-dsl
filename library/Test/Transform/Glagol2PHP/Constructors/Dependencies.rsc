module Test::Transform::Glagol2PHP::Constructors::Dependencies

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;
import Transform::Glagol2PHP::Utils;

test bool shouldCreateConstructorWhenUtilHasDependencies() = 
    toPhpClassDef(util("UserCreator", [
        property(repository(unresolvedName("User")), "users", {}, get(repository(unresolvedName("User")))),
        property(repository(unresolvedName("Customer")), "customers", {}, get(repository(unresolvedName("Customer"))))
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
