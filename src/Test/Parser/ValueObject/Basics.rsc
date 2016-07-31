module Test::Parser::ValueObject::Basics

import Parser::ParseAST;
import Syntax::Abstract::AST;

test bool shouldParseEmptyValueObject()
{
    str code 
        = "module Testing;
        'value DateTime {}
        '";
        
    return parseModule(code) == \module("Testing", {}, valueObject("DateTime", {}));
}
