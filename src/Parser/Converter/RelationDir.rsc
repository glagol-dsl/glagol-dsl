module Parser::Converter::RelationDir

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;

public RelationDir convertRelationDir(a: (RelationDir) `one`) = \one()[@src=a@\loc];
public RelationDir convertRelationDir(a: (RelationDir) `many`) = many()[@src=a@\loc];
