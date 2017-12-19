module Test::Parser::Repository::Queries

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool shouldParseQueryFromMethodValue() 
{    
    str code 
        = "namespace Example
          '
          'repository for User {
          '     public User[] findAll() = SELECT u FROM User u;
          '     public User[] findAllUsingAs() = SELECT u FROM User as u;
          '     public User[] findAllUsingWhere() = SELECT u FROM User u WHERE u.id = u.id2;
          '     public User[] findAllUsingOrderBy() = SELECT u FROM User u ORDER BY u.id;
          '     public User[] findAllUsingOrderByASC() = SELECT u FROM User u ORDER BY u.id ASC;
          '     public User[] findAllUsingOrderByDESC() = SELECT u FROM User u ORDER BY u.id DESC;
          '     public User[] findAllUsingOrderByMultipleFields() = SELECT u FROM User u ORDER BY u.id DESC, u.id2 ASC;
          '     public User[] findAllUsingLimit() = SELECT u FROM User u LIMIT \<33\>;
          '     public User[] findAllUsingLimitAndOffset() = SELECT u FROM User u LIMIT \<33\> OFFSET \<11\>;
          '     public User[] findAllUsingLimitAndOffset2() = SELECT u FROM User u LIMIT \<11\>, \<33\>;
          '     public User[] findOne() = SELECT u[] FROM User u;
          '}";
    
    return parseModule(code) == \module(namespace("Example"), [], repository("User", [
		method(\public(), \list(artifact(fullName("User", namespace("Example"), "User"))), "findAll", [], [
			\return(
				query(
					querySelect(querySpec(symbol("u"), true), querySource(fullName("User", namespace("Example"), "User"), symbol("u")), noWhere(), noOrderBy(), noLimit()))
			)
		], emptyExpr()),
		method(\public(), \list(artifact(fullName("User", namespace("Example"), "User"))), "findAllUsingAs", [], [
			\return(
				query(
					querySelect(querySpec(symbol("u"), true), querySource(fullName("User", namespace("Example"), "User"), symbol("u")), noWhere(), noOrderBy(), noLimit()))
			)
		], emptyExpr()),
		method(\public(), \list(artifact(fullName("User", namespace("Example"), "User"))), "findAllUsingWhere", [], [
			\return(
				query(
					querySelect(querySpec(symbol("u"), true), querySource(fullName("User", namespace("Example"), "User"), symbol("u")), expression(
						equals(queryField(queryField(symbol("u"), symbol("id"))), queryField(queryField(symbol("u"), symbol("id2"))))
					), noOrderBy(), noLimit()))
			)
		], emptyExpr()),
		method(\public(), \list(artifact(fullName("User", namespace("Example"), "User"))), "findAllUsingOrderBy", [], [
			\return(
				query(
					querySelect(querySpec(symbol("u"), true), querySource(fullName("User", namespace("Example"), "User"), symbol("u")), noWhere(), 
						orderBy([orderBy(queryField(symbol("u"), symbol("id")), false)]), noLimit()))
			)
		], emptyExpr()),
		method(\public(), \list(artifact(fullName("User", namespace("Example"), "User"))), "findAllUsingOrderByASC", [], [
			\return(
				query(
					querySelect(querySpec(symbol("u"), true), querySource(fullName("User", namespace("Example"), "User"), symbol("u")), noWhere(), 
						orderBy([orderBy(queryField(symbol("u"), symbol("id")), false)]), noLimit()))
			)
		], emptyExpr()),
		method(\public(), \list(artifact(fullName("User", namespace("Example"), "User"))), "findAllUsingOrderByDESC", [], [
			\return(
				query(
					querySelect(querySpec(symbol("u"), true), querySource(fullName("User", namespace("Example"), "User"), symbol("u")), noWhere(), 
						orderBy([orderBy(queryField(symbol("u"), symbol("id")), true)]), noLimit()))
			)
		], emptyExpr()),
		method(\public(), \list(artifact(fullName("User", namespace("Example"), "User"))), "findAllUsingOrderByMultipleFields", [], [
			\return(
				query(
					querySelect(querySpec(symbol("u"), true), querySource(fullName("User", namespace("Example"), "User"), symbol("u")), noWhere(), 
						orderBy([orderBy(queryField(symbol("u"), symbol("id")), true), orderBy(queryField(symbol("u"), symbol("id2")), false)]), noLimit()))
			)
		], emptyExpr()),
		method(\public(), \list(artifact(fullName("User", namespace("Example"), "User"))), "findAllUsingLimit", [], [
			\return(
				query(
					querySelect(querySpec(symbol("u"), true), querySource(fullName("User", namespace("Example"), "User"), symbol("u")), noWhere(), 
						noOrderBy(), limit(glagolExpr(integer(33)), noQueryExpr())))
			)
		], emptyExpr()),
		method(\public(), \list(artifact(fullName("User", namespace("Example"), "User"))), "findAllUsingLimitAndOffset", [], [
			\return(
				query(
					querySelect(querySpec(symbol("u"), true), querySource(fullName("User", namespace("Example"), "User"), symbol("u")), noWhere(), 
						noOrderBy(), limit(glagolExpr(integer(33)), glagolExpr(integer(11)))))
			)
		], emptyExpr()),
		method(\public(), \list(artifact(fullName("User", namespace("Example"), "User"))), "findAllUsingLimitAndOffset2", [], [
			\return(
				query(
					querySelect(querySpec(symbol("u"), true), querySource(fullName("User", namespace("Example"), "User"), symbol("u")), noWhere(), 
						noOrderBy(), limit(glagolExpr(integer(33)), glagolExpr(integer(11)))))
			)
		], emptyExpr()),
		method(\public(), \list(artifact(fullName("User", namespace("Example"), "User"))), "findOne", [], [
			\return(
				query(
					querySelect(querySpec(symbol("u"), false), querySource(fullName("User", namespace("Example"), "User"), symbol("u")), noWhere(), noOrderBy(), noLimit()))
			)
		], emptyExpr()),
		method(\public(), artifact(fullName("User", namespace("Example"), "User")), "find", [
			param(integer(), "id", emptyExpr())
		], [\return(new(fullName("User", namespace("Example"), "User"), []))], emptyExpr()),
		method(\public(), \list(artifact(fullName("User", namespace("Example"), "User"))), "findAll", [], [\return(\list([]))], emptyExpr())
    ]));
}
