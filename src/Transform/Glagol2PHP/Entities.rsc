module Transform::Glagol2PHP::Entities

import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Methods;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Properties;
import Transform::Glagol2PHP::ClassItems;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;

@doc="Convert entity to a PHP class"
public PhpStmt toPhpClassDef(e: entity(str name, list[Declaration] declarations), env: <Framework f, doctrine()>)
    = phpClassDef(phpClass(name, {}, phpNoName(), [], toPhpClassItems(declarations, env, e))[
        @phpAnnotations={phpAnnotation("ORM\\Entity")} + toPhpAnnotations(e, env)
    ]);
