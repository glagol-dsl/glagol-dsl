module Test::Parser::Entity::Annotations

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool testShouldParseTableNameAnnotationForEntity()
{
    str code = "namespace Example;
               '@table(\"users\")
               'entity User { }";

    return 
    	parseModule(code) == \module(namespace("Example"), [], entity("User", [])) && 
        parseModule(code).artifact@annotations == [annotation("table", [annotationVal("users")])];
}

test bool testShouldParseIndexesAnnotationForEntity()
{
    str code = "namespace Example;
               '@index(\"my_index\", [\"name\", \"email\"])
               '@index(\"second_index\", [\"quantity\", \"total\"])
               'entity User { }";

    Declaration expectedEntity = entity("User", []);

    return 
    	parseModule(code) == \module(namespace("Example"), [], expectedEntity) &&
    	parseModule(code).artifact@annotations == [
	        annotation("index", [annotationVal("my_index"), annotationVal([annotationVal("name"), annotationVal("email")])]),
	        annotation("index", [annotationVal("second_index"), annotationVal([annotationVal("quantity"), annotationVal("total")])])
	    ];
}

test bool testShouldParseCompositeAnnotationForEntity()
{
    str code = "namespace Example;
               '@index(\"my_index\", [\"name\", \"email\"])
               '@index(\"second_index\", [\"quantity\", \"total\"])
               '@table(\"my_users_table\")
               'entity User { }";

    Declaration expectedEntity = entity("User", []);

    return 
    	parseModule(code) == \module(namespace("Example"), [], expectedEntity) && 
    	parseModule(code).artifact@annotations == [
	        annotation("index", [annotationVal("my_index"), annotationVal([annotationVal("name"), annotationVal("email")])]),
	        annotation("index", [annotationVal("second_index"), annotationVal([annotationVal("quantity"), annotationVal("total")])]),
	        annotation("table", [annotationVal("my_users_table")])
	    ];
}

test bool testShouldParseFlatDocAnnotationForEntity()
{
    str code = "namespace Example;
               '@doc=\"This is a doc\"
               'entity User { }";

    Declaration expectedEntity = entity("User", []);

    return 
    	parseModule(code) == \module(namespace("Example"), [], expectedEntity) &&
    	parseModule(code).artifact@annotations == [
	        annotation("doc", [annotationVal("This is a doc")])
	    ];
}
