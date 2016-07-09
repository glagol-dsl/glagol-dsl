module Test::Parser::Entity::Constructors

import Parser::ParseAST;
import Syntax::Abstract::AST;
import Prelude;

test bool shouldParseConstructWithOneParam()
{
    str code 
        = "module Example;
          'entity User {
          '    construct(int param) {
          '    }
          '}
          '";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([param(integer(), "param")])
    }));
}

test bool shouldParseConstructWithTwoParamsAndDefaultValue()
{
    str code 
        = "module Example;
          'entity User {
          '    construct(int param, float param2 = 0.55, bool param3 = true) {
          '    }
          '}
          '";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([
            param(integer(), "param"),
            param(float(), "param2", floatLiteral(0.55)),
            param(boolean(), "param3", boolLiteral(true))
        ])
    }));
}

test bool shouldParseConstructWithoutParams()
{
    str code 
        = "module Example;
          'entity User {
          '    construct() {
          '    }
          '}
          '";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([])
    }));
}

test bool shouldParseConstructWithoutBody()
{
    str code 
        = "module Example;
          'entity User {
          '    construct();
          '}
          '";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([])
    }));
}

test bool shouldParseConstructWithoutBodyWithParams()
{
    str code 
        = "module Example;
          'entity User {
          '    construct(int param, float param2 = 0.55, bool param3 = true);
          '}
          '";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([
            param(integer(), "param"),
            param(float(), "param2", floatLiteral(0.55)),
            param(boolean(), "param3", boolLiteral(true))
        ])
    }));
}
