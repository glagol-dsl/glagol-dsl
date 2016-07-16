module Parser::Converter::QuotedString

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;

public str convertStringQuoted((StringQuoted) `"<StringCharacter* string>"`) = "<string>";
