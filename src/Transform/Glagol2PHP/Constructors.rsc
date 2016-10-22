module Transform::Glagol2PHP::Constructors

import Transform::Glagol2PHP::Params;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

public PhpClassItem toPhpClassItem(constructor(list[Declaration] params, list[Statement] body)) 
    = phpMethod("__construct", {phpPublic()}, false, [toPhpParam(p) | p <- params], []);
