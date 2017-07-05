module Typechecker::Method::Body

import Typechecker::Statement;
import Typechecker::Env;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;

import List;

public TypeEnv checkBody(list[Statement] body, Type returnType, Declaration subroutine, Declaration artifact, TypeEnv env) = 
	checkReturnStmtAvailability(body, subroutine, env) when returnType != voidValue();

public TypeEnv checkReturnStmtAvailability(list[Statement] body, Declaration subroutine, TypeEnv env) = 
	addError(subroutine@src, "Return statement with value expected in <subroutine@src.path> for method \'<subroutine.name>\'" + 
								" defined on line <subroutine@src.begin.line>", env)
	when !hasReturn(body);
	
public TypeEnv checkReturnStmtAvailability(list[Statement] body, Declaration subroutine, TypeEnv env) = env;

public bool hasReturn(list[Statement] body) = (false | true | \return(expr) <- body, !isEmpty(expr)) ? true : hasReturnInBranches(getBranches(body));
public bool hasReturn(block(list[Statement] body)) = hasReturn(body);
public bool hasReturn(\return(expr)) = !isEmpty(expr);
public bool hasReturn(ifThenElse(_, Statement then, Statement \else)) = hasReturn(then) && hasReturn(\else);

public bool hasReturnInBranches([]) = false;
public bool hasReturnInBranches(list[Statement] branches) = (false | it ? true : hasReturn(branch) | branch <- branches);

public list[Statement] getBranches(list[Statement] body) = [stmt | stmt <- body, isIfThenElse(stmt)];



