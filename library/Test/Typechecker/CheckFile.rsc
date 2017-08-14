module Test::Typechecker::CheckFile

import Syntax::Abstract::Glagol;
import Typechecker::CheckFile;
import Typechecker::Env;

test bool shouldConstructFileFromEntityModuleUsingTmpLoc() =
    constructFileFromModule(|tmp:///src|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))) ==
    |tmp:///src/Test/Entity/User.g|;

test bool shouldConstructFileFromRepositoryModuleUsingTmpLoc() =
    constructFileFromModule(|tmp:///src|, \module(namespace("Test", namespace("Repository")), [], repository("User", []))) ==
    |tmp:///src/Test/Repository/UserRepository.g|;

test bool shouldConstructFileFromVOModuleUsingTmpLoc() =
    constructFileFromModule(|tmp:///src|, \module(namespace("Test", namespace("VO")), [], valueObject("Date", []))) ==
    |tmp:///src/Test/VO/Date.g|;

test bool shouldConstructFileFromUtilModuleUsingTmpLoc() =
    constructFileFromModule(|tmp:///src|, \module(namespace("Test", namespace("Util")), [], util("Serve", []))) ==
    |tmp:///src/Test/Util/Serve.g|;
    
test bool shouldConstructFileFromControllerModuleUsingTmpLoc() =
    constructFileFromModule(
        |tmp:///src|, 
        \module(
            namespace("Test", namespace("Controller")), [], 
            controller("UserController", jsonApi(), route([routePart("/")]), []))
        ) ==
    |tmp:///src/Test/Controller/UserController.g|;

test bool shouldCheckLocVsEntityModuleWithErrors() =
    checkLocVsModule(|tmp:///src|, file(|tmp:///src/Test/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))), newEnv(|tmp:///src|)) ==
    addError(|tmp:///src/Test/User.g|, "Wrong file name, does not follow namespace declaration and/or artifact name. " + 
        "Expected tmp:///src/Test/Entity/User.g, got tmp:///src/Test/User.g.", newEnv(|tmp:///src|));


test bool shouldCheckLocVsRepositoryModuleWithErrors() =
    checkLocVsModule(|tmp:///src|, file(|tmp:///src/Test/User.g|, \module(namespace("Test", namespace("Repository")), [], repository("User", []))), 
    newEnv(|tmp:///src|)) ==
    addError(|tmp:///src/Test/User.g|, "Wrong file name, does not follow namespace declaration and/or artifact name. " + 
        "Expected tmp:///src/Test/Repository/UserRepository.g, got tmp:///src/Test/User.g.", newEnv(|tmp:///src|));

test bool shouldCheckLocVsEntityModuleWithNoErrors() =
    checkLocVsModule(|tmp:///src|, file(|tmp:///src/Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))), 
    newEnv(|tmp:///src|)) ==
    newEnv(|tmp:///src|);
