package org.glagoldsl.compiler.ast.walker;

import org.glagoldsl.compiler.ast.nodes.annotation.Annotation;
import org.glagoldsl.compiler.ast.nodes.annotation.AnnotationArgument;
import org.glagoldsl.compiler.ast.nodes.declaration.Entity;
import org.glagoldsl.compiler.ast.nodes.declaration.Repository;
import org.glagoldsl.compiler.ast.nodes.declaration.Service;
import org.glagoldsl.compiler.ast.nodes.declaration.Value;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.RestController;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.RouteElementLiteral;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.RouteElementPlaceholder;
import org.glagoldsl.compiler.ast.nodes.declaration.member.*;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Body;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Parameter;
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
import org.glagoldsl.compiler.ast.visitor.VoidVisitor;

public abstract class Walker<T> extends VoidVisitor<T> {
    private final Listener<T> listener;

    public Walker(Listener<T> listener) {
        this.listener = listener;
    }

    @Override
    public Void visitAnnotation(
            Annotation node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitAnnotation(node, context);
        listener.leave(node).accept(context);

        return null;
    }

    @Override
    public Void visitAnnotationArgument(
            AnnotationArgument node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitAnnotationArgument(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitEntity(
            Entity node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitEntity(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitIdentifier(
            Identifier node, T context
    ) {
        listener.enter(node).accept(context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitRepository(
            Repository node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitRepository(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitService(
            Service node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitService(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitValue(
            Value node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitValue(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitRestController(
            RestController node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitRestController(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitRoute(
            Route node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitRoute(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitRouteElementLiteral(
            RouteElementLiteral node, T context
    ) {
        listener.enter(node).accept(context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitRouteElementPlaceholder(
            RouteElementPlaceholder node, T context
    ) {
        listener.enter(node).accept(context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitAccessor(
            Accessor node, T context
    ) {
        listener.enter(node).accept(context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitAction(
            Action node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitAction(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitConstructor(
            Constructor node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitConstructor(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitMethod(
            Method node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitMethod(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitProperty(
            Property node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitProperty(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitBody(
            Body node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitBody(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitParameter(
            Parameter node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitParameter(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitProxyConstructor(
            ProxyConstructor node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitProxyConstructor(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitProxyMethod(
            ProxyMethod node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitProxyMethod(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitProxyProperty(
            ProxyProperty node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitProxyProperty(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitProxyRequire(
            ProxyRequire node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitProxyRequire(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitPhpLabel(
            PhpLabel node, T context
    ) {
        listener.enter(node).accept(context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitProxy(
            Proxy node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitProxy(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitConcatenation(
            Concatenation node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitConcatenation(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitAddition(
            Addition node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitAddition(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitDivision(
            Division node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitDivision(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitProduct(
            Product node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitProduct(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitSubtraction(
            Subtraction node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitSubtraction(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitConjunction(
            Conjunction node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitConjunction(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitDisjunction(
            Disjunction node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitDisjunction(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitEqual(
            Equal node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitEqual(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitGreaterThan(
            GreaterThan node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitGreaterThan(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitGreaterThanOrEqual(
            GreaterThanOrEqual node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitGreaterThanOrEqual(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitLowerThan(LowerThan node, T context) {
        listener.enter(node).accept(context);
        super.visitLowerThan(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitLowerThanOrEqual(LowerThanOrEqual node, T context) {
        listener.enter(node).accept(context);
        super.visitLowerThanOrEqual(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitNonEqual(NonEqual node, T context) {
        listener.enter(node).accept(context);
        super.visitNonEqual(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitBracket(
            Bracket node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitBracket(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitNegative(
            Negative node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitNegative(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitPositive(
            Positive node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitPositive(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitNegation(
            Negation node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitNegation(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitBooleanLiteral(
            BooleanLiteral node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitBooleanLiteral(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitDecimalLiteral(
            DecimalLiteral node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitDecimalLiteral(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitIntegerLiteral(
            IntegerLiteral node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitIntegerLiteral(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitStringLiteral(
            StringLiteral node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitStringLiteral(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitEmptyExpression(
            EmptyExpression node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitEmptyExpression(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitExpressionQuery(
            ExpressionQuery node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitExpressionQuery(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitGList(
            GList node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitGList(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitGMap(
            GMap node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitGMap(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitInvoke(
            Invoke node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitInvoke(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitNew(New node, T context) {
        listener.enter(node).accept(context);
        super.visitNew(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitPropertyAccess(PropertyAccess node, T context) {
        listener.enter(node).accept(context);
        super.visitPropertyAccess(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitTernary(Ternary node, T context) {
        listener.enter(node).accept(context);
        super.visitTernary(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitThis(This node, T context) {
        listener.enter(node).accept(context);
        super.visitThis(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitTypeCast(TypeCast node, T context) {
        listener.enter(node).accept(context);
        super.visitTypeCast(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitVariable(Variable node, T context) {
        listener.enter(node).accept(context);
        super.visitVariable(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitModule(
            Module node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitModule(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitNamespace(
            Namespace node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitNamespace(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitImport(
            Import node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitImport(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQuerySelect(
            QuerySelect node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQuerySelect(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQuerySpec(
            QuerySpec node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQuerySpec(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQuerySource(
            QuerySource node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQuerySource(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryOrderBy(
            QueryOrderBy node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQueryOrderBy(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryOrderByField(
            QueryOrderByField node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQueryOrderByField(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitDefinedQueryLimit(DefinedQueryLimit node, T context) {
        listener.enter(node).accept(context);
        super.visitDefinedQueryLimit(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitUndefinedQueryLimit(UndefinedQueryLimit node, T context) {
        listener.enter(node).accept(context);
        super.visitUndefinedQueryLimit(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryConjunction(
            QueryConjunction node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQueryConjunction(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryDisjunction(
            QueryDisjunction node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQueryDisjunction(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryEqual(
            QueryEqual node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQueryEqual(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryGreaterThan(
            QueryGreaterThan node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQueryGreaterThan(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryGreaterThanOrEqual(
            QueryGreaterThanOrEqual node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQueryGreaterThanOrEqual(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryLowerThan(QueryLowerThan node, T context) {
        listener.enter(node).accept(context);
        super.visitQueryLowerThan(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryLowerThanOrEqual(
            QueryLowerThanOrEqual node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQueryLowerThanOrEqual(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryNonEqual(QueryNonEqual node, T context) {
        listener.enter(node).accept(context);
        super.visitQueryNonEqual(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryBracket(
            QueryBracket node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQueryBracket(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryIsNotNull(
            QueryIsNotNull node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQueryIsNotNull(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryIsNull(
            QueryIsNull node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQueryIsNull(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryEmptyExpression(
            QueryEmptyExpression node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQueryEmptyExpression(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryField(
            QueryField node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQueryField(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitQueryInterpolation(
            QueryInterpolation node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitQueryInterpolation(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitAssign(
            Assign node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitAssign(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitAssignOperator(
            AssignOperator node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitAssignOperator(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitBlock(
            Block node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitBlock(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitBreak(
            Break node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitBreak(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitContinue(
            Continue node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitContinue(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitDeclare(Declare node, T context) {
        listener.enter(node).accept(context);
        super.visitDeclare(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitEmptyStatement(EmptyStatement node, T context) {
        listener.enter(node).accept(context);
        super.visitEmptyStatement(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitExpressionStatement(ExpressionStatement node, T context) {
        listener.enter(node).accept(context);
        super.visitExpressionStatement(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitFlush(Flush node, T context) {
        listener.enter(node).accept(context);
        super.visitFlush(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitForEach(ForEach node, T context) {
        listener.enter(node).accept(context);
        super.visitForEach(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitForEachWithKey(ForEachWithKey node, T context) {
        listener.enter(node).accept(context);
        super.visitForEachWithKey(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitIf(If node, T context) {
        listener.enter(node).accept(context);
        super.visitIf(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitPersist(Persist node, T context) {
        listener.enter(node).accept(context);
        super.visitPersist(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitRemove(Remove node, T context) {
        listener.enter(node).accept(context);
        super.visitRemove(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitReturn(Return node, T context) {
        listener.enter(node).accept(context);
        super.visitReturn(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitListValueAssign(
            ListValueAssign node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitListValueAssign(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitPropertyAssign(
            PropertyAssign node, T context
    ) {
        listener.enter(node).accept(context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitVariableAssign(
            VariableAssign node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitVariableAssign(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitBoolType(
            BoolType node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitBoolType(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitClassType(
            ClassType node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitClassType(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitFloatType(
            FloatType node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitFloatType(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitGListType(
            GListType node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitGListType(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitGMapType(
            GMapType node, T context
    ) {
        listener.enter(node).accept(context);
        super.visitGMapType(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitIntegerType(IntegerType node, T context) {
        listener.enter(node).accept(context);
        super.visitIntegerType(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitRepositoryType(RepositoryType node, T context) {
        listener.enter(node).accept(context);
        super.visitRepositoryType(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitStringType(StringType node, T context) {
        listener.enter(node).accept(context);
        super.visitStringType(node, context);
        listener.leave(node).accept(context);
        return null;
    }

    @Override
    public Void visitVoidType(VoidType node, T context) {
        listener.enter(node).accept(context);
        super.visitVoidType(node, context);
        listener.leave(node).accept(context);
        return null;
    }
}
