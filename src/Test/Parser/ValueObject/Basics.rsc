module Test::Parser::ValueObject::Basics

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool shouldParseEmptyValueObject()
{
    str code 
        = "module Testing;
        'value DateTime {}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), {}, valueObject("DateTime", {}));
}
