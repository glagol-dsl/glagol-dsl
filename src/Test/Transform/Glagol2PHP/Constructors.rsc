module Test::Transform::Glagol2PHP::Constructors

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Constructors;

test bool shouldTransformEmptyConstructorToEmptyPhpConstructor() =
    toPhpClassItem(constructor([], [])) == phpMethod("__construct", {phpPublic()}, false, [], []);
