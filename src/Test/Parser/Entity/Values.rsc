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
        \value(integer(), "id", {get()}),
        \value(artifactType("Date"), "addedOn", {get(), \set()})
    };

    return parseModule(code) == \module("Example", {}, entity("User", expectedValues));
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

    return parseModule(code) == \module("Example", {}, entity("User", {
        annotated({
            annotation(field(), options(("key": "primary", "sequence": "true", "type": "int", "size": "11", "column": "id")))
        }, \value(integer(), "id", {get()}))
    }));
}
