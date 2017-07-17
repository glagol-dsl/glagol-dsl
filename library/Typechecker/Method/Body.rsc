module Typechecker::Method::Body

import Typechecker::Statement;
import Typechecker::Env;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;

import List;

public TypeEnv checkBody(list[Statement] body, t: voidValue(), Declaration subroutine, Declaration artifact, TypeEnv env) = 
	checkStatements(body, t, subroutine, env);
	
public TypeEnv checkBody(list[Statement] body, Type t, Declaration subroutine, Declaration artifact, TypeEnv env) = 
	checkStatements(body, t, subroutine, checkReturnStmtAvailability(body, subroutine, env));


public TypeEnv checkReturnStmtAvailability(list[Statement] body, Declaration subroutine, TypeEnv env) = 
	addError(subroutine, "Return statement with value expected for method \'<subroutine.name>\'", env)
	when !hasReturn(body);

public TypeEnv checkReturnStmtAvailability(list[Statement] body, Declaration subroutine, TypeEnv env) = env;

public bool hasReturn(list[Statement] body) = (false | true | \return(expr) <- body, !isEmpty(expr)) ? true : hasReturnInBranches(getBranches(body));
public bool hasReturn(block(list[Statement] body)) = hasReturn(body);
public bool hasReturn(\return(expr)) = !isEmpty(expr);
public bool hasReturn(ifThenElse(_, Statement then, Statement \else)) = hasReturn(then) && hasReturn(\else);

public bool hasReturnInBranches([]) = false;
public bool hasReturnInBranches(list[Statement] branches) = (false | it ? true : hasReturn(branch) | branch <- branches);

public list[Statement] getBranches(list[Statement] body) = [stmt | stmt <- body, isIfThenElse(stmt)];



