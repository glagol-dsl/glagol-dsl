module Test::Typechecker::Route

import Typechecker::Route;
import Syntax::Abstract::Glagol;

test bool shouldGiveErrorsOnDuplicatingRoutes() = 
	checkRoute(route([routePart("/")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], <|tmp:///IndexController.g|, (), (), [
		file(|tmp:///BlahController.g|, \module(namespace("Test"), [], controller("BlahController", jsonApi(), route([routePart("/")])[@src=|tmp:///BlahController.g|(0, 0, <20, 20>, <30, 30>)], []))),
		file(|tmp:///BlahaController.g|, \module(namespace("Test"), [], controller("BlahaController", jsonApi(), route([routePart("/")])[@src=|tmp:///BlahaController.g|(0, 0, <20, 20>, <30, 30>)], []))),
		file(|tmp:///BlahaController.g|, \module(namespace("Test"), [], controller("IndexController", jsonApi(), route([routePart("/")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], [])))
	], []>) == 
	<|tmp:///IndexController.g|, (), (), [
		file(|tmp:///BlahController.g|, \module(namespace("Test"), [], controller("BlahController", jsonApi(), route([routePart("/")])[@src=|tmp:///BlahController.g|(0, 0, <20, 20>, <30, 30>)], []))),
		file(|tmp:///BlahaController.g|, \module(namespace("Test"), [], controller("BlahaController", jsonApi(), route([routePart("/")])[@src=|tmp:///BlahaController.g|(0, 0, <20, 20>, <30, 30>)], []))),
		file(|tmp:///BlahaController.g|, \module(namespace("Test"), [], controller("IndexController", jsonApi(), route([routePart("/")])[@src=|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>)], [])))
	], [
		<|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>), "Duplicated route in /BlahController.g on line 20">,
		<|tmp:///IndexController.g|(0, 0, <10, 10>, <30, 30>), "Duplicated route in /BlahaController.g on line 20">
	]>;
