module Test::Parser::ValueObject::Basics

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool shouldParseEmptyValueObject()
{
    str code 
        = "namespace Testing;
        'value DateTime {}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], valueObject("DateTime", []));
}

test bool testShouldParseFlatDocAnnotationForVO()
{
    str code = "namespace Example;
               '@doc=\"This is a doc\"
               'value DateTime { }";

    Declaration expectedEntity = annotated([
        annotation("doc", [annotationVal("This is a doc")])
    ], valueObject("DateTime", []));

    return parseModule(code) == \module(namespace("Example"), [], expectedEntity);
}
