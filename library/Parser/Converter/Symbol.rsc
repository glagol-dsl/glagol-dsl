module Parser::Converter::Symbol

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;

public Symbol convertSymbol(m: (MemberName) `<MemberName field>`) = symbol("<field>")[@src=m@\loc];
