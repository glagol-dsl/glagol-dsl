module Typechecker::DefaultValue

import Typechecker::Env;
import Typechecker::Type;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Map;

public TypeEnv checkDefaultValue(emptyExpr(), TypeEnv env) = env;
public TypeEnv checkDefaultValue(integer(_), TypeEnv env) = env;
public TypeEnv checkDefaultValue(float(_), TypeEnv env) = env;
public TypeEnv checkDefaultValue(boolean(_), TypeEnv env) = env;
public TypeEnv checkDefaultValue(string(_), TypeEnv env) = env;
public TypeEnv checkDefaultValue(\bracket(Expression expr), TypeEnv env) = checkDefaultValue(expr, env);

@doc="Typecheck for allowed list items in property"
public TypeEnv checkDefaultValue(\list(list[Expression] items), TypeEnv env) = 
	(env | addError(item, notAllowed(item), it) | item <- items, !isArrayItemAllowed(item));

@doc="Typecheck for allowed/matching types in map"
public TypeEnv checkDefaultValue(\map(map[Expression key, Expression \value] items), TypeEnv env) = 
	(
		(env | addError(key, notAllowed(key), it) | key <- domain(items), !isArrayKeyAllowed(key)) |
		 addError(val, notAllowed(val), it) |
		 val <- range(items), !isArrayItemAllowed(val)
	);

private bool isArrayItemAllowed(integer(_)) = true;
private bool isArrayItemAllowed(float(_)) = true;
private bool isArrayItemAllowed(boolean(_)) = true;
private bool isArrayItemAllowed(string(_)) = true;
private bool isArrayItemAllowed(Expression expr) = false;

private bool isArrayKeyAllowed(integer(_)) = true;
private bool isArrayKeyAllowed(string(_)) = true;
private bool isArrayKeyAllowed(Expression expr) = false;
