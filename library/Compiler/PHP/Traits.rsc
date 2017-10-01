module Compiler::PHP::Traits

import Compiler::PHP::Code;
import Syntax::Abstract::PHP;
import Utils::Indentation;
import Utils::Glue;
import Utils::NewLine;

public Code toCode(phpTraitUse(list[PhpName] traits, []), int i) =
    code(nl()) + glue([code("<s(i)>use <name>;", p) | p: phpName(str name) <- traits], code(nl())) + code(nl());
