module Test::Compiler::Lumen::Config::Abstract

import Compiler::Lumen::Config::Abstract;
import Syntax::Abstract::PHP;

test bool shouldConvertToPhpConf() =
    toPhpConf(array(("key": string("value")))) == 
    phpArray([phpArrayElement(phpSomeExpr(phpScalar(phpString("key"))), phpScalar(phpString("value")), false)]);

test bool shouldConvertToPhpConfEnv() = 
    toPhpConf(env("APP_BLAH", "blahblah")) == phpCall(phpName(phpName("env")), [
        phpActualParameter(phpScalar(phpString("APP_BLAH")), false),
        phpActualParameter(phpScalar(phpString("blahblah")), false)
    ]);

test bool shouldConvertToPhpConfEnvWithDefaultBool() = 
    toPhpConf(env("APP_BLAH", true)) == phpCall(phpName(phpName("env")), [
        phpActualParameter(phpScalar(phpString("APP_BLAH")), false),
        phpActualParameter(phpScalar(phpBoolean(true)), false)
    ]);

test bool shouldConvertToPhpConfEnvWithoutDefault() = 
    toPhpConf(env("APP_BLAH")) == phpCall(phpName(phpName("env")), [
        phpActualParameter(phpScalar(phpString("APP_BLAH")), false)
    ]);

test bool shouldConvertToPhpConfStoragePath() = 
    toPhpConf(storagePath("blah")) == phpCall(phpName(phpName("storage_path")), [
        phpActualParameter(phpScalar(phpString("blah")), false)
    ]);
    
test bool shouldConvertToPhpConfBasePath() = 
    toPhpConf(basePath("blah")) == phpCall(phpName(phpName("base_path")), [
        phpActualParameter(phpScalar(phpString("blah")), false)
    ]);

test bool shouldConvertToPhpConfScalarStr() = toPhpConf(string("blah")) == phpScalar(phpString("blah"));
test bool shouldConvertPhpConfToInteger() = toPhpConf(integer(23)) == phpScalar(phpInteger(23));
test bool shouldConvertPhpConfToBoolean() = toPhpConf(boolean(true)) == phpScalar(phpBoolean(true));
test bool shouldConvertPhpConfToBooleanFalse() = toPhpConf(boolean(false)) == phpScalar(phpBoolean(false));
test bool shouldConvertPhpConfToNull() = toPhpConf(null()) == phpScalar(phpNull());
test bool shouldConvertPhpConfToClassUse() = toPhpConf(class("stdClass")) == phpFetchClassConst(phpName(phpName("stdClass")), "class");
test bool shouldConvertPhpConfToArray() = toPhpConf(array([])) == phpArray([]);
