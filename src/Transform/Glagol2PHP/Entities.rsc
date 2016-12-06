module Transform::Glagol2PHP::Entities

public PhpStmt toPhpClassDef(util(str name, list[Declaration] declarations))
    = phpClassDef(phpClass(name, {}, phpNoName(), [], []));
