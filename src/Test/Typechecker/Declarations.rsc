module Test::Typechecker::Declarations

import Typechecker::Declarations;
import Typechecker::Env;
import Syntax::Abstract::Glagol;

test bool checkDeclarationsShouldGiveErrorsWhenDuplicatingEntityPropertyDefinitions() {
    Declaration e = entity("User", [
        property(integer(), "id", {}, emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
        property(integer(), "id", {}, emptyExpr())[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)]
    ])[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)];
    
    return
        checkDeclarations(e.declarations, e, <|tmp:///User.g|, (), (), [], []>) == 
        <|tmp:///User.g|, (
            "id": field(property(integer(), "id", {}, emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)])
        ), (), [], [
            <|tmp:///User.g|(0, 0, <25, 25>, <30, 30>), 
                "Cannot redefine \"id\". Property with the same name already defined in /User.g on line 20.">
        ]>;
}

test bool checkDeclarationsShouldNotGiveErrorsWhenNoDuplicatingEntityPropertyDefinitions() {
    Declaration e = entity("User", [
        property(integer(), "id", {}, emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
        property(integer(), "count", {}, emptyExpr())[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)]
    ])[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)];
    
    return
        checkDeclarations(e.declarations, e, <|tmp:///User.g|, (), (), [], []>) == 
        <|tmp:///User.g|, (
            "id": field(property(integer(), "id", {}, emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]),
            "count": field(property(integer(), "count", {}, emptyExpr())[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)])
        ), (), [], []>;
}
