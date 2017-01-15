module Compiler::PHP::Traits

import Syntax::Abstract::PHP;
import Utils::Indentation;
import Utils::Glue;
import Utils::NewLine;

public str toCode(phpTraitUse(list[PhpName] traits, []), int i) =
    nl() + glue(["<s(i)>use <name>;" | phpName(str name) <- traits], nl()) + nl();
