module Transform::Glagol2PHP::Constructors

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

public PhpClassItem toPhpClassItem(constructor(list[Declaration] params, list[Statement] body)) 
    = phpMethod("__construct", {phpPublic()}, false, [], []);
