package org.glagoldsl.compiler.ast.walker;

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
import org.glagoldsl.compiler.ast.visitor.VoidVisitor;

public abstract class Walker extends VoidVisitor<Void> {
    private final Listener listener;

    public Walker(Listener listener) {
        this.listener = listener;
    }

    @Override
    public Void visitWhen(When node, Void context) {
        listener.enter(node);
        super.visitWhen(node, context);
        listener.leave(node);

        return null;
    }

    @Override
    public Void visitWhenEmpty(
            WhenEmpty node, Void context
    ) {
        listener.enter(node);
        super.visitWhenEmpty(node, context);
        listener.leave(node);

        return null;
    }

    @Override
    public Void visitNullDeclaration(
            NullDeclaration node, Void context
    ) {
        listener.enter(node);
        super.visitNullDeclaration(node, context);
        listener.leave(node);

        return null;
    }

    @Override
    public Void visitAnnotation(
            Annotation node, Void context
    ) {
        listener.enter(node);
        super.visitAnnotation(node, context);
        listener.leave(node);

        return null;
    }

    @Override
    public Void visitAnnotationArgument(
            AnnotationArgument node, Void context
    ) {
        listener.enter(node);
        super.visitAnnotationArgument(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitEntity(
            Entity node, Void context
    ) {
        listener.enter(node);
        super.visitEntity(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitIdentifier(
            Identifier node, Void context
    ) {
        listener.enter(node);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitRepository(
            Repository node, Void context
    ) {
        listener.enter(node);
        super.visitRepository(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitService(
            Service node, Void context
    ) {
        listener.enter(node);
        super.visitService(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitValue(
            Value node, Void context
    ) {
        listener.enter(node);
        super.visitValue(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitRestController(
            RestController node, Void context
    ) {
        listener.enter(node);
        super.visitRestController(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitRoute(
            Route node, Void context
    ) {
        listener.enter(node);
        super.visitRoute(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitRouteElementLiteral(
            RouteElementLiteral node, Void context
    ) {
        listener.enter(node);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitRouteElementPlaceholder(
            RouteElementPlaceholder node, Void context
    ) {
        listener.enter(node);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitAccessor(
            Accessor node, Void context
    ) {
        listener.enter(node);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitMembers(MemberCollection node, Void context) {
        listener.enter(node);
        super.visitMembers(node, context);
        listener.leave(node);

        return null;
    }

    @Override
    public Void visitAction(
            Action node, Void context
    ) {
        listener.enter(node);
        super.visitAction(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitConstructor(
            Constructor node, Void context
    ) {
        listener.enter(node);
        super.visitConstructor(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitMethod(
            Method node, Void context
    ) {
        listener.enter(node);
        super.visitMethod(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitProperty(
            Property node, Void context
    ) {
        listener.enter(node);
        super.visitProperty(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitBody(
            Body node, Void context
    ) {
        listener.enter(node);
        super.visitBody(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitParameter(
            Parameter node, Void context
    ) {
        listener.enter(node);
        super.visitParameter(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitProxyConstructor(
            ProxyConstructor node, Void context
    ) {
        listener.enter(node);
        super.visitProxyConstructor(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitProxyMethod(
            ProxyMethod node, Void context
    ) {
        listener.enter(node);
        super.visitProxyMethod(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitProxyProperty(
            ProxyProperty node, Void context
    ) {
        listener.enter(node);
        super.visitProxyProperty(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitProxyRequire(
            ProxyRequire node, Void context
    ) {
        listener.enter(node);
        super.visitProxyRequire(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitPhpLabel(
            PhpLabel node, Void context
    ) {
        listener.enter(node);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitProxy(
            Proxy node, Void context
    ) {
        listener.enter(node);
        super.visitProxy(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitConcatenation(
            Concatenation node, Void context
    ) {
        listener.enter(node);
        super.visitConcatenation(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitAddition(
            Addition node, Void context
    ) {
        listener.enter(node);
        super.visitAddition(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitDivision(
            Division node, Void context
    ) {
        listener.enter(node);
        super.visitDivision(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitProduct(
            Product node, Void context
    ) {
        listener.enter(node);
        super.visitProduct(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitSubtraction(
            Subtraction node, Void context
    ) {
        listener.enter(node);
        super.visitSubtraction(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitConjunction(
            Conjunction node, Void context
    ) {
        listener.enter(node);
        super.visitConjunction(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitDisjunction(
            Disjunction node, Void context
    ) {
        listener.enter(node);
        super.visitDisjunction(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitEqual(
            Equal node, Void context
    ) {
        listener.enter(node);
        super.visitEqual(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitGreaterThan(
            GreaterThan node, Void context
    ) {
        listener.enter(node);
        super.visitGreaterThan(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitGreaterThanOrEqual(
            GreaterThanOrEqual node, Void context
    ) {
        listener.enter(node);
        super.visitGreaterThanOrEqual(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitLowerThan(LowerThan node, Void context) {
        listener.enter(node);
        super.visitLowerThan(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitLowerThanOrEqual(LowerThanOrEqual node, Void context) {
        listener.enter(node);
        super.visitLowerThanOrEqual(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitNonEqual(NonEqual node, Void context) {
        listener.enter(node);
        super.visitNonEqual(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitBracket(
            Bracket node, Void context
    ) {
        listener.enter(node);
        super.visitBracket(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitNegative(
            Negative node, Void context
    ) {
        listener.enter(node);
        super.visitNegative(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitPositive(
            Positive node, Void context
    ) {
        listener.enter(node);
        super.visitPositive(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitNegation(
            Negation node, Void context
    ) {
        listener.enter(node);
        super.visitNegation(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitBooleanLiteral(
            BooleanLiteral node, Void context
    ) {
        listener.enter(node);
        super.visitBooleanLiteral(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitDecimalLiteral(
            DecimalLiteral node, Void context
    ) {
        listener.enter(node);
        super.visitDecimalLiteral(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitIntegerLiteral(
            IntegerLiteral node, Void context
    ) {
        listener.enter(node);
        super.visitIntegerLiteral(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitStringLiteral(
            StringLiteral node, Void context
    ) {
        listener.enter(node);
        super.visitStringLiteral(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitEmptyExpression(
            EmptyExpression node, Void context
    ) {
        listener.enter(node);
        super.visitEmptyExpression(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitExpressionQuery(
            ExpressionQuery node, Void context
    ) {
        listener.enter(node);
        super.visitExpressionQuery(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitGList(
            GList node, Void context
    ) {
        listener.enter(node);
        super.visitGList(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitGMap(
            GMap node, Void context
    ) {
        listener.enter(node);
        super.visitGMap(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitInvoke(
            Invoke node, Void context
    ) {
        listener.enter(node);
        super.visitInvoke(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitNew(New node, Void context) {
        listener.enter(node);
        super.visitNew(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitPropertyAccess(PropertyAccess node, Void context) {
        listener.enter(node);
        super.visitPropertyAccess(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitTernary(Ternary node, Void context) {
        listener.enter(node);
        super.visitTernary(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitThis(This node, Void context) {
        listener.enter(node);
        super.visitThis(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitTypeCast(TypeCast node, Void context) {
        listener.enter(node);
        super.visitTypeCast(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitVariable(Variable node, Void context) {
        listener.enter(node);
        super.visitVariable(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitModule(
            Module node, Void context
    ) {
        listener.enter(node);
        super.visitModule(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitDeclarations(DeclarationCollection node, Void context) {
        listener.enter(node);
        super.visitDeclarations(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitNamespace(
            Namespace node, Void context
    ) {
        listener.enter(node);
        super.visitNamespace(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitImport(
            Import node, Void context
    ) {
        listener.enter(node);
        super.visitImport(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQuerySelect(
            QuerySelect node, Void context
    ) {
        listener.enter(node);
        super.visitQuerySelect(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQuerySpec(
            QuerySpec node, Void context
    ) {
        listener.enter(node);
        super.visitQuerySpec(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQuerySource(
            QuerySource node, Void context
    ) {
        listener.enter(node);
        super.visitQuerySource(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryOrderBy(
            QueryOrderBy node, Void context
    ) {
        listener.enter(node);
        super.visitQueryOrderBy(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryOrderByField(
            QueryOrderByField node, Void context
    ) {
        listener.enter(node);
        super.visitQueryOrderByField(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitDefinedQueryLimit(DefinedQueryLimit node, Void context) {
        listener.enter(node);
        super.visitDefinedQueryLimit(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitUndefinedQueryLimit(UndefinedQueryLimit node, Void context) {
        listener.enter(node);
        super.visitUndefinedQueryLimit(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryConjunction(
            QueryConjunction node, Void context
    ) {
        listener.enter(node);
        super.visitQueryConjunction(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryDisjunction(
            QueryDisjunction node, Void context
    ) {
        listener.enter(node);
        super.visitQueryDisjunction(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryEqual(
            QueryEqual node, Void context
    ) {
        listener.enter(node);
        super.visitQueryEqual(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryGreaterThan(
            QueryGreaterThan node, Void context
    ) {
        listener.enter(node);
        super.visitQueryGreaterThan(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryGreaterThanOrEqual(
            QueryGreaterThanOrEqual node, Void context
    ) {
        listener.enter(node);
        super.visitQueryGreaterThanOrEqual(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryLowerThan(QueryLowerThan node, Void context) {
        listener.enter(node);
        super.visitQueryLowerThan(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryLowerThanOrEqual(
            QueryLowerThanOrEqual node, Void context
    ) {
        listener.enter(node);
        super.visitQueryLowerThanOrEqual(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryNonEqual(QueryNonEqual node, Void context) {
        listener.enter(node);
        super.visitQueryNonEqual(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryBracket(
            QueryBracket node, Void context
    ) {
        listener.enter(node);
        super.visitQueryBracket(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryIsNotNull(
            QueryIsNotNull node, Void context
    ) {
        listener.enter(node);
        super.visitQueryIsNotNull(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryIsNull(
            QueryIsNull node, Void context
    ) {
        listener.enter(node);
        super.visitQueryIsNull(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryEmptyExpression(
            QueryEmptyExpression node, Void context
    ) {
        listener.enter(node);
        super.visitQueryEmptyExpression(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryField(
            QueryField node, Void context
    ) {
        listener.enter(node);
        super.visitQueryField(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitQueryInterpolation(
            QueryInterpolation node, Void context
    ) {
        listener.enter(node);
        super.visitQueryInterpolation(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitAssign(
            Assign node, Void context
    ) {
        listener.enter(node);
        super.visitAssign(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitAssignOperator(
            AssignOperator node, Void context
    ) {
        listener.enter(node);
        super.visitAssignOperator(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitBlock(
            Block node, Void context
    ) {
        listener.enter(node);
        super.visitBlock(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitBreak(
            Break node, Void context
    ) {
        listener.enter(node);
        super.visitBreak(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitContinue(
            Continue node, Void context
    ) {
        listener.enter(node);
        super.visitContinue(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitDeclare(Declare node, Void context) {
        listener.enter(node);
        super.visitDeclare(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitEmptyStatement(EmptyStatement node, Void context) {
        listener.enter(node);
        super.visitEmptyStatement(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitExpressionStatement(ExpressionStatement node, Void context) {
        listener.enter(node);
        super.visitExpressionStatement(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitFlush(Flush node, Void context) {
        listener.enter(node);
        super.visitFlush(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitForEach(ForEach node, Void context) {
        listener.enter(node);
        super.visitForEach(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitForEachWithKey(ForEachWithKey node, Void context) {
        listener.enter(node);
        super.visitForEachWithKey(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitIf(If node, Void context) {
        listener.enter(node);
        super.visitIf(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitPersist(Persist node, Void context) {
        listener.enter(node);
        super.visitPersist(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitRemove(Remove node, Void context) {
        listener.enter(node);
        super.visitRemove(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitReturn(Return node, Void context) {
        listener.enter(node);
        super.visitReturn(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitListValueAssign(
            ListValueAssign node, Void context
    ) {
        listener.enter(node);
        super.visitListValueAssign(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitPropertyAssign(
            PropertyAssign node, Void context
    ) {
        listener.enter(node);
        super.visitPropertyAssign(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitVariableAssign(
            VariableAssign node, Void context
    ) {
        listener.enter(node);
        super.visitVariableAssign(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitBoolType(
            BoolType node, Void context
    ) {
        listener.enter(node);
        super.visitBoolType(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitClassType(
            ClassType node, Void context
    ) {
        listener.enter(node);
        super.visitClassType(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitFloatType(
            FloatType node, Void context
    ) {
        listener.enter(node);
        super.visitFloatType(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitGListType(
            GListType node, Void context
    ) {
        listener.enter(node);
        super.visitGListType(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitGMapType(
            GMapType node, Void context
    ) {
        listener.enter(node);
        super.visitGMapType(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitIntegerType(IntegerType node, Void context) {
        listener.enter(node);
        super.visitIntegerType(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitRepositoryType(RepositoryType node, Void context) {
        listener.enter(node);
        super.visitRepositoryType(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitStringType(StringType node, Void context) {
        listener.enter(node);
        super.visitStringType(node, context);
        listener.leave(node);
        return null;
    }

    @Override
    public Void visitVoidType(VoidType node, Void context) {
        listener.enter(node);
        super.visitVoidType(node, context);
        listener.leave(node);
        return null;
    }
}
