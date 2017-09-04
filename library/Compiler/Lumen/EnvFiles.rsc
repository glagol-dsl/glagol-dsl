module Compiler::Lumen::EnvFiles

import Config::Config;
import Config::Reader;
import Compiler::PHP::Compiler;
import Compiler::Lumen::Bootstrap::App;
import Compiler::Lumen::Public::Index;
import Compiler::Lumen::Public::Htaccess;
import Compiler::Lumen::Config::Doctrine;
import Compiler::Lumen::Config::Database;
import Compiler::Lumen::Routes::Api;
import Compiler::Lumen::Routes::Console;
import Compiler::Lumen::Server;
import Compiler::Lumen::Artisan;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import String;

public map[loc, str] generateFrameworkFiles(lumen(), Config config, list[Declaration] ast) = (
	|file:///| + "bootstrap/app.php": createAppFile(getORM(config), ast),
    |file:///| + "bootstrap/cache/.gitignore": "*.php",
	|file:///| + "public/index.php": createIndexFile(),
	|file:///| + "public/.htaccess": createHtaccess(),
    |file:///| + "artisan": createArtisan(),
    |file:///| + "config/doctrine.php": createDoctrineConfig(ast),
    |file:///| + "config/database.php": createDatabaseConfig(),
    |file:///| + "routes/api.php": createRoutesApi(ast),
    |file:///| + "routes/console.php": createRoutesConsole(),
    |file:///| + "server.php": createServerFile()
) + getRepositoryProviders(getORM(config), config, ast) + getCustomTypes(ast, getORM(config));

private map[loc, str] getCustomTypes(list[Declaration] ast, doctrine()) =
	(|file:///| + "app/Types/<namespaceToString(ns)><name>Type.php": 
    	createType(e, findDbValueMethod(declarations)) | \file(_, e: \module(ns, _, valueObject(str name, declarations))) <- ast);

private Declaration findDbValueMethod(list[Declaration] methods) = 
	(emptyDecl() | m | m: method(\public(), _, "toDatabaseValue", [], _, _) <- methods);

private str lookupSqlDeclarationGetter(method(_, Type t, _, _, _, _)) = lookupSqlDeclarationGetter(t);
private str lookupSqlDeclarationGetter(string()) = "getVarcharTypeDeclarationSQL";
private str lookupSqlDeclarationGetter(integer()) = "getIntegerTypeDeclarationSQL"; 
private str lookupSqlDeclarationGetter(float()) = "getDecimalTypeDeclarationSQL"; 
private str lookupSqlDeclarationGetter(boolean()) = "getBooleanTypeDeclarationSQL"; 
private str lookupSqlDeclarationGetter(_) = "getJsonTypeDeclarationSQL";

private str createType(m: \module(ns, _, v: valueObject(str name, declarations)), Declaration dbValMethod) = toCode(
	phpScript([
		phpDeclareStrict(),
        phpNamespace(
            phpSomeName(phpName("App\\Types")),
            [
                phpUse({
                    phpUse(phpName("Doctrine\\Instantiator\\Instantiator"), phpNoName()),
                    phpUse(phpName("Doctrine\\DBAL\\Types\\Type"), phpNoName()),
                    phpUse(phpName("Doctrine\\DBAL\\Platforms\\AbstractPlatform"), phpNoName()),
                    phpUse(phpName(namespaceToString(ns, "\\") + "\\<name>"), phpNoName())
                }),
                phpClassDef(phpClass("<namespaceToString(ns)><name>Type", {}, phpSomeName(phpName("Type")), [], [
                	phpConstCI([phpConst("TYPE_NAME", phpScalar(phpString(toLowerCase(namespaceToString(ns, "_") + "_<name>"))))]),
                    phpMethod("convertToPHPValue", {phpPublic()}, false, [
                    	phpParam("value", phpNoExpr(), phpNoName(), false, false),
                    	phpParam("platform", phpNoExpr(), phpSomeName(phpName("AbstractPlatform")), false, false)
                    ], [
                    	phpIf(phpUnaryOperation(phpCall(phpName(phpName("method_exists")), [
                    		phpActualParameter(phpVar("value"), false),
                    		phpActualParameter(phpScalar(phpString("toDatabaseValue")), false)
                    	]), phpBooleanNot()), [
                    		phpReturn(phpSomeExpr(
								phpMethodCall(phpBracket(phpSomeExpr(phpNew(phpName(phpName("Instantiator")), []))), 
									phpName(phpName("instantiate")), [phpActualParameter(
										phpFetchClassConst(phpName(phpName(name)), "class"), false)
									]
								)
							))
                    	], [], phpNoElse()),
                    	phpReturn(phpSomeExpr(phpNew(phpName(phpName(name)), [
                				phpActualParameter(phpVar(phpName(phpName("value"))), false)
                    	])))
                    ], phpSomeName(phpName(name))),
                    phpMethod("convertToDatabaseValue", {phpPublic()}, false, [
                    	phpParam("value", phpNoExpr(), phpNoName(), false, false),
                    	phpParam("platform", phpNoExpr(), phpSomeName(phpName("AbstractPlatform")), false, false)
                    ], [
                    	phpIf(phpUnaryOperation(phpCall(phpName(phpName("method_exists")), [
                    		phpActualParameter(phpVar("value"), false),
                    		phpActualParameter(phpScalar(phpString("toDatabaseValue")), false)
                    	]), phpBooleanNot()), [
                    		phpReturn(phpSomeExpr(phpScalar(phpNull())))
                    	], [], phpNoElse()),
                    	phpReturn(phpSomeExpr(phpMethodCall(phpVar(phpName(phpName("value"))), phpName(phpName("toDatabaseValue")), [])))
                    ], phpNoName()),
                    phpMethod("getName", {phpPublic()}, false, [], [
                    	phpReturn(phpSomeExpr(phpFetchClassConst(phpName(phpName("self")), "TYPE_NAME")))
                    ], phpSomeName(phpName("string"))),
                    phpMethod("getSQLDeclaration", {phpPublic()}, false, [
                    	phpParam("fieldDeclaration", phpNoExpr(), phpSomeName(phpName("array")), false, false),
                    	phpParam("platform", phpNoExpr(), phpSomeName(phpName("AbstractPlatform")), false, false)
                    ], [
                    	phpReturn(phpSomeExpr(
                    		phpMethodCall(phpVar(phpName(phpName("platform"))), phpName(phpName(
                    			lookupSqlDeclarationGetter(dbValMethod)
                			)), [
                				phpActualParameter(phpVar(phpName(phpName("fieldDeclaration"))), false)
                			])
                    	))
                    ], phpSomeName(phpName("string")))
                ]))
            ]
        )
    ])
);

private map[loc, str] getRepositoryProviders(doctrine(), Config config, list[Declaration] ast) = 
    (|file:///| + "app/Provider/<namespaceToString(ns, "/")>/<name>RepositoryProvider.php": 
    	createProvider(doctrine(), e) | \file(_, e: \module(ns, _, repository(str name, _))) <- ast);

private str createProvider(doctrine(), m: \module(ns, _, repository(str name, list[Declaration] declarations))) = 
    toCode(phpScript([
        phpNamespace(
            phpSomeName(phpName("App\\Provider\\<namespaceToString(ns, "\\")>")),
            [
                phpUse({
                    phpUse(phpName("Illuminate\\Support\\ServiceProvider"), phpNoName()),
                    phpUse(phpName(namespaceToString(ns, "\\") + "\\<name>Repository"), phpNoName())
                }),
                phpClassDef(phpClass("<name>RepositoryProvider", {}, phpSomeName(phpName("ServiceProvider")), [], [
                    phpMethod("register", {phpPublic()}, false, [], [
                        phpExprstmt(phpMethodCall(phpPropertyFetch(phpVar("this"), phpName(phpName("app"))), phpName(phpName("bind")), [
                            phpActualParameter(phpFetchClassConst(phpName(phpName("<name>Repository")), "class"), false),
                            phpActualParameter(phpClosure([
                                phpExprstmt(phpAssign(phpVar("em"), phpMethodCall(phpVar("app"), phpName(phpName("make")), [
                                    phpActualParameter(phpScalar(phpString("em")), false)
                                ]))),
                                phpExprstmt(phpAssign(phpVar("meta"), phpMethodCall(
                                    phpVar("em"),
                                    phpName(phpName("getClassMetadata")),
                                    [
                                        phpActualParameter(phpFetchClassConst(
                                        phpName(phpName("<getTargetEntityWithNamespace(m)>")),
                                        "class"), false)
                                    ]
                                ))),
                                phpReturn(phpSomeExpr(phpNew(phpName(phpName("<name>Repository")), [
                                    phpActualParameter(phpVar("em"), false),
                                    phpActualParameter(phpVar("meta"), false)
                                ])))
                            ], [phpParam("app", phpNoExpr(), phpNoName(), false, false)], [], false, false), false)
                        ]))
                    ], phpNoName())
                ]))
            ]
        )
    ]));

private str getTargetEntityWithNamespace(\module(Declaration ns, list[Declaration] imports, repository(str name, _))) {
    for (a: \import(str realName, Declaration namespace, str as) <- imports, as == name) {
        return "\\" + namespaceToString(namespace, "\\") + "\\<realName>";
    }
    
    return "\\" + namespaceToString(ns, "\\") + "\\<name>";
}
