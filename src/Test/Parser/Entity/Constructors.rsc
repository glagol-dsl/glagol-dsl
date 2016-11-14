module Test::Parser::Entity::Constructors

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool shouldParseConstructWithOneParam()
{
    str code 
        = "namespace Example;
          'entity User {
          '    User(int param) {
          '    }
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "param")], [])
    ]));
}

test bool shouldParseConstructWithOneAnnotatedParam()
{
    str code 
        = "namespace Example;
          'entity User {
          '    User(@anno int param) {
          '    }
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([annotated([annotation("anno", [])], param(integer(), "param"))], [])
    ]));
}

test bool shouldParseConstructWithOneAnnotatedParamAndOneSimple()
{
    str code 
        = "namespace Example;
          'entity User {
          '    User(@anno int param, int param2) {
          '    }
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([annotated([annotation("anno", [])], param(integer(), "param")), param(integer(), "param2")], [])
    ]));
}

test bool shouldParseAnnotatedConstructWithOneParam()
{
    str code 
        = "namespace Example;
          'entity User {
          '    @doc(\"This is a doc\")
          '    User(int param) {
          '    }
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        annotated([annotation("doc", [annotationVal("This is a doc")])], constructor([param(integer(), "param")], []))
    ]));
}

test bool shouldFailWhenInvalidConstructorNameIsUsed()
{
    str code 
        = "namespace Example;
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
        = "namespace Example;
          'entity User {
          '    User(int param, float param2 = 0.55, bool param3 = true) {
          '    }
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([
            param(integer(), "param"),
            param(float(), "param2", floatLiteral(0.55)),
            param(boolean(), "param3", boolLiteral(true))
        ], [])
    ]));
}

test bool shouldParseConstructWithBody()
{
    str code 
        = "namespace Example;
          'entity User {
          '    User(int param, float param2 = 0.55, bool param3 = true) {
          '        param + param2;
          '        param3 = param \> param2;
          '    }
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([
            param(integer(), "param"),
            param(float(), "param2", floatLiteral(0.55)),
            param(boolean(), "param3", boolLiteral(true))
        ], [
            expression(addition(variable("param"), variable("param2"))),
            assign(variable("param3"), defaultAssign(), expression(greaterThan(variable("param"), variable("param2"))))
        ])
    ]));
}

test bool shouldParseConstructWithoutParams()
{
    str code 
        = "namespace Example;
          'entity User {
          '    User() {
          '    }
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([], [])
    ]));
}

test bool shouldParseConstructWithoutBody()
{
    str code 
        = "namespace Example;
          'entity User {
          '    User();
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([], [])
    ]));
}

test bool shouldParseConstructWithoutBodyWithParams()
{
    str code 
        = "namespace Example;
          'entity User {
          '    User(int param, float param2 = 0.55, bool param3 = true);
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([
            param(integer(), "param"),
            param(float(), "param2", floatLiteral(0.55)),
            param(boolean(), "param3", boolLiteral(true))
        ], [])
    ]));
}

test bool shouldParseConstructWithWhen()
{
    str code 
        = "namespace Example;
          'entity User {
          '    User(int param) {
          '        
          '    } when param \> 3 && param \<= 11;
          '}";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([
                param(integer(), "param")
            ], [], and(
                greaterThan(variable("param"), intLiteral(3)),
                lessThanOrEq(variable("param"), intLiteral(11))
            )
        )
    ]));
}
