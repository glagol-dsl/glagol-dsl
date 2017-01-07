module Compiler::Laravel::Config::Abstract

import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Compiler::PHP::Compiler;

public data Conf 
    = env(str name)
    | env(str name, str \default)
    | env(str name, bool \defaultBool)
    | storagePath(str path)
    | \null()
    | string(str val)
    | integer(int ival)
    | class(str className)
    | array(list[Conf] l)
    | array(map[str, Conf] m);


public PhpExpr toPhpConf(array(map[str, Conf] m)) = 
    phpArray([phpArrayElement(phpSomeExpr(phpScalar(phpString(k))), toPhpConf(m[k]), false) | k <- m]);
    
public PhpExpr toPhpConf(env(str name, str \default)) = phpCall("env", [
    phpActualParameter(phpScalar(phpString(name)), false),
    phpActualParameter(phpScalar(phpString(\default)), false)
]);

public PhpExpr toPhpConf(env(str name, bool \defaultBool)) = phpCall("env", [
    phpActualParameter(phpScalar(phpString(name)), false),
    phpActualParameter(phpScalar(phpBoolean(\defaultBool)), false)
]);

public PhpExpr toPhpConf(env(str name)) = phpCall("env", [
    phpActualParameter(phpScalar(phpString(name)), false)
]);

public PhpExpr toPhpConf(storagePath(str path)) = phpCall("storage_path", [
    phpActualParameter(phpScalar(phpString(path)), false)
]);

public PhpExpr toPhpConf(string(str val)) = phpScalar(phpString(val));
public PhpExpr toPhpConf(integer(int val)) = phpScalar(phpInteger(val));
public PhpExpr toPhpConf(\null()) = phpScalar(phpNull());
public PhpExpr toPhpConf(class(str className)) = phpFetchClassConst(phpName(phpName(className)), "class");
public PhpExpr toPhpConf(array(list[Conf] l)) = phpArray([phpArrayElement(phpNoExpr(), toPhpConf(v), false) | v <- l]);
