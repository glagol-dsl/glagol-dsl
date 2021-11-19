package org.glagoldsl.compiler.ast;

import org.antlr.v4.runtime.CommonTokenFactory;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.UnbufferedCharStream;
import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;
import org.antlr.v4.runtime.tree.ParseTree;
import org.apache.commons.lang3.StringUtils;
import org.glagoldsl.compiler.ast.annotation.Annotation;
import org.glagoldsl.compiler.ast.declaration.*;
import org.glagoldsl.compiler.ast.declaration.controller.RestController;
import org.glagoldsl.compiler.ast.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.declaration.controller.route.RouteElement;
import org.glagoldsl.compiler.ast.declaration.controller.route.RouteElementLiteral;
import org.glagoldsl.compiler.ast.declaration.controller.route.RouteElementPlaceholder;
import org.glagoldsl.compiler.ast.declaration.proxy.PhpLabel;
import org.glagoldsl.compiler.ast.identifier.Identifier;
import org.glagoldsl.compiler.ast.meta.Location;
import org.glagoldsl.compiler.ast.module.Import;
import org.glagoldsl.compiler.ast.module.Module;
import org.glagoldsl.compiler.ast.module.Namespace;
import org.glagoldsl.compiler.syntax.concrete.GlagolLexer;
import org.glagoldsl.compiler.syntax.concrete.GlagolParser;
import org.glagoldsl.compiler.syntax.concrete.GlagolParser.*;
import org.glagoldsl.compiler.syntax.concrete.GlagolVisitor;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class ASTBuilder extends AbstractParseTreeVisitor<Node> implements GlagolVisitor<Node> {

    public Module build(InputStream inputStream) {
        GlagolLexer lexer = new GlagolLexer(new UnbufferedCharStream(inputStream));
        lexer.setTokenFactory(new CommonTokenFactory(true));
        GlagolParser parser = new GlagolParser(new CommonTokenStream(lexer));

        return visitModule(parser.module());
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
    public Node visitImportPlain(ImportPlainContext ctx) {
        Identifier declaration = (Identifier) visit(ctx.decl);
        return new Import((Namespace) visit(ctx.namespace()), declaration, declaration);
    }

    @Override
    public Node visitImportAlias(ImportAliasContext ctx) {
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
        String name = StringUtils.stripStart(ctx.ANNOTATION_NAME().getText(), "@");
        return new Annotation(new Identifier(name));
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
        return new Proxy(new PhpLabel(ctx.PHP_CLASS().getText()), (NamedDeclaration) visit(ctx.proxable()));
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
        return new RouteElementLiteral(ctx.ID().getText());
    }

    @Override
    public RouteElementPlaceholder visitRouteElementPlaceholder(RouteElementPlaceholderContext ctx) {
        return new RouteElementPlaceholder(ctx.ID().getText());
    }

    @Override
    public Identifier visitIdentifier(IdentifierContext ctx) {
        return new Identifier(ctx.ID().getText());
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
