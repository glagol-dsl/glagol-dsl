module Transform::Glagol2PHP::Entities

import Transform::Env;
import Transform::OriginAnnotator;
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
    = origin(phpClassDef(phpClass(name, {}, phpNoName(), [phpName("\\JsonSerializable")], 
        [origin(phpTraitUse([phpName("JsonSerializeTrait"), phpName("HydrateTrait")], []), e, true)] + 
        toPhpClassItems(declarations, env))[
        @phpAnnotations={phpAnnotation("ORM\\Entity")} + toPhpAnnotations(e, env)
    ]), e) when usesDoctrine(env);
