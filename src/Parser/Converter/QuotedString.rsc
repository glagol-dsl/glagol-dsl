module Parser::Converter::QuotedString

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;

public str convertStringQuoted((StringQuoted) `"<StringCharacter* string>"`) = "<string>";
