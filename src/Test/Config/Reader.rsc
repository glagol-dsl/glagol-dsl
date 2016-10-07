module Test::Config::Reader

import IO;
import Config::Reader;

test bool testShouldLoadDotGlagolFileFromString()
{
    str config = "framework: zend
    'orm: doctrine";
    
    Config strConfig = loadGlagolConfig(config);
    
    return strConfig == <zend(), doctrine()>;
}

test bool testShouldLoadDotGlagolFileFromProjectPath()
{
    str config = "framework: symfony
    'orm: doctrine";
    
    loc tempProjectDir = |tmp:///glagol_test_dot_glagol|;
    
    mkDirectory(tempProjectDir);
    writeFile(tempProjectDir + ".glagol", config);
    
    Config projectConfig = loadGlagolConfig(tempProjectDir);
    
    remove(tempProjectDir + ".glagol");
    remove(tempProjectDir);

    return projectConfig == <symfony(), doctrine()>;
}
