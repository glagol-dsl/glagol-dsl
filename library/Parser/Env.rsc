module Parser::Env

import Syntax::Abstract::Glagol;

alias ParseEnv = tuple[
	map[str, Declaration] imports,
	Declaration currentNamespace
];

public ParseEnv newParseEnv() = <(), emptyDecl()>;
public ParseEnv newParseEnv(list[Declaration] imps, Declaration ns) = <toMap(imps), ns>;

public Declaration getNamespace(ParseEnv env) = env.currentNamespace;

private map[str, Declaration] toMap(list[Declaration] imps) = (as: i | i: \import(_, _, as) <- imps);

public ParseEnv setImports(list[Declaration] imps, ParseEnv env) = env[imports = toMap(imps)];
public ParseEnv addImports(list[Declaration] imps, ParseEnv env) = env[imports = env.imports + toMap(imps)];

public bool isImported(str localName, ParseEnv env) = localName in env.imports;
public Declaration getImported(str localName, ParseEnv env) = env.imports[localName];
