module Test::Parser::Entity::Constructors

import Parser::ParseAST;
import Syntax::Abstract::AST;

test bool shouldParseConstructWithOneParam()
{
    str code 
        = "module Example;
          'entity User {
          '    User(int param) {
          '    }
          '}
          '";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([param(integer(), "param")], [])
    }));
}

test bool shouldFailWhenInvalidConstructorNameIsUsed()
{
    str code 
        = "module Example;
          'entity User {
          '    UserFail(int param) {
          '    }
          '}
          '";
    
    try parseModule(code);
    catch IllegalConstructorName(_): return true;
    
    return false;
}

test bool shouldParseConstructWithTwoParamsAndDefaultValue()
{
    str code 
        = "module Example;
          'entity User {
          '    User(int param, float param2 = 0.55, bool param3 = true) {
          '    }
          '}
          '";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([
            param(integer(), "param"),
            param(float(), "param2", floatLiteral(0.55)),
            param(boolean(), "param3", boolLiteral(true))
        ], [])
    }));
}

test bool shouldParseConstructWithBody()
{
    str code 
        = "module Example;
          'entity User {
          '    User(int param, float param2 = 0.55, bool param3 = true) {
          '        param + param2;
          '        param3 = param \> param2;
          '    }
          '}
          '";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([
            param(integer(), "param"),
            param(float(), "param2", floatLiteral(0.55)),
            param(boolean(), "param3", boolLiteral(true))
        ], [
            expression(addition(variable("param"), variable("param2"))),
            assign(variable("param3"), defaultAssign(), expression(greaterThan(variable("param"), variable("param2"))))
        ])
    }));
}

test bool shouldParseConstructWithoutParams()
{
    str code 
        = "module Example;
          'entity User {
          '    User() {
          '    }
          '}
          '";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([], [])
    }));
}

test bool shouldParseConstructWithoutBody()
{
    str code 
        = "module Example;
          'entity User {
          '    User();
          '}
          '";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([], [])
    }));
}

test bool shouldParseConstructWithoutBodyWithParams()
{
    str code 
        = "module Example;
          'entity User {
          '    User(int param, float param2 = 0.55, bool param3 = true);
          '}
          '";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([
            param(integer(), "param"),
            param(float(), "param2", floatLiteral(0.55)),
            param(boolean(), "param3", boolLiteral(true))
        ], [])
    }));
}

test bool shouldParseConstructWithWhen()
{
    str code 
        = "module Example;
          'entity User {
          '    User(int param) {
          '        
          '    } when param \> 3 && param \<= 11;
          '}
          '";
    
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([
                param(integer(), "param")
            ], [], and(
                greaterThan(variable("param"), intLiteral(3)),
                lessThanOrEq(variable("param"), intLiteral(11))
            )
        )
    }));
}
