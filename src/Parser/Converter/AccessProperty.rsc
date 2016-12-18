module Parser::Converter::AccessProperty

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;

public set[AccessProperty] convertAccessProperties((AccessProperties) `with { <{AccessProperty ","}* props> }`)
    = {convertAccessProperty(p) | p <- props};

public AccessProperty convertAccessProperty((AccessProperty) `get`) = read();
public AccessProperty convertAccessProperty((AccessProperty) `set`) = \set();
public AccessProperty convertAccessProperty((AccessProperty) `add`) = add();
public AccessProperty convertAccessProperty((AccessProperty) `clear`) = clear();
public AccessProperty convertAccessProperty((AccessProperty) `reset`) = clear();
