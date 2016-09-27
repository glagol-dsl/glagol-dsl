module Test::Parser::Entity::Properties

import Parser::ParseAST;
import Syntax::Abstract::AST;

test bool testShouldParseEntityWithValues()
{
    str code = "module Example;
               'entity User {
               '    int id with {get};
               '    Date addedOn with {get, set};
               '}";
               
    set[Declaration] expectedValues = {
        property(integer(), "id", {read()}),
        property(artifactType("Date"), "addedOn", {read(), \set()})
    };

    return parseModule(code) == \module(namespace("Example"), {}, entity("User", expectedValues));
}


test bool testShouldParseEntityWithValuesAndAnnotations()
{
    str code = "module Example;
               'entity User {
               '    @field({
               '        key: primary,
               '        sequence: true,
               '        type: int,
               '        size: 11,
               '        column: \"id\"
               '    })
               '    int id with {get};
               '}";

    return parseModule(code) == \module(namespace("Example"), {}, entity("User", {
        annotated({
            annotation("field", [
                annotationMap((
                    "key": annotationValPrimary(), 
                    "sequence": annotationVal(true), 
                    "type": annotationVal(integer()), 
                    "size": annotationVal(11), 
                    "column": annotationVal("id")
                ))
            ])
        }, property(integer(), "id", {read()}))
    }));
}
