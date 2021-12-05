package org.glagoldsl.compiler.ast;

import org.antlr.v4.runtime.CommonTokenFactory;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.UnbufferedCharStream;
import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;
import org.antlr.v4.runtime.tree.ParseTree;
import org.apache.commons.lang3.StringUtils;
import org.glagoldsl.compiler.ast.annotation.Annotation;
import org.glagoldsl.compiler.ast.annotation.AnnotationArgument;
import org.glagoldsl.compiler.ast.declaration.*;
import org.glagoldsl.compiler.ast.declaration.controller.RestController;
import org.glagoldsl.compiler.ast.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.declaration.controller.route.RouteElement;
import org.glagoldsl.compiler.ast.declaration.controller.route.RouteElementLiteral;
import org.glagoldsl.compiler.ast.declaration.controller.route.RouteElementPlaceholder;
import org.glagoldsl.compiler.ast.declaration.proxy.PhpLabel;
import org.glagoldsl.compiler.ast.expression.*;
import org.glagoldsl.compiler.ast.expression.binary.Concatenation;
import org.glagoldsl.compiler.ast.expression.binary.arithmetic.Addition;
import org.glagoldsl.compiler.ast.expression.binary.arithmetic.Division;
import org.glagoldsl.compiler.ast.expression.binary.arithmetic.Product;
import org.glagoldsl.compiler.ast.expression.binary.arithmetic.Subtraction;
import org.glagoldsl.compiler.ast.expression.binary.relational.*;
import org.glagoldsl.compiler.ast.expression.literal.*;
import org.glagoldsl.compiler.ast.expression.unary.Bracket;
import org.glagoldsl.compiler.ast.expression.unary.arithmetic.Negative;
import org.glagoldsl.compiler.ast.expression.unary.arithmetic.Positive;
import org.glagoldsl.compiler.ast.expression.unary.relational.Negation;
import org.glagoldsl.compiler.ast.identifier.Identifier;
import org.glagoldsl.compiler.ast.meta.Location;
import org.glagoldsl.compiler.ast.module.Import;
import org.glagoldsl.compiler.ast.module.Module;
import org.glagoldsl.compiler.ast.module.Namespace;
import org.glagoldsl.compiler.ast.query.*;
import org.glagoldsl.compiler.ast.query.expression.QueryEmptyExpression;
import org.glagoldsl.compiler.ast.query.expression.QueryExpression;
import org.glagoldsl.compiler.ast.query.expression.QueryField;
import org.glagoldsl.compiler.ast.query.expression.QueryInterpolation;
import org.glagoldsl.compiler.ast.query.expression.binary.relational.*;
import org.glagoldsl.compiler.ast.query.expression.unary.QueryBracket;
import org.glagoldsl.compiler.ast.query.expression.unary.QueryIsNotNull;
import org.glagoldsl.compiler.ast.query.expression.unary.QueryIsNull;
import org.glagoldsl.compiler.ast.type.*;
import org.glagoldsl.compiler.syntax.concrete.GlagolLexer;
import org.glagoldsl.compiler.syntax.concrete.GlagolParser;
import org.glagoldsl.compiler.syntax.concrete.GlagolParser.*;
import org.glagoldsl.compiler.syntax.concrete.GlagolParserVisitor;
import org.jetbrains.annotations.NotNull;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class Builder extends AbstractParseTreeVisitor<Node> implements GlagolParserVisitor<Node> {

    public Module build(InputStream inputStream) {
        return visitModule(parse(inputStream).module());
    }

    public Expression buildExpression(InputStream inputStream) {
        return (Expression) visit(parse(inputStream).expression());
    }

    public Query buildQuery(InputStream inputStream) {
        return (Query) visit(parse(inputStream).query());
    }

    @NotNull
    private GlagolParser parse(InputStream inputStream) {
        GlagolLexer lexer = new GlagolLexer(new UnbufferedCharStream(inputStream));
        lexer.setTokenFactory(new CommonTokenFactory(true));
        return new GlagolParser(new CommonTokenStream(lexer));
    }

    @Override
    public Module visitModule(ModuleContext ctx) {
        List<Import> imports = new ArrayList<>();

        for (UseContext use : ctx.imports) {
            imports.add((Import) visit(use));
        }

        List<Declaration> declarations = new ArrayList<>();

        for (AnnotatedDeclarationContext declaration : ctx.declarations) {
            declarations.add((Declaration) visit(declaration));
        }

        return new Module((Namespace) visit(ctx.namespace()), imports, declarations);
    }

    @Override
    public Namespace visitNamespace(NamespaceContext ctx) {
        List<Identifier> names = new ArrayList<>();

        for (IdentifierContext name : ctx.names) {
            names.add((Identifier) visit(name));
        }

        return new Namespace(names);
    }

    @Override
    public Import visitImportPlain(ImportPlainContext ctx) {
        Identifier declaration = (Identifier) visit(ctx.decl);
        return new Import((Namespace) visit(ctx.namespace()), declaration, declaration);
    }

    @Override
    public Import visitImportAlias(ImportAliasContext ctx) {
        Identifier declaration = (Identifier) visit(ctx.decl);
        Identifier alias = (Identifier) visit(ctx.alias);
        return new Import((Namespace) visit(ctx.namespace()), declaration, alias);
    }

    @Override
    public Declaration visitAnnotatedDeclaration(AnnotatedDeclarationContext ctx) {
        Declaration declaration = (Declaration) visit(ctx.declaration());

        for (AnnotationContext annotation : ctx.annotation()) {
            declaration.addAnnotation((Annotation) visit(annotation));
        }

        return declaration;
    }

    @Override
    public Annotation visitAnnotation(AnnotationContext ctx) {
        String name = StringUtils.stripStart(ctx.AnnotationName().getText(), "@");

        ArrayList<AnnotationArgument> arguments = new ArrayList<>();

        for (ExpressionContext expr : ctx.items) {
            arguments.add(new AnnotationArgument((Expression) visit(expr)));
        }

        return new Annotation(new Identifier(name), arguments);
    }

    @Override
    public Ternary visitExprTernary(ExprTernaryContext ctx) {
        return new Ternary((Expression) visit(ctx.cond), (Expression) visit(ctx.then), (Expression) visit(ctx.els));
    }

    @Override
    public Bracket visitExprBracket(ExprBracketContext ctx) {
        return new Bracket((Expression) visit(ctx.expression()));
    }

    @Override
    public GreaterThanOrEqual visitExprGreaterThanOrEqual(ExprGreaterThanOrEqualContext ctx) {
        return new GreaterThanOrEqual((Expression) visit(ctx.left), (Expression) visit(ctx.right));
    }

    @Override
    public Negation visitExprNegation(ExprNegationContext ctx) {
        return new Negation((Expression) visit(ctx.expression()));
    }

    @Override
    public Concatenation visitExprConcat(ExprConcatContext ctx) {
        return new Concatenation((Expression) visit(ctx.left), (Expression) visit(ctx.right));
    }

    @Override
    public GList visitExprList(ExprListContext ctx) {
        List<Expression> expressions = new ArrayList<>();

        for (ExpressionContext expr : ctx.items) {
            expressions.add((Expression) visit(expr));
        }

        return new GList(expressions);
    }

    @Override
    public GMap visitExprMap(ExprMapContext ctx) {
        HashMap<Expression, Expression> pairs = new HashMap<>();

        for (MapPairContext pair : ctx.pairs) {
            pairs.put((Expression) visit(pair.key), (Expression) visit(pair.val));
        }

        return new GMap(pairs);
    }

    @Override
    public LowerThanOrEqual visitExprLowerThanOrEqual(ExprLowerThanOrEqualContext ctx) {
        return new LowerThanOrEqual((Expression) visit(ctx.left), (Expression) visit(ctx.right));
    }

    @Override
    public Conjunction visitExprConjunction(ExprConjunctionContext ctx) {
        return new Conjunction((Expression) visit(ctx.left), (Expression) visit(ctx.right));
    }

    @Override
    public Expression visitExprLiteral(ExprLiteralContext ctx) {
        return (Expression) visitChildren(ctx);
    }

    @Override
    public This visitExprThis(ExprThisContext ctx) {
        return new This();
    }

    @Override
    public Negative visitExprNegative(ExprNegativeContext ctx) {
        return new Negative((Expression) visit(ctx.expression()));
    }

    @Override
    public TypeCast visitExprTypeCast(ExprTypeCastContext ctx) {
        return new TypeCast((Type) visit(ctx.type()), (Expression) visit(ctx.expression()));
    }

    @Override
    public Equal visitExprEqual(ExprEqualContext ctx) {
        return new Equal((Expression) visit(ctx.left), (Expression) visit(ctx.right));
    }

    @Override
    public Invoke visitExprInvoke(ExprInvokeContext ctx) {
        Expression prev = ctx.prev == null ? new This() : (Expression) visit(ctx.prev);
        List<Expression> arguments = new ArrayList<>();

        for (ExpressionContext expr : ctx.args) {
            arguments.add((Expression) visit(expr));
        }

        return new Invoke(prev, (Identifier) visit(ctx.method), arguments);
    }

    @Override
    public GreaterThan visitExprGreaterThan(ExprGreaterThanContext ctx) {
        return new GreaterThan((Expression) visit(ctx.left), (Expression) visit(ctx.right));
    }

    @Override
    public LowerThan visitExprLowerThan(ExprLowerThanContext ctx) {
        return new LowerThan((Expression) visit(ctx.left), (Expression) visit(ctx.right));
    }

    @Override
    public Disjunction visitExprDisjunction(ExprDisjunctionContext ctx) {
        return new Disjunction((Expression) visit(ctx.left), (Expression) visit(ctx.right));
    }

    @Override
    public PropertyAccess visitExprPropAccess(ExprPropAccessContext ctx) {
        Expression prev = ctx.prev == null ? new This() : (Expression) visit(ctx.prev);
        return new PropertyAccess(prev, (Identifier) visit(ctx.prop));
    }

    @Override
    public NonEqual visitExprNotEqual(ExprNotEqualContext ctx) {
        return new NonEqual((Expression) visit(ctx.left), (Expression) visit(ctx.right));
    }

    @Override
    public Variable visitExprVariable(ExprVariableContext ctx) {
        return new Variable((Identifier) visit(ctx.identifier()));
    }

    @Override
    public ExpressionQuery visitExprQuery(ExprQueryContext ctx) {
        return new ExpressionQuery((QuerySelect) visit(ctx.query()));
    }

    @Override
    public Positive visitExprPositive(ExprPositiveContext ctx) {
        return new Positive((Expression) visit(ctx.expression()));
    }

    @Override
    public Addition visitExprAdd(ExprAddContext ctx) {
        return new Addition((Expression) visit(ctx.left), (Expression) visit(ctx.right));
    }

    @Override
    public Product visitExprProduct(ExprProductContext ctx) {
        return new Product((Expression) visit(ctx.left), (Expression) visit(ctx.right));
    }

    @Override
    public Division visitExprDivision(ExprDivisionContext ctx) {
        return new Division((Expression) visit(ctx.left), (Expression) visit(ctx.right));
    }

    @Override
    public FloatType visitTypeFloat(TypeFloatContext ctx) {
        return new FloatType();
    }

    @Override
    public VoidType visitTypeVoid(TypeVoidContext ctx) {
        return new VoidType();
    }

    @Override
    public BoolType visitTypeBool(TypeBoolContext ctx) {
        return new BoolType();
    }

    @Override
    public GListType visitTypeTypedList(TypeTypedListContext ctx) {
        return new GListType((Type) visit(ctx.type()));
    }

    @Override
    public GMapType visitTypeTypedMap(TypeTypedMapContext ctx) {
        return new GMapType((Type) visit(ctx.key), (Type) visit(ctx.val));
    }

    @Override
    public IntegerType visitTypeInt(TypeIntContext ctx) {
        return new IntegerType();
    }

    @Override
    public RepositoryType visitTypeRepository(TypeRepositoryContext ctx) {
        return new RepositoryType((Identifier) visit(ctx.entityRef));
    }

    @Override
    public ClassType visitTypeClass(TypeClassContext ctx) {
        return new ClassType((Identifier) visit(ctx.class_));
    }

    @Override
    public StringType visitTypeString(TypeStringContext ctx) {
        return new StringType();
    }

    @Override
    public Query visitQuery(QueryContext ctx) {
        return (Query) visitChildren(ctx);
    }

    @Override
    public QuerySelect visitQuerySelect(QuerySelectContext ctx) {
        return new QuerySelect(
                (QuerySpec) visit(ctx.querySpec()),
                (QuerySource) visit(ctx.querySource()),
                ctx.where != null ? (QueryExpression) visit(ctx.where) : new QueryEmptyExpression(),
                ctx.orderBy != null ? (QueryOrderBy) visit(ctx.orderBy) : new QueryOrderBy(new ArrayList<>()),
                ctx.limit != null ? (DefinedQueryLimit) visit(ctx.limit) : new UndefinedQueryLimit()
        );
    }

    @Override
    public QueryExpression visitParseQueryExpression(ParseQueryExpressionContext ctx) {
        return (QueryExpression) visit(ctx.queryExpression());
    }

    @Override
    public QueryExpression visitParseLiteral(ParseLiteralContext ctx) {
        return new QueryInterpolation((Literal) visit(ctx.literal()));
    }

    @Override
    public QuerySpec visitQuerySpecSingle(QuerySpecSingleContext ctx) {
        return new QuerySpec((Identifier) visit(ctx.identifier()), false);
    }

    @Override
    public QuerySpec visitQuerySpecMulti(QuerySpecMultiContext ctx) {
        return new QuerySpec((Identifier) visit(ctx.identifier()), true);
    }

    @Override
    public QuerySource visitQuerySource(QuerySourceContext ctx) {
        return new QuerySource((Identifier) visit(ctx.entityRef), (Identifier) visit(ctx.alias));
    }

    @Override
    public QueryGreaterThanOrEqual visitQueryExprGreaterThanOrEqual(QueryExprGreaterThanOrEqualContext ctx) {
        return new QueryGreaterThanOrEqual((QueryExpression) visit(ctx.left), (QueryExpression) visit(ctx.right));
    }

    @Override
    public QueryInterpolation visitQueryExprExpr(QueryExprExprContext ctx) {
        return new QueryInterpolation((Expression) visit(ctx.expression()));
    }

    @Override
    public QueryEqual visitQueryExprEqual(QueryExprEqualContext ctx) {
        return new QueryEqual((QueryExpression) visit(ctx.left), (QueryExpression) visit(ctx.right));
    }

    @Override
    public QueryNonEqual visitQueryExprNonEqual(QueryExprNonEqualContext ctx) {
        return new QueryNonEqual((QueryExpression) visit(ctx.left), (QueryExpression) visit(ctx.right));
    }

    @Override
    public QueryIsNull visitQueryExprIsNull(QueryExprIsNullContext ctx) {
        return new QueryIsNull((QueryExpression) visit(ctx.expr));
    }

    @Override
    public QueryIsNotNull visitQueryExprIsNotNull(QueryExprIsNotNullContext ctx) {
        return new QueryIsNotNull((QueryExpression) visit(ctx.expr));
    }

    @Override
    public QueryGreaterThan visitQueryExprGreaterThan(QueryExprGreaterThanContext ctx) {
        return new QueryGreaterThan((QueryExpression) visit(ctx.left), (QueryExpression) visit(ctx.right));
    }

    @Override
    public QueryDisjunction visitQueryExprDisjunction(QueryExprDisjunctionContext ctx) {
        return new QueryDisjunction((QueryExpression) visit(ctx.left), (QueryExpression) visit(ctx.right));
    }

    @Override
    public QueryLowerThanOrEqual visitQueryExprLowerThanOrEqual(QueryExprLowerThanOrEqualContext ctx) {
        return new QueryLowerThanOrEqual((QueryExpression) visit(ctx.left), (QueryExpression) visit(ctx.right));
    }

    @Override
    public QueryConjunction visitQueryExprConjunction(QueryExprConjunctionContext ctx) {
        return new QueryConjunction((QueryExpression) visit(ctx.left), (QueryExpression) visit(ctx.right));
    }

    @Override
    public QueryBracket visitQueryExprBracket(QueryExprBracketContext ctx) {
        return new QueryBracket((QueryExpression) visit(ctx.queryExpression()));
    }

    @Override
    public QueryField visitQueryExprField(QueryExprFieldContext ctx) {
        return (QueryField) visit(ctx.field);
    }

    @Override
    public QueryLowerThan visitQueryExprLowerThan(QueryExprLowerThanContext ctx) {
        return new QueryLowerThan((QueryExpression) visit(ctx.left), (QueryExpression) visit(ctx.right));
    }

    @Override
    public QueryField visitQueryField(QueryFieldContext ctx) {
        return new QueryField((Identifier) visit(ctx.entityRef), (Identifier) visit(ctx.prop));
    }

    @Override
    public QueryOrderBy visitQueryOrderBy(QueryOrderByContext ctx) {
        List<QueryOrderByField> fields = new ArrayList<>();

        for (QueryOrderByFieldContext field : ctx.fields) {
            fields.add((QueryOrderByField) visit(field));
        }

        return new QueryOrderBy(fields);
    }

    @Override
    public DefinedQueryLimit visitQueryLimitNoOffset(QueryLimitNoOffsetContext ctx) {
        return new DefinedQueryLimit((QueryExpression) visit(ctx.size), new QueryEmptyExpression());
    }

    @Override
    public DefinedQueryLimit visitQueryLimitOffset(QueryLimitOffsetContext ctx) {
        return new DefinedQueryLimit((QueryExpression) visit(ctx.size), (QueryExpression) visit(ctx.offset));
    }

    @Override
    public QueryOrderByField visitQueryOrderByFieldAscending(QueryOrderByFieldAscendingContext ctx) {
        return new QueryOrderByField((QueryField) visit(ctx.field), false);
    }

    @Override
    public QueryOrderByField visitQueryOrderByFieldDescending(QueryOrderByFieldDescendingContext ctx) {
        return new QueryOrderByField((QueryField) visit(ctx.field), true);
    }

    @Override
    public New visitExprNew(ExprNewContext ctx) {
        List<Expression> expressions = new ArrayList<>();

        for (ExpressionContext expr : ctx.args) {
            expressions.add((Expression) visit(expr));
        }

        return new New((Identifier) visit(ctx.identifier()), expressions);
    }

    @Override
    public Subtraction visitExprSub(ExprSubContext ctx) {
        return new Subtraction((Expression) visit(ctx.left), (Expression) visit(ctx.right));
    }

    @Override
    public StringLiteral visitLiteralString(LiteralStringContext ctx) {
        return StringLiteral.createFromQuoted(ctx.StringLiteral().getText());
    }

    @Override
    public IntegerLiteral visitLiteralInteger(LiteralIntegerContext ctx) {
        return new IntegerLiteral(Integer.parseInt(ctx.IntegerLiteral().getText()));
    }

    @Override
    public BooleanLiteral visitLiteralBoolean(LiteralBooleanContext ctx) {
        return new BooleanLiteral(ctx.getText().equals("true"));
    }

    @Override
    public DecimalLiteral visitLiteralDecimal(LiteralDecimalContext ctx) {
        return new DecimalLiteral(new BigDecimal(ctx.getText()));
    }

    @Override
    public Node visitMapPair(MapPairContext ctx) {
        // never getting reached
        return null;
    }

    @Override
    public Declaration visitDeclaration(DeclarationContext ctx) {
        return (Declaration) visitChildren(ctx);
    }

    @Override
    public Entity visitEntity(EntityContext ctx) {
        return new Entity((Identifier) visit(ctx.identifier()));
    }

    @Override
    public Repository visitRepository(RepositoryContext ctx) {
        return new Repository((Identifier) visit(ctx.identifier()));
    }

    @Override
    public Value visitValue(ValueContext ctx) {
        return new Value((Identifier) visit(ctx.identifier()));
    }

    @Override
    public RestController visitControllerRest(ControllerRestContext ctx) {
        return new RestController((Route) visit(ctx.route()));
    }

    @Override
    public Service visitService(ServiceContext ctx) {
        return new Service((Identifier) visit(ctx.identifier()));
    }

    @Override
    public Proxy visitProxy(ProxyContext ctx) {
        return new Proxy(new PhpLabel(ctx.PhpClass().getText()), (NamedDeclaration) visit(ctx.proxable()));
    }

    @Override
    public NamedDeclaration visitProxable(ProxableContext ctx) {
        return (NamedDeclaration) visitChildren(ctx);
    }

    @Override
    public Service visitProxableService(ProxableServiceContext ctx) {
        return new Service((Identifier) visit(ctx.identifier()));
    }

    @Override
    public Value visitProxableValue(ProxableValueContext ctx) {
        return new Value((Identifier) visit(ctx.identifier()));
    }

    @Override
    public Route visitRoute(RouteContext ctx) {
        List<RouteElement> routeElements = new ArrayList<>();

        for (RouteElementContext routeElementContext : ctx.routeElement()) {
            routeElements.add((RouteElement) visit(routeElementContext));
        }

        return new Route(routeElements);
    }

    @Override
    public RouteElement visitRouteElement(RouteElementContext ctx) {
        return (RouteElement) visitChildren(ctx);
    }

    @Override
    public RouteElementLiteral visitRouteElementLiteral(RouteElementLiteralContext ctx) {
        return new RouteElementLiteral(ctx.Identifier().getText());
    }

    @Override
    public RouteElementPlaceholder visitRouteElementPlaceholder(RouteElementPlaceholderContext ctx) {
        return new RouteElementPlaceholder(ctx.Identifier().getText());
    }

    @Override
    public Identifier visitIdentifier(IdentifierContext ctx) {
        return new Identifier(ctx.Identifier().getText());
    }

    @Override
    public Node visit(ParseTree tree) {
        Node node = super.visit(tree);
        if (tree instanceof ParserRuleContext context) {
            node.setLocation(new Location(context.start.getLine(), context.start.getCharPositionInLine()));
        }
        return node;
    }
}
