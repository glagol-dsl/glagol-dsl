module Test::Transform::Glagol2PHP::Constructors::Dependencies

import Transform::Env;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;
import Transform::Glagol2PHP::Utils;

test bool shouldCreateConstructorWhenUtilHasDependencies() = 
    toPhpClassDef(util("UserCreator", [
        property(repository(fullName("User", namespace("Example"), "User")), "users", get(repository(fullName("User", namespace("Example"), "User")))),
        property(repository(fullName("Customer", namespace("Example"), "Customer")), "customers", get(repository(fullName("Customer", namespace("Example"), "Customer"))))
    ], notProxy()), newTransformEnv()) == 
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
