module Test::Parser::Entity::Values

import Parser::ParseAST;
import Syntax::Abstract::AST;
import Prelude;

test bool testShouldParseEntityWithValues()
{
    str code = "module Example;
               'entity User {
               '    value int id with {get};
               '    value Date addedOn with {get, set};
               '}";
    set[Declaration] expectedValues = {
        entityValue({}, integer(), "id", properties({"get"})),
        entityValue({}, artifactType("Date"), "addedOn", properties({"get", "set"}))
    };

    return parseModule(code) == \module("Example", {}, entity({}, "User", expectedValues));
}

test bool testShouldParseEntityWithValuesAndAnnotations()
{
    str code = "module Example;
               'entity User {
               '    @field(
               '        key: primary,
               '        sequence: true,
               '        type: int,
               '        size: 11,
               '        column: id
               '    )
               '    value int id with {get};
               '}";
    
    set[Declaration] expectedValues = {
        entityValue({
            annoField({
                annoPair("key", "primary"),
                // TODO make it use booleans too
                annoPair("sequence", "true"),
                annoPair("type", "int"),
                annoPair("size", "11"),
                annoPair("column", "id")
            })
        }, integer(), "id", properties({"get"}))
    };
    
    return parseModule(code) == \module("Example", {}, entity({}, "User", expectedValues));
}
