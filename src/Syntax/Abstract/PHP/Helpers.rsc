module Syntax::Abstract::PHP::Helpers

import Syntax::Abstract::PHP;

public PhpExpr phpVar(str name) = phpVar(phpName(phpName(name)));
