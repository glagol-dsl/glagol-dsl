module Test::Parser::Entity::Constructors

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool shouldParseConstructWithOneParam()
{
    str code 
        = "namespace Example
          'entity User {
          '    User(int param) {
          '    }
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "param", emptyExpr())], [], emptyExpr())
    ]));
}

test bool shouldParseConstructWithOneAnnotatedParam()
{
    str code 
        = "namespace Example
          'entity User {
          '    User(@anno int param) {
          '    }
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "param", emptyExpr())], [], emptyExpr())
    ])) && parseModule(code).artifact.declarations[0].params[0]@annotations==[annotation("anno", [])];
}

test bool shouldParseConstructWithOneAnnotatedParamAndOneSimple()
{
    str code 
        = "namespace Example
          'entity User {
          '    User(@anno int param, int param2) {
          '    }
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "param", emptyExpr()), param(integer(), "param2", emptyExpr())], [], emptyExpr())
    ])) && parseModule(code).artifact.declarations[0].params[0]@annotations==[annotation("anno", [])];
}

test bool shouldParseAnnotatedConstructWithOneParam()
{
    str code 
        = "namespace Example
          'entity User {
          '    @doc(\"This is a doc\")
          '    User(int param) {
          '    }
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([param(integer(), "param", emptyExpr())], [], emptyExpr())
    ])) && parseModule(code).artifact.declarations[0]@annotations==[annotation("doc", [annotationVal("This is a doc")])];
}

test bool shouldFailWhenInvalidConstructorNameIsUsed()
{
    str code 
        = "namespace Example
          'entity User {
          '    UserFail(int param) {
          '    }
          '}
          '";
    
    try parseModule(code);
    catch IllegalConstructorName(_, _): return true;
    
    return false;
}

test bool shouldParseConstructWithTwoParamsAndDefaultValue()
{
    str code 
        = "namespace Example
          'entity User {
          '    User(int param, float param2, bool param3) {
          '    }
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([
            param(integer(), "param", emptyExpr()),
            param(float(), "param2", emptyExpr()),
            param(boolean(), "param3", emptyExpr())
        ], [], emptyExpr())
    ]));
}

test bool shouldParseConstructWithBody()
{
    str code 
        = "namespace Example
          'entity User {
          '    User(int param, float param2, bool param3) {
          '        param + param2;
          '        param3 = param \> param2;
          '    }
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([
            param(integer(), "param", emptyExpr()),
            param(float(), "param2", emptyExpr()),
            param(boolean(), "param3", emptyExpr())
        ], [
            expression(addition(variable("param"), variable("param2"))),
            assign(variable("param3"), defaultAssign(), expression(greaterThan(variable("param"), variable("param2"))))
        ], emptyExpr())
    ]));
}

test bool shouldParseConstructWithoutParams()
{
    str code 
        = "namespace Example
          'entity User {
          '    User() {
          '    }
          '}
          '";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([], [], emptyExpr())
    ]));
}

test bool shouldParseConstructWithWhen()
{
    str code 
        = "namespace Example
          'entity User {
          '    User(int param) {
          '        
          '    } when param \> 3 && param \<= 11;
          '}";
    
    return parseModule(code) == \module(namespace("Example"), [], entity("User", [
        constructor([
                param(integer(), "param", emptyExpr())
            ], [], and(
                greaterThan(variable("param"), integer(3)),
                lessThanOrEq(variable("param"), integer(11))
            )
        )
    ]));
}
