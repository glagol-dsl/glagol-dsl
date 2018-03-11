module Test::Typechecker::Method

import Typechecker::Method;
import Typechecker::Env;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;

/*
                          ╥╥╗╤══ ╓ ╓▄╓                      
                 ▄▄▄██████░  ╓▄╩░  ╓╬██████▄▄               
               ╟██░╙▀▀╙╙╦─░ ╬██╦╩─ ╩╠ ░ ▀  ╙█▀▓▄            
              ╔██░▄██▄▓▄███▄█████▓███▄██░ ╓▓░╝└█▌           
             ▄██▀╔███▀▀▀▀▀▀▀╙╙████████████████▓░╙█▄         
            ╔█████▀─                  ╙▀████████╦██╕        
           ╓█████┴                       ▀███████╕██        
          ╠╬███▀                             ▀████▄█▌       
          ║███░                              ╔███████▄      
          ║███     ╓─╓╓                       ████████▌     
          ▀███░╔╩╫███████▄  ╔█████████▄▄      ████████▀     
      ╚░ ░░╙▀█░╠▓▓▄▄█████▀  ╙███████▄▌▀██╦    ████████      
      ░  ░░░ ╙ ╚▀▀▀▀░░╙╙░     ╙╙▀▀▀▀ ╙╙╙▀─    ║██████┘      
░░  ░  ░     ╦     ╨╨╙             ╨╨╙        ║██▀███       
░   ░░░  ░░░░╚░        ░                       ╙█▌╚▀        
╦╦░░░░░░░░░░░░╫░      ║▄░▄▄▄▄▄                  ▀╨╔         
░░░░░░░░░░╩░░░╫╦░     ╙▀▀██████░             ╔╥  ╩          
░╫░╦░░░╫╫░╫╫░░╫▌░    ░░░░╙░╙░░               ╔▄╓═           
░░░░░░╦╬╫╫╦░╦░╫▓░░░░░╓▄██▄▄██▄▄▄░           ╔╟█▌            
╫░░╫╫╫╬╫╫╫╫╫╫╦░█▓░░▓██▀▀▀▀░▀╙▀▀▀▀██▌    ╦╦╫╦▓▓░░  ╦         
░░░╦╫╫╫╫╫╫▓╫╫╫╦╠██╬╫╫╬▓▓███████▓▓▓╫╫╗╦╦╬╫▓▓███░░╦░░         
░░░╫╫╫╫╬▓╫╬▓▓▓╫░╠██▓╫╫▀▀▀╨░░╙╙╙╙▀▀╬╫╫╫▓████▌╫▌╨░╚ ╨ ╒       
╦╦╫╫╫╫╫╫▓▓╫▓╫▓╫╫╫╫███╦░░░░░░░░   ╔╠╫▓█████░╫▓░              
╫╫╫╫╫╫╫╫╫╫╫░╬╬╫░╫╫█████▄██▓█████▓██████▓╫╫╫▓█░─░            
╫╫╫╫╫╫╫░░░░░░░▒▓██░╙▓▓██████████████▀░░╫╫╫╫▓██▄╫░╦═░░       
╫╫╫╫╫╫░╫╫▒▄██████░░░╙▀████████████░░░░╚░╫╫╫┘╟███▓░╫░░░      
╫╫╫╫╫╫╫▓█████████░ ░░░░╙▀██▓▓████▓╫░░░░╫╫╨  ▐██████▄░░      
╫╨░╠▄████████████▄   ░░░░░╙▀██████▓╫╬╫╩╨    ▐▓████████▄┐    
████████████████▓█─  ░░░░░░ ░╙▀██▓▓▓▀       ║████████████▓▄╓
█████████████████╫█▄ ░░░░░╔▄▄▄▄▄▄█▄▄█████   █▓██████████████
██████████████████▓█▄░░░░░██████████████▀  ╣█▓██████████████
█████████████████████▄░░░░╙███████████▄   ╬╣▓███████████████
████████████████▓██████░░░║████████████░ ▓██████████████████
████████████████▓███████▄▄██████████████╫▓██████████████████
██████████████████▓████╫███████████████░▓██╫████████████████
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀╙╙╙╙╙▀╙╙╙▀▀╙╙╙└╙╙╙╙╙▀╙  ╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙
Времето е в нас и ние сме във времето.
*/

test bool shouldGiveErrorWhenUsingConstructorOnRepository() = 
	checkMethod(constructor([], [], emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], repository("User", []), newEnv()) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Constructors are disabled for repositories", newEnv());

test bool shouldGiveErrorWhenUsingConstructorOnUtils() = 
	checkMethod(constructor([], [], emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], util("User", []), newEnv()) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Constructors are disabled for utilities/services", newEnv());

test bool shouldGiveErrorWhenUsingConstructorOnControllers() = 
	checkMethod(constructor([], [], emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		controller("UserController", jsonApi(), route([]), []), newEnv()) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Constructors are disabled for controllers", newEnv());

test bool shouldGiveDuplicatedSignatureErrorWhenMethodsDuplicate() =
	checkMethod(
		method(\private(), integer(), "test", [], [\return(integer(5))], emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		entity("User", [
			method(\private(), integer(), "test", [], [], emptyExpr()),
			method(\private(), integer(), "test", [], [], emptyExpr())
		]), newEnv(|tmp:///|)) ==
	addError(
		|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Method test has been defined more than once with a duplicating signature",
		newEnv(|tmp:///|)
	);

test bool shouldGiveConflictingAccessErrorWhenMethodsDuplicate() =
	checkMethod(
		method(\private(), integer(), "test", [], [\return(integer(3))], emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		entity("User", [
			method(\private(), integer(), "test", [], [], emptyExpr()),
			method(\public(), integer(), "test", [], [], integer(2))
		]), newEnv(|tmp:///|)) ==
	addError(
		|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Method test is defined more than once with different access modifiers",
		newEnv(|tmp:///|)
	);

test bool shouldGiveConflictingReturnTypeErrorWhenMethodsDuplicate() =
	checkMethod(
		method(\public(), integer(), "test", [], [\return(integer(3))], emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		entity("User", [
			method(\public(), integer(), "test", [], [], integer(3)),
			method(\public(), string(), "test", [], [], integer(2))
		]), newEnv(|tmp:///|)) ==
	addError(
		|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Method test is defined more than once with different return types",
		newEnv(|tmp:///|)
	);

test bool shouldGiveErrorWhenAutofindOnNonEntityParameterInAction() = 
	checkAction(action("index", [
		param(artifact(fullName("Money", namespace("Test"), "Money")), "m", emptyExpr())[@annotations=[
			annotation("autofind", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]]]
	], [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], controller("UserController", jsonApi(), route([]), []), addToAST(
		\file(|tmp:///User.g|, \module(namespace("Test"), [], valueObject("Money", [], notProxy()))), 
			addImported(\import("Money", namespace("Test"), "Money"), newEnv()))) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Annotation @autofind can only be used on entities", addToAST(
		\file(|tmp:///User.g|, \module(namespace("Test"), [], valueObject("Money", [], notProxy()))), 
			addImported(\import("Money", namespace("Test"), "Money"), 
				addDefinition(param(artifact(fullName("Money", namespace("Test"), "Money")), "m", emptyExpr())[@annotations=[
			annotation("autofind", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]]], newEnv()))));

test bool shouldNotGiveErrorWhenAutofindOnEntityParameterInAction() = 
	!hasErrors(checkAction(action("index", [
		param(artifact(fullName("User", namespace("Test"), "User")), "m", emptyExpr())[@annotations=[
			annotation("autofind", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]]]
	], [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], controller("UserController", jsonApi(), route([]), []), addToAST(
		\file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))), 
			addImported(\import("User", namespace("Test"), "User"), newEnv()))));
