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
    = toPhpTypeName(\list(integer())) == phpName("iterable");
    
test bool shouldTransformStringTypedListToPhpTypeName()
    = toPhpTypeName(\list(string())) == phpName("iterable");
    
test bool shouldTransformTypedMapToPhpTypeName()
    = toPhpTypeName(\map(string(), integer())) == phpName("iterable");
    
test bool shouldTransformTypedMapTwoToPhpTypeName()
    = toPhpTypeName(\map(string(), string())) == phpName("iterable");
    
test bool shouldTransformArtifactTypeToPhpTypeName()
    = toPhpTypeName(artifact(fullName("SomeUtil", namespace("Example"), "SomeUtil"))) == phpName("SomeUtil");
    
test bool shouldTransformRepositoryTypeToPhpTypeName()
    = toPhpTypeName(repository(fullName("User", namespace("Example"), "User"))) == phpName("UserRepository");
    
