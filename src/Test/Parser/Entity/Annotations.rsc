module Test::Parser::Entity::Annotations

import Parser::ParseAST;
import Syntax::Abstract::AST;
import IO;

test bool testShouldParseTableNameAnnotationForEntity()
{
    str code = "module Example;
               '@table(name: users)
               'entity User { }";

    return parseModule(code) == \module("Example", {}, 
        annotated({annotation(table("users"))}, entity("User", {})));
}

test bool testShouldParseIndexesAnnotationForEntity()
{
    str code = "module Example;
               '@index(my_index, {name, email})
               '@index(second_index, {quantity, total})
               'entity User { }";

    Declaration expectedEntity = annotated({
        annotation(index("my_index"), fields(["name", "email"])),
        annotation(index("second_index"), fields(["quantity", "total"]))
    }, entity("User", {}));

    return parseModule(code) == \module("Example", {}, expectedEntity);
}

test bool testShouldParseCompositeAnnotationForEntity()
{
    str code = "module Example;
               '@index(my_index, {name, email})
               '@index(second_index, {quantity, total})
               '@table(name: my_users_table)
               'entity User { }";

    Declaration expectedEntity = annotated({
        annotation(index("my_index"), fields(["name", "email"])),
        annotation(index("second_index"), fields(["quantity", "total"])),
        annotation(table("my_users_table"))
    }, entity("User", {}));

    return parseModule(code) == \module("Example", {}, expectedEntity);
}
