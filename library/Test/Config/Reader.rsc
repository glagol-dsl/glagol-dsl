module Test::Config::Reader

import IO;
import Config::Reader;
import Config::Config;
import lang::json::ast::JSON;

test bool testShouldComposerConfigFromString()
{
    str config = "{\"name\": \"test/project\"}";
    
    return loadConfig(config) == <object(("name": string("test/project"))), |tmp:///|>;
}

test bool testShouldLoadComposerFileFromProjectPath()
{
    str config = "{\"name\": \"test/project\"}";
    
    loc tempProjectDir = |tmp:///glagol_test|;
    
    mkDirectory(tempProjectDir);
    writeFile(tempProjectDir + "composer.json", config);
    
    Config projectConfig = loadConfig(tempProjectDir);
    
    remove(tempProjectDir + "composer.json");
    remove(tempProjectDir);

    return projectConfig == <object(("name": string("test/project"))), tempProjectDir>;
}

test bool testHasPropertyNestedReturnsTrue() = hasProperty(object(("glagol": object(("framework": string("zend"))))), "glagol", "framework");
test bool testHasPropertyNestedReturnsFalse() = !hasProperty(object(("glagol": object(("framework": string("zend"))))), "glagol", "IAMNOTDEFINED");

test bool testGetPropertyNestedReturnsValue() = getProperty(object(("glagol": object(("framework": string("zend"))))), null(), "glagol", "framework") == string("zend");
test bool testGetPropertyNestedReturnsValue2() = getProperty(object(("glagol": object(("framework": string("zend"))))), null(), "glagol") == object(("framework": string("zend")));
test bool testGetPropertyNestedReturnsDefaultValue() = getProperty(object(("glagol": object(("framework": string("zend"))))), null(), "glagol", "orm") == null();

test bool testGetFrameworkShouldReturnLaravel() = getFramework(object(("glagol": object(("framework": string("laravel")))))) == laravel();

test bool testGetFrameworkShouldThrowExceptionOnInvalidFramework() {
    try
        getFramework(object(("glagol": object(("framework": string("zend"))))));
    catch InvalidFramework("Invalid framework \"zend\""): return true;
    
    return false;
}

test bool testGetFrameworkShouldThrowExceptionOnUnspecifiedFramework() {
    try
        getFramework(object(("glagol": object(()))));
    catch InvalidFramework("Framework not specified"): return true;
    
    return false;
}

test bool testGetORMShouldReturnDoctrine() = getORM(object(("glagol": object(("orm": string("doctrine")))))) == doctrine();

test bool testGetORMShouldThrowExceptionOnInvalidORM() {
    try
        getORM(object(("glagol": object(("orm": string("propel"))))));
    catch InvalidORM("Invalid ORM \"propel\""): return true;
    
    return false;
}

test bool testGetORMShouldThrowExceptionOnUnspecifiedORM() {
    try
        getORM(object(("glagol": object(()))));
    catch InvalidORM("ORM not specified"): return true;
    
    return false;
}

