module Test::Parser::Entity::Properties

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool testShouldParseEntityWithValues()
{
    str code = "namespace Example
               'entity User {
               '    int id with {get};
               '    Date addedOn with {get, set};
               '}";
               
    list[Declaration] expectedValues = [
        property(integer(), "id", {read()}, emptyExpr()),
        property(artifact("Date"), "addedOn", {read(), \set()}, emptyExpr())
    ];

    return parseModule(code) == \module(namespace("Example"), [], entity("User", expectedValues));
}


test bool testShouldParseEntityWithValuesAndAnnotations()
{
    str code = "namespace Example
               'entity User {
               '    @column({
               '        key: primary,
               '        sequence: true,
               '        type: int,
               '        size: 11,
               '        column: \"id\"
               '    })
               '    float id with {get};
               '
               '    @column({
               '        key: primary,
               '        sequence: true,
               '        size: 11,
               '        column: \"id\"
               '    })
               '    string id with {get};
               '
               '    @column={type: int}
               '    Weight id;
               '}";

    return 
    	parseModule(code) == \module(namespace("Example"), [], entity("User", [
    	   property(float(), "id", {read()}, emptyExpr()), 
           property(string(), "id", {read()}, emptyExpr()), 
           property(artifact("Weight"), "id", {}, emptyExpr())
	   ])) &&
    	parseModule(code).artifact.declarations[0]@annotations == [
            annotation("column", [
                annotationMap((
                    "key": annotationValPrimary(), 
                    "sequence": annotationVal(true), 
                    "type": annotationVal(integer()), 
                    "size": annotationVal(11), 
                    "column": annotationVal("id")
                ))
            ])
        ] &&
        parseModule(code).artifact.declarations[1]@annotations == [
            annotation("column", [
                annotationMap((
                    "key": annotationValPrimary(), 
                    "sequence": annotationVal(true), 
                    "type": annotationVal(string()), 
                    "size": annotationVal(11), 
                    "column": annotationVal("id")
                ))
            ])
        ] &&
        parseModule(code).artifact.declarations[2]@annotations == [
            annotation("column", [
                annotationMap((
                    "type": annotationVal(integer())
                ))
            ])
        ];
}
