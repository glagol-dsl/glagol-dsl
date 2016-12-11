module Test::Syntax::Abstract::Glagol::Helpers

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;

test bool testIsProperty() = 
    isProperty(property(integer(), "test", {}, intLiteral(4))) &&
    isProperty(property(integer(), "test", {})) &&
    !isProperty(integer());

test bool testIsAnnotated() = 
    isAnnotated(annotated([], entity("User", []))) &&
    isAnnotated(annotated([], property(integer(), "test", {})), isProperty) && 
    !isAnnotated(property(integer(), "test", {}));
