@doc{
This code was originally taken from the PHP-Analysis project https://github.com/cwi-swat/php-analysis
}
module Syntax::Abstract::PHP

public data PhpOptionExpr = phpSomeExpr(PhpExpr expr) | phpNoExpr();

public data PhpOptionName = phpSomeName(PhpName name) | phpNoName();

public data PhpOptionElse = phpSomeElse(PhpElse e) | phpNoElse();

public data PhpActualParameter = phpActualParameter(PhpExpr expr, bool byRef);

public data PhpConst = phpConst(str name, PhpExpr constValue);

public data PhpArrayElement = phpArrayElement(PhpOptionExpr key, PhpExpr val, bool byRef);

public data PhpName = phpName(str name);

public data PhpNameOrExpr = phpName(PhpName name) | phpExpr(PhpExpr expr);

public data PhpCastType = phpInt() | phpBool() | phpFloat() | phpString() | phpArray() | phpObject() | phpUnset();

public data PhpClosureUse = phpClosureUse(PhpExpr varName, bool byRef); 

public data PhpIncludeType = phpInclude() | phpIncludeOnce() | phpRequire() | phpRequireOnce();

public data PhpExpr 
    = phpArray(list[PhpArrayElement] items)
    | phpFetchArrayDim(PhpExpr var, PhpOptionExpr dim)
    | phpFetchClassConst(PhpNameOrExpr className, str constantName)
    | phpAssign(PhpExpr assignTo, PhpExpr assignExpr)
    | phpAssignWOp(PhpExpr assignTo, PhpExpr assignExpr, PhpOp operation)
    | phpListAssign(list[PhpOptionExpr] assignsTo, PhpExpr assignExpr)
    | phpRefAssign(PhpExpr assignTo, PhpExpr assignExpr)
    | phpBinaryOperation(PhpExpr left, PhpExpr right, PhpOp operation)
    | phpUnaryOperation(PhpExpr operand, PhpOp operation)
    | phpNew(PhpNameOrExpr className, list[PhpActualParameter] parameters)
    | phpCast(PhpCastType castType, PhpExpr expr)
    | phpClone(PhpExpr expr)
    | phpClosure(list[PhpStmt] statements, list[PhpParam] params, list[PhpClosureUse] closureUses, bool byRef, bool static)
    | phpFetchConst(PhpName name)
    | phpEmpty(PhpExpr expr)
    | phpSuppress(PhpExpr expr)
    | phpEval(PhpExpr expr)
    | phpExit(PhpOptionExpr exitExpr)
    | phpCall(PhpNameOrExpr funName, list[PhpActualParameter] parameters)
    | phpMethodCall(PhpExpr target, PhpNameOrExpr methodName, list[PhpActualParameter] parameters)
    | phpStaticCall(PhpNameOrExpr staticTarget, PhpNameOrExpr methodName, list[PhpActualParameter] parameters)
    | phpInclude(PhpExpr expr, PhpIncludeType includeType)
    | phpInstanceOf(PhpExpr expr, PhpNameOrExpr toCompare)
    | phpIsSet(list[PhpExpr] exprs)
    | phpPrint(PhpExpr expr)
    | phpPropertyFetch(PhpExpr target, PhpNameOrExpr propertyName)
    | phpShellExec(list[PhpExpr] parts)
    | phpTernary(PhpExpr cond, PhpOptionExpr ifBranch, PhpExpr elseBranch)
    | phpStaticPropertyFetch(PhpNameOrExpr className, PhpNameOrExpr propertyName)
    | phpScalar(PhpScalar scalarVal)
    | phpVar(PhpNameOrExpr varName)   
    | phpYield(PhpOptionExpr keyExpr, PhpOptionExpr valueExpr)
    | phpListExpr(list[PhpOptionExpr] listExprs)
    ;

public data PhpOp = phpBitwiseAnd() | phpBitwiseOr() | phpBitwiseXor() | phpConcat() | phpDiv() 
               | phpMinus() | phpMod() | phpMul() | phpPlus() | phpRightShift() | phpLeftShift()
               | phpBooleanAnd() | phpBooleanOr() | phpBooleanNot() | phpBitwiseNot()
               | phpGt() | phpGeq() | phpLogicalAnd() | phpLogicalOr() | phpLogicalXor()
               | phpNotEqual() | phpNotIdentical() | phpPostDec() | phpPreDec() | phpPostInc()
               | phpPreInc() | phpLt() | phpLeq() | phpUnaryPlus() | phpUnaryMinus() 
               | phpEqual() | phpIdentical() ;

public data PhpParam 
    = phpParam(str paramName, PhpOptionExpr paramDefault, PhpOptionName paramType, bool byRef, bool isVariadic)
    ;
                          
public data PhpScalar
    = phpClassConstant()
    | phpDirConstant()
    | phpFileConstant()
    | phpFuncConstant()
    | phpLineConstant()
    | phpMethodConstant()
    | phpNamespaceConstant()
    | phpTraitConstant()
    | phpFloat(real realVal)
    | phpInteger(int intVal)
    | phpString(str strVal)
    | phpBoolean(bool boolVal)
    | phpEncapsed(list[PhpExpr] parts)
    ;

public data PhpStmt 
    = phpBreak(PhpOptionExpr breakExpr)
    | phpClassDef(PhpClassDef classDef)
    | phpConst(list[PhpConst] consts)
    | phpContinue(PhpOptionExpr continueExpr)
    | phpDeclare(list[PhpDeclaration] decls, list[PhpStmt] body)
    | phpDo(PhpExpr cond, list[PhpStmt] body)
    | phpEcho(list[PhpExpr] exprs)
    | phpExprstmt(PhpExpr expr)
    | phpFor(list[PhpExpr] inits, list[PhpExpr] conds, list[PhpExpr] exprs, list[PhpStmt] body)
    | phpForeach(PhpExpr arrayExpr, PhpOptionExpr keyvar, bool byRef, PhpExpr asVar, list[PhpStmt] body)
    | phpFunction(str name, bool byRef, list[PhpParam] params, list[PhpStmt] body)
    | phpGlobal(list[PhpExpr] exprs)
    | phpGoto(str label)
    | phpHaltCompiler(str remainingText)
    | phpIf(PhpExpr cond, list[PhpStmt] body, list[PhpElseIf] elseIfs, PhpOptionElse elseClause)
    | phpInlineHTML(str htmlText)
    | phpInterfaceDef(PhpInterfaceDef interfaceDef)
    | phpTraitDef(PhpTraitDef traitDef)
    | phpLabel(str labelName)
    | phpNamespace(PhpOptionName nsName, list[PhpStmt] body)
    | phpNamespaceHeader(PhpName namespaceName)
    | phpReturn(PhpOptionExpr returnExpr)
    | phpStatic(list[PhpStaticVar] vars)
    | phpSwitch(PhpExpr cond, list[PhpCase] cases)
    | phpThrow(PhpExpr expr)
    | phpTryCatch(list[PhpStmt] body, list[PhpCatch] catches)
    | phpTryCatchFinally(list[PhpStmt] body, list[PhpCatch] catches, list[PhpStmt] finallyBody)
    | phpUnset(list[PhpExpr] unsetVars)
    | phpUse(set[PhpUse] uses)
    | phpWhile(PhpExpr cond, list[PhpStmt] body)
    | phpEmptyStmt()
    | phpBlock(list[PhpStmt] body)
    ;

public data PhpDeclaration = phpDeclaration(str key, PhpExpr val);

public data PhpCatch = phpCatch(PhpName xtype, str varName, list[PhpStmt] body);
    
public data PhpCase = phpCase(PhpOptionExpr cond, list[PhpStmt] body);

public data PhpElseIf = phpElseIf(PhpExpr cond, list[PhpStmt] body);

public data PhpElse = phpElse(list[PhpStmt] body);

public data PhpUse = phpUse(PhpName importName, PhpOptionName asName);

public data PhpClassItem 
    = phpProperty(set[PhpModifier] modifiers, list[PhpProperty] prop)
    | phpConstCI(list[PhpConst] consts)
    | phpMethod(str name, set[PhpModifier] modifiers, bool byRef, list[PhpParam] params, list[PhpStmt] body, PhpOptionName returnType)
    | phpTraitUse(list[PhpName] traits, list[PhpAdaptation] adaptations)
    ;

public data PhpAdaptation
    = phpTraitAlias(PhpOptionName traitName, str methName, set[PhpModifier] newModifiers, PhpOptionName newName)
    | phpTraitPrecedence(PhpOptionName traitName, str methName, set[PhpName] insteadOf)
    ;

public data PhpProperty = phpProperty(str propertyName, PhpOptionExpr defaultValue);

public data PhpModifier = phpPublic() | phpPrivate() | phpProtected() | phpStatic() | phpAbstract() | phpFinal();
 
public data PhpClassDef = phpClass(str className,
                             set[PhpModifier] modifiers, 
                             PhpOptionName extends, 
                             list[PhpName] implements, 
                             list[PhpClassItem] members);

public data PhpInterfaceDef = phpInterface(str interfaceName, 
                                    list[PhpName] extends, 
                                    list[PhpClassItem] members);
                                    
public data PhpTraitDef = phpTrait(str traitName, list[PhpClassItem] members);

public data PhpStaticVar = phpStaticVar(str name, PhpOptionExpr defaultValue);

public data PhpScript = phpScript(list[PhpStmt] body) | phpErrscript(str err);

public data PhpAnnotation 
    = phpAnnotation(str key)
    | phpAnnotation(str key, PhpAnnotation \map)
    | phpAnnotationVal(map[str k, PhpAnnotation v])
    | phpAnnotationVal(str string)
    | phpAnnotationVal(int integer)
    | phpAnnotationVal(real float)
    | phpAnnotationVal(bool boolean)
    | phpAnnotationVal(list[PhpAnnotation] items)
    | phpAnnotationVal(PhpAnnotation \map)
    ;

public anno set[PhpAnnotation] PhpClassDef@phpAnnotations;
public anno str PhpClassDef@phpdoc;

public anno set[PhpAnnotation] PhpClassItem@phpAnnotations;
