module Test::Transform::Glagol2PHP::Types

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Types;

test bool shouldTransformIntegerTypeToPhpTypeName()
    = toPhpTypeName(integer()) == phpName("int");

test bool shouldTransformStringTypeToPhpTypeName()
    = toPhpTypeName(string()) == phpName("string");

test bool shouldTransformFloatTypeToPhpTypeName()
    = toPhpTypeName(float()) == phpName("float");
    
test bool shouldTransformBooleanTypeToPhpTypeName()
    = toPhpTypeName(boolean()) == phpName("bool");
    
test bool shouldTransformIntTypedListToPhpTypeName()
    = toPhpTypeName(\list(integer())) == phpName("Vector");
    
test bool shouldTransformStringTypedListToPhpTypeName()
    = toPhpTypeName(\list(string())) == phpName("Vector");
    
test bool shouldTransformTypedMapToPhpTypeName()
    = toPhpTypeName(\map(string(), integer())) == phpName("Map");
    
test bool shouldTransformTypedMapTwoToPhpTypeName()
    = toPhpTypeName(\map(string(), string())) == phpName("Map");
    
test bool shouldTransformArtifactTypeToPhpTypeName()
    = toPhpTypeName(artifact(unresolvedName("SomeUtil"))) == phpName("SomeUtil");
    
test bool shouldTransformRepositoryTypeToPhpTypeName()
    = toPhpTypeName(repository(unresolvedName("User"))) == phpName("UserRepository");
    
