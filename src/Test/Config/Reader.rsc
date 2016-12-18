module Test::Config::Reader

import IO;
import Config::Reader;

test bool testShouldLoadDotGlagolFileFromString()
{
    str config = "framework: zend
    'orm: doctrine
    'src_dir: source";
    
    return loadGlagolConfig(config) == <zend(), doctrine(), |tmp:///|, |tmp:///source|>;
}

test bool testShouldLoadDotGlagolFileFromProjectPath()
{
    str config = "framework: zend
    'orm: doctrine";
    
    loc tempProjectDir = |tmp:///glagol_test_dot_glagol|;
    
    mkDirectory(tempProjectDir);
    writeFile(tempProjectDir + ".glagol", config);
    
    Config projectConfig = loadGlagolConfig(tempProjectDir);
    
    remove(tempProjectDir + ".glagol");
    remove(tempProjectDir);

    return projectConfig == <zend(), doctrine(), tempProjectDir, tempProjectDir + "src">;
}

test bool testShouldThrowExceptionOnInvalidFramework()
{
    str config = "framework: pizda
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
    str config = "framework: zend
    'orm: pizda";
    
    try {
        loadGlagolConfig(config);
    } catch InvalidORM(str msg): {
        return msg == "Invalid ORM \"pizda\"";
    }
        
    return false;   
}
