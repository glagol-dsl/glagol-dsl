module Test::Transform::Glagol2PHP::Methods

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Methods;

test bool shouldTransformSimpleMethod() =
    toPhpClassItem(method(\public(), voidValue(), "test", [], [])) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpNoName());


