package org.glagoldsl.compiler.ast;

import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;
import org.antlr.v4.runtime.tree.ParseTree;
import org.apache.commons.lang3.StringUtils;
import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.annotation.AnnotatedNode;
import org.glagoldsl.compiler.ast.nodes.annotation.Annotation;
import org.glagoldsl.compiler.ast.nodes.annotation.AnnotationArgument;
import org.glagoldsl.compiler.ast.nodes.declaration.*;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.RestController;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.route.RouteElement;
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
import org.glagoldsl.compiler.ast.nodes.meta.Location;
import org.glagoldsl.compiler.ast.nodes.module.Import;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.glagoldsl.compiler.ast.nodes.module.Namespace;
import org.glagoldsl.compiler.ast.nodes.query.*;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryEmptyExpression;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryExpression;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryField;
import org.glagoldsl.compiler.ast.nodes.query.expression.QueryInterpolation;
import org.glagoldsl.compiler.ast.nodes.query.expression.binary.relational.*;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryBracket;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryIsNotNull;
import org.glagoldsl.compiler.ast.nodes.query.expression.unary.QueryIsNull;
import org.glagoldsl.compiler.ast.nodes.statement.*;
import org.glagoldsl.compiler.ast.nodes.statement.assignable.Assignable;
import org.glagoldsl.compiler.ast.nodes.statement.assignable.ListValueAssign;
import org.glagoldsl.compiler.ast.nodes.statement.assignable.PropertyAssign;
import org.glagoldsl.compiler.ast.nodes.statement.assignable.VariableAssign;
import org.glagoldsl.compiler.ast.nodes.type.*;
import org.glagoldsl.compiler.io.Source;
import org.glagoldsl.compiler.io.SourcePathSetter;
import org.glagoldsl.compiler.syntax.concrete.GlagolLexer;
import org.glagoldsl.compiler.syntax.concrete.GlagolParser;
import org.glagoldsl.compiler.syntax.concrete.GlagolParser.*;
import org.glagoldsl.compiler.syntax.concrete.GlagolParserVisitor;
import org.jetbrains.annotations.NotNull;

import java.io.InputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class Builder extends AbstractParseTreeVisitor<Node> implements GlagolParserVisitor<Node> {
    private static class SyntaxErrorListener extends BaseErrorListener {
        private final Source source;

        public SyntaxErrorListener(Source source) {
            this.source = source;
        }

        @Override
        public void syntaxError(
                Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg,
                RecognitionException e
        ) {
            System.err.println(
                    "Syntax error: " + msg + " in " + source.getSourcePath() + ":" + line + ":" + charPositionInLine
            );
        }
    }

    public Module build(Source source) {
        var parser = parse(source.getInputStream(), new SyntaxErrorListener(source));
        var module = (Module) visit(parser.module());

        module.accept(new SourcePathSetter(source.getSourcePath()), null);

        return module;
    }

    public Module build(InputStream inputStream) {
        return (Module) visit(parse(inputStream).module());
    }

    /**
     * Only used for testing
     */
    public Expression buildExpression(InputStream inputStream) {
        return (Expression) visit(parse(inputStream).expression());
    }

    /**
     * Only used for testing
     */
    public Query buildQuery(InputStream inputStream) {
        return (Query) visit(parse(inputStream).query());
    }

    /**
     * Only used for testing
     */
    public AccessibleMember buildGenericMember(InputStream inputStream) {
        return (AccessibleMember) visit(parse(inputStream).genericMember());
    }

    /**
     * Only used for testing
     */
    public Member buildControllerMember(InputStream inputStream) {
        return (Member) visit(parse(inputStream).controllerMember());
    }

    /**
     * Only used for testing
     */
    public Member buildProxyMember(InputStream inputStream) {
        return (Member) visit(parse(inputStream).proxyMember());
    }

    /**
     * Only used for testing
     */
    public Statement buildStatement(InputStream inputStream) {
        return (Statement) visit(parse(inputStream).statement());
    }

    private GlagolParser parse(InputStream inputStream) {
        return parse(inputStream, new BaseErrorListener());
    }

    @NotNull
    private GlagolParser parse(InputStream inputStream, ANTLRErrorListener errorListener) {
        GlagolLexer lexer = new GlagolLexer(new UnbufferedCharStream(inputStream)) {{
            setTokenFactory(new CommonTokenFactory(true));
        }};
        return new GlagolParser(new CommonTokenStream(lexer)) {{
            removeErrorListeners();
            addErrorListener(errorListener);
        }};
    }

    @Override
    public Module visitModule(ModuleContext ctx) {
        List<Import> imports = new ArrayList<>();

        for (UseContext use : ctx.imports) {
            imports.add((Import) visit(use));
        }

        var declarations = new DeclarationCollection();

        for (DeclarationContext declaration : ctx.declarations) {
            declarations.add((Declaration) visit(declaration));
        }

        return new Module(
                (Namespace) visit(ctx.namespace()),
                imports,
                declarations
        );
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
        return new Import(
                (Namespace) visit(ctx.namespace()),
                declaration,
                declaration
        );
    }

    @Override
    public Import visitImportAlias(ImportAliasContext ctx) {
        Identifier declaration = (Identifier) visit(ctx.decl);
        Identifier alias = (Identifier) visit(ctx.alias);
        return new Import(
                (Namespace) visit(ctx.namespace()),
                declaration,
                alias
        );
    }

    @Override
    public Annotation visitAnnotation(AnnotationContext ctx) {
        String name = StringUtils.stripStart(
                ctx.AnnotationName().getText(),
                "@"
        );

        ArrayList<AnnotationArgument> arguments = new ArrayList<>();

        for (ExpressionContext expr : ctx.items) {
            arguments.add(new AnnotationArgument((Expression) visit(expr)));
        }

        return new Annotation(
                new Identifier(name),
                arguments
        );
    }

    @Override
    public Ternary visitExprTernary(ExprTernaryContext ctx) {
        return new Ternary(
                (Expression) visit(ctx.cond),
                (Expression) visit(ctx.then),
                (Expression) visit(ctx.els)
        );
    }

    @Override
    public Bracket visitExprBracket(ExprBracketContext ctx) {
        return new Bracket((Expression) visit(ctx.expression()));
    }

    @Override
    public GreaterThanOrEqual visitExprGreaterThanOrEqual(ExprGreaterThanOrEqualContext ctx) {
        return new GreaterThanOrEqual(
                (Expression) visit(ctx.left),
                (Expression) visit(ctx.right)
        );
    }

    @Override
    public Negation visitExprNegation(ExprNegationContext ctx) {
        return new Negation((Expression) visit(ctx.expression()));
    }

    @Override
    public Concatenation visitExprConcat(ExprConcatContext ctx) {
        return new Concatenation(
                (Expression) visit(ctx.left),
                (Expression) visit(ctx.right)
        );
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
            pairs.put(
                    (Expression) visit(pair.key),
                    (Expression) visit(pair.val)
            );
        }

        return new GMap(pairs);
    }

    @Override
    public LowerThanOrEqual visitExprLowerThanOrEqual(ExprLowerThanOrEqualContext ctx) {
        return new LowerThanOrEqual(
                (Expression) visit(ctx.left),
                (Expression) visit(ctx.right)
        );
    }

    @Override
    public Conjunction visitExprConjunction(ExprConjunctionContext ctx) {
        return new Conjunction(
                (Expression) visit(ctx.left),
                (Expression) visit(ctx.right)
        );
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
        return new TypeCast(
                (Type) visit(ctx.type()),
                (Expression) visit(ctx.expression())
        );
    }

    @Override
    public Equal visitExprEqual(ExprEqualContext ctx) {
        return new Equal(
                (Expression) visit(ctx.left),
                (Expression) visit(ctx.right)
        );
    }

    @Override
    public Invoke visitExprInvoke(ExprInvokeContext ctx) {
        Expression prev = ctx.prev == null ? new This() : (Expression) visit(ctx.prev);
        List<Expression> arguments = new ArrayList<>();

        for (ExpressionContext expr : ctx.args) {
            arguments.add((Expression) visit(expr));
        }

        return new Invoke(
                prev,
                (Identifier) visit(ctx.func),
                arguments
        );
    }

    @Override
    public GreaterThan visitExprGreaterThan(ExprGreaterThanContext ctx) {
        return new GreaterThan(
                (Expression) visit(ctx.left),
                (Expression) visit(ctx.right)
        );
    }

    @Override
    public LowerThan visitExprLowerThan(ExprLowerThanContext ctx) {
        return new LowerThan(
                (Expression) visit(ctx.left),
                (Expression) visit(ctx.right)
        );
    }

    @Override
    public Disjunction visitExprDisjunction(ExprDisjunctionContext ctx) {
        return new Disjunction(
                (Expression) visit(ctx.left),
                (Expression) visit(ctx.right)
        );
    }

    @Override
    public PropertyAccess visitExprPropAccess(ExprPropAccessContext ctx) {
        Expression prev = ctx.prev == null ? new This() : (Expression) visit(ctx.prev);
        return new PropertyAccess(
                prev,
                (Identifier) visit(ctx.prop)
        );
    }

    @Override
    public NonEqual visitExprNotEqual(ExprNotEqualContext ctx) {
        return new NonEqual(
                (Expression) visit(ctx.left),
                (Expression) visit(ctx.right)
        );
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
        return new Addition(
                (Expression) visit(ctx.left),
                (Expression) visit(ctx.right)
        );
    }

    @Override
    public Product visitExprProduct(ExprProductContext ctx) {
        return new Product(
                (Expression) visit(ctx.left),
                (Expression) visit(ctx.right)
        );
    }

    @Override
    public Division visitExprDivision(ExprDivisionContext ctx) {
        return new Division(
                (Expression) visit(ctx.left),
                (Expression) visit(ctx.right)
        );
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
        return new GMapType(
                (Type) visit(ctx.key),
                (Type) visit(ctx.val)
        );
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
    public QuerySpec visitQuerySpecSingle(QuerySpecSingleContext ctx) {
        return new QuerySpec(
                (Identifier) visit(ctx.identifier()),
                false
        );
    }

    @Override
    public QuerySpec visitQuerySpecMulti(QuerySpecMultiContext ctx) {
        return new QuerySpec(
                (Identifier) visit(ctx.identifier()),
                true
        );
    }

    @Override
    public QuerySource visitQuerySource(QuerySourceContext ctx) {
        return new QuerySource(
                (Identifier) visit(ctx.entityRef),
                (Identifier) visit(ctx.alias)
        );
    }

    @Override
    public QueryGreaterThanOrEqual visitQueryExprGreaterThanOrEqual(QueryExprGreaterThanOrEqualContext ctx) {
        return new QueryGreaterThanOrEqual(
                (QueryExpression) visit(ctx.left),
                (QueryExpression) visit(ctx.right)
        );
    }

    @Override
    public QueryInterpolation visitQueryExprExpr(QueryExprExprContext ctx) {
        return new QueryInterpolation((Expression) visit(ctx.expression()));
    }

    @Override
    public QueryEqual visitQueryExprEqual(QueryExprEqualContext ctx) {
        return new QueryEqual(
                (QueryExpression) visit(ctx.left),
                (QueryExpression) visit(ctx.right)
        );
    }

    @Override
    public QueryNonEqual visitQueryExprNonEqual(QueryExprNonEqualContext ctx) {
        return new QueryNonEqual(
                (QueryExpression) visit(ctx.left),
                (QueryExpression) visit(ctx.right)
        );
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
        return new QueryGreaterThan(
                (QueryExpression) visit(ctx.left),
                (QueryExpression) visit(ctx.right)
        );
    }

    @Override
    public QueryDisjunction visitQueryExprDisjunction(QueryExprDisjunctionContext ctx) {
        return new QueryDisjunction(
                (QueryExpression) visit(ctx.left),
                (QueryExpression) visit(ctx.right)
        );
    }

    @Override
    public QueryLowerThanOrEqual visitQueryExprLowerThanOrEqual(QueryExprLowerThanOrEqualContext ctx) {
        return new QueryLowerThanOrEqual(
                (QueryExpression) visit(ctx.left),
                (QueryExpression) visit(ctx.right)
        );
    }

    @Override
    public QueryConjunction visitQueryExprConjunction(QueryExprConjunctionContext ctx) {
        return new QueryConjunction(
                (QueryExpression) visit(ctx.left),
                (QueryExpression) visit(ctx.right)
        );
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
        return new QueryLowerThan(
                (QueryExpression) visit(ctx.left),
                (QueryExpression) visit(ctx.right)
        );
    }

    @Override
    public QueryField visitQueryField(QueryFieldContext ctx) {
        return new QueryField(
                (Identifier) visit(ctx.entityRef),
                (Identifier) visit(ctx.prop)
        );
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
        return new DefinedQueryLimit(
                (QueryExpression) visit(ctx.size),
                new QueryEmptyExpression()
        );
    }

    @Override
    public DefinedQueryLimit visitQueryLimitOffset(QueryLimitOffsetContext ctx) {
        return new DefinedQueryLimit(
                (QueryExpression) visit(ctx.size),
                (QueryExpression) visit(ctx.offset)
        );
    }

    @Override
    public QueryOrderByField visitQueryOrderByFieldAscending(QueryOrderByFieldAscendingContext ctx) {
        return new QueryOrderByField(
                (QueryField) visit(ctx.field),
                false
        );
    }

    @Override
    public QueryOrderByField visitQueryOrderByFieldDescending(QueryOrderByFieldDescendingContext ctx) {
        return new QueryOrderByField(
                (QueryField) visit(ctx.field),
                true
        );
    }

    @Override
    public New visitExprNew(ExprNewContext ctx) {
        List<Expression> expressions = new ArrayList<>();

        for (ExpressionContext expr : ctx.args) {
            expressions.add((Expression) visit(expr));
        }

        return new New(
                (Identifier) visit(ctx.identifier()),
                expressions
        );
    }

    @Override
    public Subtraction visitExprSub(ExprSubContext ctx) {
        return new Subtraction(
                (Expression) visit(ctx.left),
                (Expression) visit(ctx.right)
        );
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
        Declaration declaration = (Declaration) visitChildren(ctx);

        addAnnotations(
                ctx.annotation(),
                declaration
        );

        return declaration;
    }

    private void addAnnotations(
            List<AnnotationContext> annotations,
            AnnotatedNode node
    ) {
        for (AnnotationContext annotation : annotations) {
            node.addAnnotation((Annotation) visit(annotation));
        }
    }

    @Override
    public Entity visitEntity(EntityContext ctx) {
        return new Entity(
                (Identifier) visit(ctx.identifier()),
                createMembers(ctx.genericMember())
        );
    }

    @NotNull
    private <T extends ParseTree> MemberCollection createMembers(List<T> contexts) {
        var members = new MemberCollection();

        for (T member : contexts) {
            members.add((Member) visit(member));
        }
        return members;
    }

    @Override
    public Repository visitRepository(RepositoryContext ctx) {
        return new Repository(
                (Identifier) visit(ctx.identifier()),
                createMembers(ctx.genericMember())
        );
    }

    @Override
    public Value visitValue(ValueContext ctx) {
        return new Value(
                (Identifier) visit(ctx.identifier()),
                createMembers(ctx.genericMember())
        );
    }

    @Override
    public RestController visitControllerRest(ControllerRestContext ctx) {
        return new RestController(
                (Route) visit(ctx.route()),
                createMembers(ctx.controllerMember())
        );
    }

    @Override
    public Service visitService(ServiceContext ctx) {
        return new Service(
                (Identifier) visit(ctx.identifier()),
                createMembers(ctx.genericMember())
        );
    }

    @Override
    public Proxy visitProxy(ProxyContext ctx) {
        return new Proxy(
                new PhpLabel(ctx.PhpClass().getText()),
                (NamedDeclaration) visit(ctx.proxable())
        );
    }

    @Override
    public AccessibleMember visitGenericMember(GenericMemberContext ctx) {
        AccessibleMember member = (AccessibleMember) visitChildren(ctx);

        addAnnotations(
                ctx.annotation(),
                member
        );

        return member;
    }

    @Override
    public Member visitControllerMember(ControllerMemberContext ctx) {
        var member = (Member) visitChildren(ctx);

        addAnnotations(
                ctx.annotation(),
                member
        );

        return member;
    }

    @Override
    public Member visitProxyMember(ProxyMemberContext ctx) {
        var member = (Member) visitChildren(ctx);

        addAnnotations(
                ctx.annotation(),
                member
        );

        return member;
    }

    @Override
    public ProxyRequire visitProxyRequire(ProxyRequireContext ctx) {
        return new ProxyRequire(
                StringLiteral.createFromQuoted(ctx.pkg.getText()).getValue(),
                StringLiteral.createFromQuoted(ctx.ver.getText()).getValue()
        );
    }

    @Override
    public ProxyMethod visitProxyMethod(ProxyMethodContext ctx) {
        return new ProxyMethod(
                (Type) visit(ctx.type()),
                (Identifier) visit(ctx.identifier()),
                createParameters(ctx.params)
        );
    }

    @NotNull
    private List<Parameter> createParameters(List<ParameterContext> contexts) {
        var params = new ArrayList<Parameter>();

        for (ParameterContext param : contexts) {
            params.add((Parameter) visit(param));
        }

        return params;
    }

    @Override
    public ProxyConstructor visitProxyConstructor(ProxyConstructorContext ctx) {
        return new ProxyConstructor(createParameters(ctx.params));
    }

    @Override
    public ProxyProperty visitProxyProperty(ProxyPropertyContext ctx) {
        return new ProxyProperty(
                (Type) visit(ctx.type()),
                (Identifier) visit(ctx.identifier())
        );
    }

    @Override
    public Action visitAction(ActionContext ctx) {
        return new Action(
                (Identifier) visit(ctx.identifier()),
                createParameters(ctx.params), (When) visit(ctx.when()), (Body) visit(ctx.methodBody())
        );
    }

    @Override
    public Method visitMethod(MethodContext ctx) {
        return new Method(
                createAccessor(
                        ctx.accessor,
                        Accessor.PRIVATE
                ),
                (Type) visit(ctx.type()),
                (Identifier) visit(ctx.identifier()),
                createParameters(ctx.params), (When) visit(ctx.when()), (Body) visit(ctx.methodBody())
        );
    }

    @NotNull
    private Accessor createAccessor(
            Token token,
            Accessor defaultAccessor
    ) {
        var text = null == token ? "" : token.getText();

        return switch (text) {
            case "public" -> Accessor.PUBLIC;
            case "private" -> Accessor.PRIVATE;
            default -> defaultAccessor;
        };
    }

    @Override
    public Body visitMethodBodyStatements(MethodBodyStatementsContext ctx) {
        var statements = new ArrayList<Statement>();
        addStatements(
                statements,
                ctx.statement()
        );
        return new Body(statements);
    }

    @Override
    public Statement visitStmtExpression(StmtExpressionContext ctx) {
        return new ExpressionStatement((Expression) visit(ctx.expression()));
    }

    @Override
    public Block visitStmtBlock(StmtBlockContext ctx) {
        var statements = new ArrayList<Statement>();
        addStatements(
                statements,
                ctx.statement()
        );
        return new Block(statements);
    }

    @Override
    public If visitStmtIdThenElse(StmtIdThenElseContext ctx) {
        return new If(
                (Expression) visit(ctx.expression()),
                (Statement) visit(ctx.then),
                (Statement) visit(ctx.elseStmt)
        );
    }

    @Override
    public If visitStmtIdThen(StmtIdThenContext ctx) {
        return new If(
                (Expression) visit(ctx.expression()),
                (Statement) visit(ctx.then),
                new EmptyStatement()
        );
    }

    @Override
    public Return visitStmtReturn(StmtReturnContext ctx) {
        return new Return((Expression) visit(ctx.expression()));
    }

    @Override
    public Return visitStmtReturnVoid(StmtReturnVoidContext ctx) {
        return new Return(new EmptyExpression());
    }

    @Override
    public Persist visitStmtPersist(StmtPersistContext ctx) {
        return new Persist((Expression) visit(ctx.expression()));
    }

    @Override
    public Flush visitStmtFlush(StmtFlushContext ctx) {
        return new Flush((Expression) visit(ctx.expression()));
    }

    @Override
    public Flush visitStmtFlushAll(StmtFlushAllContext ctx) {
        return new Flush(new EmptyExpression());
    }

    @Override
    public Remove visitStmtRemove(StmtRemoveContext ctx) {
        return new Remove((Expression) visit(ctx.expression()));
    }

    @Override
    public Break visitStmtBreak(StmtBreakContext ctx) {
        return new Break(new IntegerLiteral(1));
    }

    @Override
    public Break visitStmtBreakLevel(StmtBreakLevelContext ctx) {
        return new Break(new IntegerLiteral(Integer.parseInt(ctx.level.getText())));
    }

    @Override
    public Continue visitStmtContinue(StmtContinueContext ctx) {
        return new Continue(new IntegerLiteral(1));
    }

    @Override
    public Declare visitStmtDeclareWithValue(StmtDeclareWithValueContext ctx) {
        return new Declare(
                (Type) visit(ctx.type()),
                (Identifier) visit(ctx.identifier()),
                (Statement) visit(ctx.statement())
        );
    }

    @Override
    public Declare visitStmtDeclare(StmtDeclareContext ctx) {
        return new Declare(
                (Type) visit(ctx.type()),
                (Identifier) visit(ctx.identifier()),
                new EmptyStatement()
        );
    }

    @Override
    public Continue visitStmtContinueLevel(StmtContinueLevelContext ctx) {
        return new Continue(new IntegerLiteral(Integer.parseInt(ctx.level.getText())));
    }

    @Override
    public Assign visitStmtAssign(GlagolParser.StmtAssignContext ctx) {
        return new Assign(
                (Assignable) visit(ctx.assignable()),
                createAssignOperator(ctx.assignOperator.getText()),
                (Statement) visit(ctx.statement())
        );
    }

    @Override
    public ForEach visitStmtForeach(StmtForeachContext ctx) {
        return (ForEach) visit(ctx.forEach());
    }

    @Override
    public ForEach visitForEachDefault(ForEachDefaultContext ctx) {
        var conditions = new ArrayList<Expression>();

        for (ExpressionContext expr : ctx.conds) {
            conditions.add((Expression) visit(expr));
        }

        return new ForEach(
                (Expression) visit(ctx.arr),
                (Identifier) visit(ctx.var),
                conditions,
                (Statement) visit(ctx.statement())
        );
    }

    @Override
    public ForEachWithKey visitForEachWithKey(ForEachWithKeyContext ctx) {
        var conditions = new ArrayList<Expression>();

        for (ExpressionContext expr : ctx.conds) {
            conditions.add((Expression) visit(expr));
        }

        return new ForEachWithKey(
                (Expression) visit(ctx.arr),
                (Identifier) visit(ctx.k),
                (Identifier) visit(ctx.var),
                conditions,
                (Statement) visit(ctx.statement())
        );
    }

    private AssignOperator createAssignOperator(String operator) {
        return switch (operator) {
            case "+=" -> AssignOperator.ADDITION;
            case "-=" -> AssignOperator.SUBTRACTION;
            case "*=" -> AssignOperator.PRODUCT;
            case "/=" -> AssignOperator.DIVISION;
            default -> AssignOperator.DEFAULT;
        };
    }

    @Override
    public ListValueAssign visitAssignableListValue(AssignableListValueContext ctx) {
        return new ListValueAssign(
                (Assignable) visit(ctx.assignable()),
                (Expression) visit(ctx.k)
        );
    }

    @Override
    public PropertyAssign visitAssignableProp(GlagolParser.AssignablePropContext ctx) {
        return new PropertyAssign(
                (Expression) visit(ctx.expression()),
                (Identifier) visit(ctx.identifier())
        );
    }

    @Override
    public VariableAssign visitAssignableVar(GlagolParser.AssignableVarContext ctx) {
        return new VariableAssign((Identifier) visit(ctx.identifier()));
    }

    private void addStatements(
            ArrayList<Statement> statements,
            List<StatementContext> statementContexts
    ) {
        for (StatementContext stmt : statementContexts) {
            statements.add((Statement) visit(stmt));
        }
    }

    @Override
    public Body visitMethodBodyExpression(MethodBodyExpressionContext ctx) {
        return new Body(new ArrayList<>() {
            {
                add(new Return((Expression) visit(ctx.expression())));
            }
        });
    }

    @Override
    public Parameter visitParameter(ParameterContext ctx) {
        var parameter = new Parameter(
                (Type) visit(ctx.type()),
                (Identifier) visit(ctx.identifier())
        );
        addAnnotations(
                ctx.annotation(),
                parameter
        );
        return parameter;
    }

    @Override
    public Constructor visitConstructor(ConstructorContext ctx) {
        return new Constructor(
                createAccessor(
                        ctx.accessor,
                        Accessor.PUBLIC
                ),
                createParameters(ctx.params), (When) visit(ctx.when()), (Body) visit(ctx.methodBody())
        );
    }

    @Override
    public When visitWhenExpr(WhenExprContext ctx) {
        return new When((Expression) visit(ctx.expression()));
    }

    @Override
    public WhenEmpty visitWhenEmpty(WhenEmptyContext ctx) {
        return new WhenEmpty();
    }

    @Override
    public Property visitProperty(PropertyContext ctx) {
        var expression = ctx.defaultValue == null ? new EmptyExpression() : (Expression) visit(ctx.defaultValue);

        return new Property(
                createAccessor(
                        ctx.accessor,
                        Accessor.PRIVATE
                ),
                (Type) visit(ctx.type()),
                (Identifier) visit(ctx.identifier()),
                expression
        );
    }

    @Override
    public Service visitProxableService(ProxableServiceContext ctx) {
        return new Service(
                (Identifier) visit(ctx.identifier()),
                createMembers(ctx.proxyMember())
        );
    }

    @Override
    public Value visitProxableValue(ProxableValueContext ctx) {
        return new Value(
                (Identifier) visit(ctx.identifier()),
                createMembers(ctx.proxyMember())
        );
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
    public QueryExpression visitQueryExprLiteral(QueryExprLiteralContext ctx) {
        return new QueryInterpolation((Expression) visit(ctx.literal()));
    }

    @Override
    public EmptyStatement visitStmtEmpty(StmtEmptyContext ctx) {
        return new EmptyStatement();
    }

    @Override
    public Node visit(ParseTree tree) {
        Node node = super.visit(tree);
        if (node != null && tree instanceof ParserRuleContext context) {
            node.setLocation(new Location(
                    context.start.getLine(),
                    context.start.getCharPositionInLine()
            ));
        }
        return node;
    }
}
