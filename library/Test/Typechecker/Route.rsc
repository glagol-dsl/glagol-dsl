module Test::Typechecker::Route

import Typechecker::Route;
import Typechecker::Env;
import Syntax::Abstract::Glagol;

test bool shouldGiveErrorsOnDuplicatingRoutes() = 
    checkRoute(route([routePart("/")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], 
    	addToAST([
	        file(|tmp:///BlahController.g|, \module(namespace("Test"), [], controller("BlahController", jsonApi(), route([routePart("/")])[@src=|tmp:///BlahController.g|(0, 0, <20, 20>, <30, 30>)], []))),
	        file(|tmp:///BlahaController.g|, \module(namespace("Test"), [], controller("BlahaController", jsonApi(), route([routePart("/")])[@src=|tmp:///BlahaController.g|(0, 0, <20, 20>, <30, 30>)], []))),
	        file(|tmp:///IndexController.g|, \module(namespace("Test"), [], controller("IndexController", jsonApi(), route([routePart("/")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], [])))
	    ], newEnv(|tmp:///IndexController.g|))
    ) == 
    addErrors([
        <|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>), "Duplicated route in /BlahController.g on line 20">,
        <|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>), "Duplicated route in /BlahaController.g on line 20">
    ],
    addToAST([
	        file(|tmp:///BlahController.g|, \module(namespace("Test"), [], controller("BlahController", jsonApi(), route([routePart("/")])[@src=|tmp:///BlahController.g|(0, 0, <20, 20>, <30, 30>)], []))),
	        file(|tmp:///BlahaController.g|, \module(namespace("Test"), [], controller("BlahaController", jsonApi(), route([routePart("/")])[@src=|tmp:///BlahaController.g|(0, 0, <20, 20>, <30, 30>)], []))),
	        file(|tmp:///IndexController.g|, \module(namespace("Test"), [], controller("IndexController", jsonApi(), route([routePart("/")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], [])))
	    ], newEnv(|tmp:///IndexController.g|)));

test bool shouldNotGiveErrorsOnNonDuplicatingRoutes() = 
    checkRoute(route([routePart("/")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], 
	    addToAST([
	        file(|tmp:///BlahController.g|, \module(namespace("Test"), [], controller("BlahController", jsonApi(), route([routePart("/blah")])[@src=|tmp:///BlahController.g|(0, 0, <20, 20>, <30, 30>)], []))),
	        file(|tmp:///BlahaController.g|, \module(namespace("Test"), [], controller("BlahaController", jsonApi(), route([routePart("/blaha")])[@src=|tmp:///BlahaController.g|(0, 0, <20, 20>, <30, 30>)], []))),
	        file(|tmp:///IndexController.g|, \module(namespace("Test"), [], controller("IndexController", jsonApi(), route([routePart("/index")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], [])))
	    ], newEnv(|tmp:///IndexController.g|))
    ) == 
    addToAST([
	        file(|tmp:///BlahController.g|, \module(namespace("Test"), [], controller("BlahController", jsonApi(), route([routePart("/blah")])[@src=|tmp:///BlahController.g|(0, 0, <20, 20>, <30, 30>)], []))),
	        file(|tmp:///BlahaController.g|, \module(namespace("Test"), [], controller("BlahaController", jsonApi(), route([routePart("/blaha")])[@src=|tmp:///BlahaController.g|(0, 0, <20, 20>, <30, 30>)], []))),
	        file(|tmp:///IndexController.g|, \module(namespace("Test"), [], controller("IndexController", jsonApi(), route([routePart("/index")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], [])))
	    ], newEnv(|tmp:///IndexController.g|));
