module Test::Parser::Util::Basics

import Syntax::Abstract::Glagol;
import Parser::ParseAST;

test bool shouldParseEmptyUtil()
{
    str code 
        = "namespace Test
          'util UserCreator {}";
          
    return parseModule(code) == \module(namespace("Test"), [], util("UserCreator", [], notProxy()));
}

test bool shouldParseUtilUsingTheServiceKeyword()
{
    str code 
        = "namespace Test
          'service UserCreator {}";
          
    return parseModule(code) == \module(namespace("Test"), [], util("UserCreator", [], notProxy()));
}

test bool testShouldParseFlatDocAnnotationForUtil()
{
    str code = "namespace Example
               '@doc=\"This is a doc\"
               'util UserCreator { }";

    Declaration expectedEntity = util("UserCreator", [], notProxy());

    return 
    	parseModule(code) == \module(namespace("Example"), [], expectedEntity) &&
    	parseModule(code).artifact@annotations == [annotation("doc", [annotationVal("This is a doc")])];
}

test bool shouldNotAllowUtilConstructor()
{
    str code = "namespace Example
               '@doc=\"This is a doc\"
               'util UserCreator {
               '    UserCreator() {}
               '}";
    
    try parseModule(code);
    catch ConstructorNotAllowed("Constructor not allowed for util/service artifacts", loc at): return true;
    
    return false;
}

test bool shouldNotAllowServiceConstructor()
{
    str code = "namespace Example
               '@doc=\"This is a doc\"
               'service UserCreator {
               '    UserCreator() {}
               '}";
    
    try parseModule(code);
    catch ConstructorNotAllowed("Constructor not allowed for util/service artifacts", loc at): return true;
    
    return false;
}
