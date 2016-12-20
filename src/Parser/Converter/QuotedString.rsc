module Parser::Converter::QuotedString

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;

public str convertStringQuoted(string) = substring("<string>", 1, size("<string>") - 1);
