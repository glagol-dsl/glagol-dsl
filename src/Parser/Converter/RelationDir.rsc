module Parser::Converter::RelationDir

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;

public RelationDir convertRelationDir((RelationDir) `one`) = \one();
public RelationDir convertRelationDir((RelationDir) `many`) = many();
