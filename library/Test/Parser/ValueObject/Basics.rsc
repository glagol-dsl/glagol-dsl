module Test::Parser::ValueObject::Basics

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool shouldParseEmptyValueObject()
{
    str code 
        = "namespace Testing
        'value DateTime {}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], valueObject("DateTime", [], notProxy()));
}

test bool testShouldParseFlatDocAnnotationForVO()
{
    str code = "namespace Example
               '@doc=\"This is a doc\"
               'value DateTime { }";

    Declaration expectedEntity = valueObject("DateTime", [], notProxy());

    return 
    	parseModule(code) == \module(namespace("Example"), [], expectedEntity) &&
    	parseModule(code).artifact@annotations == [annotation("doc", [annotationVal("This is a doc")])];
}
