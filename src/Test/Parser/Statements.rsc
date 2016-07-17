module Test::Parser::Statements

import Parser::ParseAST;
import Syntax::Abstract::AST;

test bool testDeclarationsWithPrimitiveTypes() {
    str code
        = "module Example;
        'entity User {
        '   User() {
        '       float myVariable = 5.4;
        '       int yourVariable = 23;
        '       string myString = \"hello world\";
        '       boolean withExpr = myVariable \> yourVariable;
        '   }
        '}";
        
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([], [
            declare(float(), variable("myVariable"), floatLiteral(5.4)),
            declare(integer(), variable("yourVariable"), intLiteral(23)),
            declare(string(), variable("myString"), strLiteral("hello world")),
            declare(boolean(), variable("withExpr"), greaterThan(variable("myVariable"), variable("yourVariable")))
        ])
    }));
}

test bool testDeclarationsWithoutDefaultValue() {
    str code
        = "module Example;
        'entity User {
        '   User() {
        '       float myVariable;
        '       int yourVariable;
        '       
        '       yourVariable = yourVariable + 5;
        '   }
        '}";
        
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([], [
            declare(float(), variable("myVariable")),
            declare(integer(), variable("yourVariable")),
            assign(variable("yourVariable"), defaultAssign(), expression(addition(variable("yourVariable"), intLiteral(5))))
        ])
    }));
}

test bool testDeclarationsWithCustomTypes() {
    str code
        = "module Example;
        'entity User {
        '   User() {
        '       DateTime myDate;
        '   }
        '}";
        
    return parseModule(code) == \module("Example", {}, entity("User", {
        constructor([], [
            declare(artifactType("DateTime"), variable("myDate"))
        ])
    }));
}
