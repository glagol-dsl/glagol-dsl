module Transform::Glagol2PHP::Entities

import Transform::Env;
import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Methods;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Properties;
import Transform::Glagol2PHP::ClassItems;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;

@doc="Convert entity to a PHP class"
public PhpStmt toPhpClassDef(e: entity(str name, list[Declaration] declarations), TransformEnv env)
    = phpClassDef(phpClass(name, {}, phpNoName(), [phpName("\\JsonSerializable")], 
        [phpTraitUse([phpName("JsonSerializeTrait"), phpName("HydrateTrait")], [])] + 
        toPhpClassItems(declarations, env, e))[
        @phpAnnotations={phpAnnotation("ORM\\Entity")} + toPhpAnnotations(e, env)
    ]) when usesDoctrine(env);
