module Parser::Converter::AccessProperty

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;

public set[AccessProperty] convertAccessProperties((AccessProperties) `with { <{AccessProperty ","}* props> }`)
    = {convertAccessProperty(p) | p <- props};

public AccessProperty convertAccessProperty(a: (AccessProperty) `get`) = read()[@src=a@\loc];
public AccessProperty convertAccessProperty(a: (AccessProperty) `set`) = \set()[@src=a@\loc];
public AccessProperty convertAccessProperty(a: (AccessProperty) `add`) = add()[@src=a@\loc];
public AccessProperty convertAccessProperty(a: (AccessProperty) `clear`) = clear()[@src=a@\loc];
public AccessProperty convertAccessProperty(a: (AccessProperty) `reset`) = clear()[@src=a@\loc];
