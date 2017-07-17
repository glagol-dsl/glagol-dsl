module Test::Typechecker::Route

import Typechecker::Route;
import Typechecker::Env;
import Syntax::Abstract::Glagol;

test bool shouldGiveErrorsOnDuplicatingRoutes() = 
    checkRoute(route([routePart("index")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], 
    	addToAST([
	        file(|tmp:///BlahController.g|, \module(namespace("Test"), [], controller("BlahController", jsonApi(), route([routePart("index")])[@src=|tmp:///BlahController.g|(0, 0, <20, 20>, <30, 30>)], []))),
	        file(|tmp:///BlahaController.g|, \module(namespace("Test"), [], controller("BlahaController", jsonApi(), route([routePart("index")])[@src=|tmp:///BlahaController.g|(0, 0, <20, 20>, <30, 30>)], []))),
	        file(|tmp:///IndexController.g|, \module(namespace("Test"), [], controller("IndexController", jsonApi(), route([routePart("index")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], [])))
	    ], newEnv(|tmp:///IndexController.g|))
    ) == 
    addError(route([routePart("index")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], "Route /index is duplicated",
    addToAST([
	        file(|tmp:///BlahController.g|, \module(namespace("Test"), [], controller("BlahController", jsonApi(), route([routePart("index")])[@src=|tmp:///BlahController.g|(0, 0, <20, 20>, <30, 30>)], []))),
	        file(|tmp:///BlahaController.g|, \module(namespace("Test"), [], controller("BlahaController", jsonApi(), route([routePart("index")])[@src=|tmp:///BlahaController.g|(0, 0, <20, 20>, <30, 30>)], []))),
	        file(|tmp:///IndexController.g|, \module(namespace("Test"), [], controller("IndexController", jsonApi(), route([routePart("index")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], [])))
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

test bool shouldGiveErrorsOnDuplicatingRouteVars() = 
    checkRouteParts(route([routePart("index"), routeVar("pageId"), routePart("index"), routeVar("pageId")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], 
    	newEnv(|tmp:///IndexController.g|)
    ) == 
    addError(route([routePart("index"), routeVar("pageId"), routePart("index"), routeVar("pageId")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], 
    	"Route /index/:pageId/index/:pageId has duplicated var placeholders",
	    newEnv(|tmp:///IndexController.g|));
	    
test bool shouldNotGiveErrorsOnNonDuplicatingRouteVars() = 
    checkRouteParts(route([routePart("index"), routeVar("pageId"), routePart("index"), routeVar("id")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], 
    	newEnv(|tmp:///IndexController.g|)
    ) == newEnv(|tmp:///IndexController.g|);
    
