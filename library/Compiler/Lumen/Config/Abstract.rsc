module Compiler::Lumen::Config::Abstract

import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Compiler::PHP::Compiler;

public data Conf 
    = env(str name)
    | env(str name, str \default)
    | env(str name, bool \defaultBool)
    | env(str name, Conf defaultConf)
    | storagePath(str path)
    | basePath(str path)
    | \null()
    | booleanVal(bool bval)
    | stringVal(str val)
    | integerVal(int ival)
    | class(str className)
    | class(str className, str field)
    | array(list[Conf] l)
    | array(map[str, Conf] m)
    | array(map[Conf, Conf] ma);


public PhpExpr toPhpConf(array(map[str, Conf] m)) = 
    phpArray([phpArrayElement(phpSomeExpr(phpScalar(phpString(k))), toPhpConf(m[k]), false) | k <- m]);
    
public PhpExpr toPhpConf(array(map[Conf, Conf] m)) = 
    phpArray([phpArrayElement(phpSomeExpr(toPhpConf(k)), toPhpConf(m[k]), false) | k <- m]);
    
public PhpExpr toPhpConf(env(str name, str \default)) = phpCall("env", [
    phpActualParameter(phpScalar(phpString(name)), false),
    phpActualParameter(phpScalar(phpString(\default)), false)
]);

public PhpExpr toPhpConf(env(str name, bool \defaultBool)) = phpCall("env", [
    phpActualParameter(phpScalar(phpString(name)), false),
    phpActualParameter(phpScalar(phpBoolean(\defaultBool)), false)
]);

public PhpExpr toPhpConf(env(str name, Conf defaultConf)) = phpCall("env", [
    phpActualParameter(phpScalar(phpString(name)), false),
    phpActualParameter(toPhpConf(defaultConf), false)
]);

public PhpExpr toPhpConf(env(str name)) = phpCall("env", [
    phpActualParameter(phpScalar(phpString(name)), false)
]);

public PhpExpr toPhpConf(storagePath(str path)) = phpCall("storage_path", [
    phpActualParameter(phpScalar(phpString(path)), false)
]);

public PhpExpr toPhpConf(basePath(str path)) = phpCall("base_path", [
    phpActualParameter(phpScalar(phpString(path)), false)
]);

public PhpExpr toPhpConf(stringVal(str val)) = phpScalar(phpString(val));
public PhpExpr toPhpConf(integerVal(int val)) = phpScalar(phpInteger(val));
public PhpExpr toPhpConf(booleanVal(bool bval)) = phpScalar(phpBoolean(bval));
public PhpExpr toPhpConf(\null()) = phpScalar(phpNull());
public PhpExpr toPhpConf(class(str className)) = toPhpConf(class(className, "class"));
public PhpExpr toPhpConf(class(str className, str field)) = phpFetchClassConst(phpName(phpName(className)), field);
public PhpExpr toPhpConf(array(list[Conf] l)) = phpArray([phpArrayElement(phpNoExpr(), toPhpConf(v), false) | v <- l]);
