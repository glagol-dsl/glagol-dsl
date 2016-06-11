module Test::Parser::Entity::Annotations

import Parser::ParseAST;
import Syntax::Abstract::AST;
import IO;

test bool testShouldParseTableNameAnnotationForEntity()
{
    str code = "module Example;
               '@table(name: users)
               'entity User { }";

    return parseModule(code) == \module("Example", {}, entity("User", {annotation(table("users"))}));
}

test bool testShouldParseIndexesAnnotationForEntity()
{
    str code = "module Example;
               '@index(my_index, {name, email})
               '@index(second_index, {quantity, total})
               'entity User { }";

    Declaration expectedEntity = entity("User", {
        annotation(index("my_index"), fields(["name", "email"])),
        annotation(index("second_index"), fields(["quantity", "total"]))
    });

    return parseModule(code) == \module("Example", {}, expectedEntity);
}

test bool testShouldParseCompositeAnnotationForEntity()
{
    str code = "module Example;
               '@index(my_index, {name, email})
               '@index(second_index, {quantity, total})
               '@table(name: my_users_table)
               'entity User { }";

    Declaration expectedEntity = entity("User", {
        annotation(index("my_index"), fields(["name", "email"])),
        annotation(index("second_index"), fields(["quantity", "total"])),
        annotation(table("my_users_table"))
    });

    return parseModule(code) == \module("Example", {}, expectedEntity);
}
