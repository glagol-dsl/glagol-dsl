module Test::Parser::Entity::Annotations

import Parser::ParseAST;
import Syntax::Abstract::AST;
import Prelude;

test bool testShouldParseTableNameAnnotationForEntity()
{
    str code = "module Example;
               '@table(name=users)
               'entity User {}";

    return parseModule(code) == \module("Example", {}, entity({annoTable("users")}, "User"));
}

test bool testShouldParseIndexesAnnotationForEntity()
{
    str code = "module Example;
               '@index(my_index, {name, email})
               '@index(second_index, {quantity, total})
               'entity User {}";

    Artifact expectedEntity = entity({index("my_index", {"name", "email"}), index("second_index", {"quantity", "total"})}, "User");

    return parseModule(code) == \module("Example", {}, expectedEntity);
}

test bool testShouldParseCompositeAnnotationForEntity()
{
    str code = "module Example;
               '@index(my_index, {name, email})
               '@index(second_index, {quantity, total})
               '@table(name=my_users_table)
               'entity User {}";

    Artifact expectedEntity = entity(
        {
            index("my_index", {"name", "email"}),
            index("second_index", {"quantity", "total"}),
            annoTable("my_users_table")
        }, "User");

    return parseModule(code) == \module("Example", {}, expectedEntity);
}
