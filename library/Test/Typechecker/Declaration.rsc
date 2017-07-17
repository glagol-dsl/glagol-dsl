module Test::Typechecker::Declaration

import Typechecker::Declaration;
import Typechecker::Env;
import Syntax::Abstract::Glagol;

test bool checkDeclarationsShouldGiveErrorsWhenDuplicatingEntityPropertyDefinitions() {
    Declaration e = entity("User", [
        property(integer()[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], "id", emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
        property(integer()[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], "id", emptyExpr())[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)]
    ])[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)];
    
    return
        checkDeclarations(e.declarations, e, newEnv(|tmp:///User.g|)) == 
        addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
                "Cannot redefine \"id\". Already defined in /User.g on line 20",
        addDefinition(property(integer()[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], "id", emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///User.g|)));
}

test bool checkDeclarationsShouldNotGiveErrorsWhenNoDuplicatingEntityPropertyDefinitions() {
    Declaration e = entity("User", [
        property(integer()[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], "id", emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
        property(integer()[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], "count", emptyExpr())[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)]
    ])[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)];
    
    return
        checkDeclarations(e.declarations, e, newEnv(|tmp:///User.g|)) == 
        addDefinition(property(integer()[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], "count", emptyExpr()), 
        addDefinition(property(integer(), "id", emptyExpr()), newEnv(|tmp:///User.g|)));
}
