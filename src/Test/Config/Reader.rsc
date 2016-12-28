module Test::Config::Reader

import IO;
import Config::Reader;

test bool testShouldLoadDotGlagolFileFromString()
{
    str config = "name: test
    'description: test
    'framework: zend
    'orm: doctrine
    'src_dir: source
    'out_dir: code";
    
    return loadGlagolConfig(config) == <"test", "test", zend(), doctrine(), |tmp:///|, |tmp:///source|, |tmp:///code|>;
}

test bool testShouldLoadDotGlagolFileFromProjectPath()
{
    str config = "name: test
    'description: test
    'framework: zend
    'orm: doctrine";
    
    loc tempProjectDir = |tmp:///glagol_test_dot_glagol|;
    
    mkDirectory(tempProjectDir);
    writeFile(tempProjectDir + ".glagol", config);
    
    Config projectConfig = loadGlagolConfig(tempProjectDir);
    
    remove(tempProjectDir + ".glagol");
    remove(tempProjectDir);

    return projectConfig == <"test", "test", zend(), doctrine(), tempProjectDir, tempProjectDir + "src", tempProjectDir + "out">;
}

test bool testShouldThrowExceptionOnInvalidFramework()
{
    str config = "name: test
    'description: test
    'framework: pizda
    'orm: doctrine";
    
    try {
        loadGlagolConfig(config);
    } catch InvalidFramework(str msg): {
        return msg == "Invalid framework \"pizda\"";
    }
        
    return false;   
}

test bool testShouldThrowExceptionOnInvalidORM()
{
    str config = "name: test
    'description: test
    'framework: zend
    'orm: pizda";
    
    try {
        loadGlagolConfig(config);
    } catch InvalidORM(str msg): {
        return msg == "Invalid ORM \"pizda\"";
    }
        
    return false;   
}
