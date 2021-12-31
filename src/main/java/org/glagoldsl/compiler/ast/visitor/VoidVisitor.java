package org.glagoldsl.compiler.ast.visitor;

import org.glagoldsl.compiler.ast.nodes.annotation.Annotation;
import org.glagoldsl.compiler.ast.nodes.annotation.AnnotationArgument;
import org.glagoldsl.compiler.ast.nodes.declaration.*;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.RestController;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.RouteElementLiteral;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.RouteElementPlaceholder;
import org.glagoldsl.compiler.ast.nodes.declaration.member.*;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Parameter;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.When;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.WhenEmpty;
import org.glagoldsl.compiler.ast.nodes.declaration.member.proxy.ProxyConstructor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.proxy.ProxyMethod;
import org.glagoldsl.compiler.ast.nodes.declaration.member.proxy.ProxyProperty;
import org.glagoldsl.compiler.ast.nodes.declaration.member.proxy.ProxyRequire;
import org.glagoldsl.compiler.ast.nodes.declaration.proxy.PhpLabel;
import org.glagoldsl.compiler.ast.nodes.declaration.proxy.Proxy;
import org.glagoldsl.compiler.ast.nodes.expression.*;
import org.glagoldsl.compiler.ast.nodes.expression.binary.Concatenation;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Addition;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Division;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Product;
import org.glagoldsl.compiler.ast.nodes.expression.binary.arithmetic.Subtraction;
import org.glagoldsl.compiler.ast.nodes.expression.binary.relational.*;
import org.glagoldsl.compiler.ast.nodes.expression.literal.BooleanLiteral;
import org.glagoldsl.compiler.ast.nodes.expression.literal.DecimalLiteral;
import org.glagoldsl.compiler.ast.nodes.expression.literal.IntegerLiteral;
import org.glagoldsl.compiler.ast.nodes.expression.literal.StringLiteral;
import org.glagoldsl.compiler.ast.nodes.expression.unary.Bracket;
import org.glagoldsl.compiler.ast.nodes.expression.unary.arithmetic.Negative;
import org.glagoldsl.compiler.ast.nodes.expression.unary.arithmetic.Positive;
import org.glagoldsl.compiler.ast.nodes.expression.unary.relational.Negation;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.module.Import;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.glagoldsl.compiler.ast.nodes.module.Namespace;
import org.glagoldsl.compiler.ast.nodes.query.*;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryEmptyExpression;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryField;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryInterpolation;
import org.glagoldsl.compiler.ast.nodes.query.expression.binary.relational.*;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryBracket;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryIsNotNull;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryIsNull;
import org.glagoldsl.compiler.ast.nodes.statement.*;
import org.glagoldsl.compiler.ast.nodes.statement.assignable.ListValueAssign;
import org.glagoldsl.compiler.ast.nodes.statement.assignable.PropertyAssign;
import org.glagoldsl.compiler.ast.nodes.statement.assignable.VariableAssign;
import org.glagoldsl.compiler.ast.nodes.type.*;

public abstract class VoidVisitor<C> implements Visitor<Void, C> {
    @Override
    public Void visitAnnotation(Annotation node, C context) {
        node.getName().accept(this, context);
        node.getArguments().forEach(argument -> argument.accept(this, context));

        return null;
    }

    @Override
    public Void visitWhen(When node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitWhenEmpty(WhenEmpty node, C context) {
        return null;
    }

    @Override
    public Void visitAnnotationArgument(AnnotationArgument node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitEntity(Entity node, C context) {
        node.getIdentifier().accept(this, context);
        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));
        node.getMembers().forEach(member -> member.accept(this, context));

        return null;
    }

    @Override
    public Void visitRepository(Repository node, C context) {
        node.getEntityIdentifier().accept(this, context);
        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));
        node.getMembers().forEach(member -> member.accept(this, context));

        return null;
    }

    @Override
    public Void visitService(Service node, C context) {
        node.getIdentifier().accept(this, context);

        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));
        node.getMembers().forEach(member -> member.accept(this, context));

        return null;
    }

    @Override
    public Void visitValue(Value node, C context) {
        node.getIdentifier().accept(this, context);

        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));
        node.getMembers().forEach(member -> member.accept(this, context));

        return null;
    }

    @Override
    public Void visitRestController(RestController node, C context) {
        node.getRoute().accept(this, context);

        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));
        node.getMembers().forEach(member -> member.accept(this, context));

        return null;
    }

    @Override
    public Void visitRoute(Route node, C context) {
        node.getRouteElements().forEach(routeElement -> routeElement.accept(this, context));

        return null;
    }

    @Override
    public Void visitRouteElementLiteral(
            RouteElementLiteral node, C context
    ) {
        return null;
    }

    @Override
    public Void visitRouteElementPlaceholder(
            RouteElementPlaceholder node, C context
    ) {
        return null;
    }

    @Override
    public Void visitAccessor(Accessor node, C context) {
        return null;
    }

    @Override
    public Void visitAction(Action node, C context) {
        node.getName().accept(this, context);
        node.getBody().accept(this, context);
        node.getGuard().accept(this, context);

        node.getParameters().forEach(parameter -> parameter.accept(this, context));
        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));

        return null;
    }

    @Override
    public Void visitConstructor(Constructor node, C context) {
        node.getBody().accept(this, context);
        node.getAccessor().accept(this, context);
        node.getGuard().accept(this, context);

        node.getParameters().forEach(parameter -> parameter.accept(this, context));
        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));

        return null;
    }

    @Override
    public Void visitMethod(Method node, C context) {
        node.getAccessor().accept(this, context);
        node.getType().accept(this, context);
        node.getBody().accept(this, context);
        node.getName().accept(this, context);
        node.getGuard().accept(this, context);

        node.getParameters().forEach(parameter -> parameter.accept(this, context));
        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));

        return null;
    }

    @Override
    public Void visitProperty(Property node, C context) {
        node.getName().accept(this, context);
        node.getAccessor().accept(this, context);
        node.getType().accept(this, context);
        node.getDefaultValue().accept(this, context);

        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));

        return null;
    }

    @Override
    public Void visitBody(Body node, C context) {
        node.getStatements().forEach(statement -> statement.accept(this, context));

        return null;
    }

    @Override
    public Void visitParameter(Parameter node, C context) {
        node.getName().accept(this, context);
        node.getType().accept(this, context);
        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));

        return null;
    }

    @Override
    public Void visitProxyConstructor(ProxyConstructor node, C context) {
        node.getAccessor().accept(this, context);
        node.getBody().accept(this, context);
        node.getGuard().accept(this, context);

        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));
        node.getParameters().forEach(parameter -> parameter.accept(this, context));

        return null;
    }

    @Override
    public Void visitProxyMethod(ProxyMethod node, C context) {
        node.getBody().accept(this, context);
        node.getAccessor().accept(this, context);
        node.getName().accept(this, context);
        node.getType().accept(this, context);
        node.getGuard().accept(this, context);

        node.getParameters().forEach(parameter -> parameter.accept(this, context));
        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));

        return null;
    }

    @Override
    public Void visitProxyProperty(ProxyProperty node, C context) {
        node.getAccessor().accept(this, context);
        node.getName().accept(this, context);
        node.getDefaultValue().accept(this, context);
        node.getType().accept(this, context);

        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));

        return null;
    }

    @Override
    public Void visitProxyRequire(ProxyRequire node, C context) {
        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));

        return null;
    }

    @Override
    public Void visitPhpLabel(PhpLabel node, C context) {
        return null;
    }

    @Override
    public Void visitProxy(Proxy node, C context) {
        node.getDeclaration().accept(this, context);
        node.getPhpLabel().accept(this, context);

        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));

        return null;
    }

    @Override
    public Void visitConcatenation(Concatenation node, C context) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitAddition(Addition node, C context) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitDivision(Division node, C context) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitProduct(Product node, C context) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitSubtraction(Subtraction node, C context) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitConjunction(Conjunction node, C context) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitDisjunction(Disjunction node, C context) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitEqual(Equal node, C context) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitGreaterThan(GreaterThan node, C context) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitGreaterThanOrEqual(
            GreaterThanOrEqual node, C context
    ) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitLowerThan(LowerThan node, C context) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitLowerThanOrEqual(
            LowerThanOrEqual node, C context
    ) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitNonEqual(NonEqual node, C context) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitBracket(Bracket node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitNegative(Negative node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitPositive(Positive node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitNegation(Negation node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitBooleanLiteral(BooleanLiteral node, C context) {
        return null;
    }

    @Override
    public Void visitDecimalLiteral(DecimalLiteral node, C context) {
        return null;
    }

    @Override
    public Void visitIntegerLiteral(IntegerLiteral node, C context) {
        return null;
    }

    @Override
    public Void visitStringLiteral(StringLiteral node, C context) {
        return null;
    }

    @Override
    public Void visitEmptyExpression(EmptyExpression node, C context) {
        return null;
    }

    @Override
    public Void visitExpressionQuery(ExpressionQuery node, C context) {
        node.getQuery().accept(this, context);

        return null;
    }

    @Override
    public Void visitGList(GList node, C context) {
        node.getExpressions().forEach(expression -> expression.accept(this, context));

        return null;
    }

    @Override
    public Void visitGMap(GMap node, C context) {

        node.getPairs().forEach((key, value) -> {
            key.accept(this, context);
            value.accept(this, context);
        });

        return null;
    }

    @Override
    public Void visitInvoke(Invoke node, C context) {
        node.getMethod().accept(this, context);
        node.getPrev().accept(this, context);

        node.getArguments().forEach(expression -> expression.accept(this, context));

        return null;
    }

    @Override
    public Void visitNew(New node, C context) {
        node.getTarget().accept(this, context);
        node.getArguments().forEach(expression -> expression.accept(this, context));

        return null;
    }

    @Override
    public Void visitPropertyAccess(PropertyAccess node, C context) {
        node.getPrev().accept(this, context);
        node.getProperty().accept(this, context);

        return null;
    }

    @Override
    public Void visitTernary(Ternary node, C context) {
        node.getCondition().accept(this, context);
        node.getThen().accept(this, context);
        node.getElse().accept(this, context);

        return null;
    }

    @Override
    public Void visitThis(This node, C context) {
        return null;
    }

    @Override
    public Void visitTypeCast(TypeCast node, C context) {
        node.getExpression().accept(this, context);
        node.getType().accept(this, context);

        return null;
    }

    @Override
    public Void visitVariable(Variable node, C context) {
        node.getIdentifier().accept(this, context);

        return null;
    }

    @Override
    public Void visitIdentifier(Identifier node, C context) {
        return null;
    }

    @Override
    public Void visitModule(Module node, C context) {
        node.getNamespace().accept(this, context);
        node.getImports().forEach(anImport -> anImport.accept(this, context));
        node.getDeclarations().forEach(declaration -> declaration.accept(this, context));

        return null;
    }

    @Override
    public Void visitNamespace(Namespace node, C context) {
        node.getNames().forEach(identifier -> identifier.accept(this, context));

        return null;
    }

    @Override
    public Void visitImport(Import node, C context) {
        node.getDeclaration().accept(this, context);
        node.getNamespace().accept(this, context);
        node.getAlias().accept(this, context);

        return null;
    }

    @Override
    public Void visitQuerySelect(QuerySelect node, C context) {
        node.getLimit().accept(this, context);
        node.getOrderBy().accept(this, context);
        node.getWhere().accept(this, context);
        node.getSource().accept(this, context);
        node.getSpecification().accept(this, context);

        return null;
    }

    @Override
    public Void visitQuerySpec(QuerySpec node, C context) {
        node.getEntity().accept(this, context);

        return null;
    }

    @Override
    public Void visitQuerySource(QuerySource node, C context) {
        node.getAlias().accept(this, context);
        node.getEntity().accept(this, context);

        return null;
    }

    @Override
    public Void visitQueryOrderBy(QueryOrderBy node, C context) {
        node.getFields().forEach(field -> field.accept(this, context));

        return null;
    }

    @Override
    public Void visitQueryOrderByField(QueryOrderByField node, C context) {
        node.getField().accept(this, context);

        return null;
    }

    @Override
    public Void visitDefinedQueryLimit(DefinedQueryLimit node, C context) {
        node.getOffset().accept(this, context);
        node.getSize().accept(this, context);

        return null;
    }

    @Override
    public Void visitUndefinedQueryLimit(UndefinedQueryLimit node, C context) {
        return null;
    }

    @Override
    public Void visitQueryConjunction(
            QueryConjunction node, C context
    ) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitQueryDisjunction(
            QueryDisjunction node, C context
    ) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitQueryEqual(QueryEqual node, C context) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitQueryGreaterThan(
            QueryGreaterThan node, C context
    ) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitQueryGreaterThanOrEqual(
            QueryGreaterThanOrEqual node, C context
    ) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitQueryLowerThan(
            QueryLowerThan node, C context
    ) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitQueryLowerThanOrEqual(
            QueryLowerThanOrEqual node, C context
    ) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitQueryNonEqual(
            QueryNonEqual node, C context
    ) {
        node.getLeft().accept(this, context);
        node.getRight().accept(this, context);

        return null;
    }

    @Override
    public Void visitQueryBracket(QueryBracket node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitQueryIsNotNull(QueryIsNotNull node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitQueryIsNull(QueryIsNull node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitQueryEmptyExpression(QueryEmptyExpression node, C context) {
        return null;
    }

    @Override
    public Void visitQueryField(QueryField node, C context) {
        node.getEntity().accept(this, context);
        node.getProperty().accept(this, context);

        return null;
    }

    @Override
    public Void visitQueryInterpolation(QueryInterpolation node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitAssign(Assign node, C context) {
        node.getAssignable().accept(this, context);
        node.getOperator().accept(this, context);
        node.getValue().accept(this, context);

        return null;
    }

    @Override
    public Void visitAssignOperator(AssignOperator node, C context) {
        return null;
    }

    @Override
    public Void visitBlock(Block node, C context) {
        node.getStatements().forEach(statement -> statement.accept(this, context));

        return null;
    }

    @Override
    public Void visitBreak(Break node, C context) {
        node.getLevel().accept(this, context);

        return null;
    }

    @Override
    public Void visitContinue(Continue node, C context) {
        node.getLevel().accept(this, context);

        return null;
    }

    @Override
    public Void visitDeclare(Declare node, C context) {
        node.getValue().accept(this, context);
        node.getType().accept(this, context);
        node.getVariable().accept(this, context);

        return null;
    }

    @Override
    public Void visitEmptyStatement(EmptyStatement node, C context) {
        return null;
    }

    @Override
    public Void visitExpressionStatement(ExpressionStatement node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitFlush(Flush node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitForEach(ForEach node, C context) {
        node.getBody().accept(this, context);
        node.getVariable().accept(this, context);
        node.getArray().accept(this, context);

        node.getConditions().forEach(expression -> expression.accept(this, context));

        return null;
    }

    @Override
    public Void visitForEachWithKey(ForEachWithKey node, C context) {
        node.getBody().accept(this, context);
        node.getVariable().accept(this, context);
        node.getArray().accept(this, context);
        node.getKey().accept(this, context);

        node.getConditions().forEach(expression -> expression.accept(this, context));

        return null;
    }

    @Override
    public Void visitIf(If node, C context) {
        node.getCondition().accept(this, context);
        node.getThen().accept(this, context);
        node.getElse().accept(this, context);

        return null;
    }

    @Override
    public Void visitPersist(Persist node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitRemove(Remove node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitReturn(Return node, C context) {
        node.getExpression().accept(this, context);

        return null;
    }

    @Override
    public Void visitListValueAssign(ListValueAssign node, C context) {
        node.getKey().accept(this, context);
        node.getPrev().accept(this, context);

        return null;
    }

    @Override
    public Void visitPropertyAssign(PropertyAssign node, C context) {
        node.getProperty().accept(this, context);
        node.getPrev().accept(this, context);

        return null;
    }

    @Override
    public Void visitVariableAssign(VariableAssign node, C context) {
        node.getName().accept(this, context);

        return null;
    }

    @Override
    public Void visitBoolType(BoolType node, C context) {
        return null;
    }

    @Override
    public Void visitClassType(ClassType node, C context) {
        node.getName().accept(this, context);

        return null;
    }

    @Override
    public Void visitFloatType(FloatType node, C context) {
        return null;
    }

    @Override
    public Void visitGListType(GListType node, C context) {
        node.getType().accept(this, context);

        return null;
    }

    @Override
    public Void visitGMapType(GMapType node, C context) {
        node.getKeyType().accept(this, context);
        node.getValueType().accept(this, context);

        return null;
    }

    @Override
    public Void visitIntegerType(IntegerType node, C context) {
        return null;
    }

    @Override
    public Void visitRepositoryType(RepositoryType node, C context) {
        node.getEntity().accept(this, context);

        return null;
    }

    @Override
    public Void visitStringType(StringType node, C context) {
        return null;
    }

    @Override
    public Void visitVoidType(VoidType node, C context) {
        return null;
    }

}
