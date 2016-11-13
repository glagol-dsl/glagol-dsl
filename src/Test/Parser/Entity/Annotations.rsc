module Test::Parser::Entity::Annotations

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool testShouldParseTableNameAnnotationForEntity()
{
    str code = "namespace Example;
               '@table(\"users\")
               'entity User { }";

    return parseModule(code) == \module(namespace("Example"), [],
        annotated([annotation("table", [annotationVal("users")])], entity("User", [])));
}

test bool testShouldParseIndexesAnnotationForEntity()
{
    str code = "namespace Example;
               '@index(\"my_index\", [\"name\", \"email\"])
               '@index(\"second_index\", [\"quantity\", \"total\"])
               'entity User { }";

    Declaration expectedEntity = annotated([
        annotation("index", [annotationVal("my_index"), annotationVal([annotationVal("name"), annotationVal("email")])]),
        annotation("index", [annotationVal("second_index"), annotationVal([annotationVal("quantity"), annotationVal("total")])])
    ], entity("User", []));

    return parseModule(code) == \module(namespace("Example"), [], expectedEntity);
}

test bool testShouldParseCompositeAnnotationForEntity()
{
    str code = "namespace Example;
               '@index(\"my_index\", [\"name\", \"email\"])
               '@index(\"second_index\", [\"quantity\", \"total\"])
               '@table(\"my_users_table\")
               'entity User { }";

    Declaration expectedEntity = annotated([
        annotation("index", [annotationVal("my_index"), annotationVal([annotationVal("name"), annotationVal("email")])]),
        annotation("index", [annotationVal("second_index"), annotationVal([annotationVal("quantity"), annotationVal("total")])]),
        annotation("table", [annotationVal("my_users_table")])
    ], entity("User", []));

    return parseModule(code) == \module(namespace("Example"), [], expectedEntity);
}
