package org.glagoldsl.compiler.ast;

import org.antlr.v4.runtime.BailErrorStrategy;
import org.antlr.v4.runtime.CommonTokenFactory;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.UnbufferedCharStream;
import org.antlr.v4.runtime.misc.ParseCancellationException;
import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;
import org.glagoldsl.compiler.ast.declaration.*;
import org.glagoldsl.compiler.ast.declaration.controller.RestController;
import org.glagoldsl.compiler.ast.declaration.controller.route.Route;
import org.glagoldsl.compiler.ast.declaration.controller.route.RouteElement;
import org.glagoldsl.compiler.ast.declaration.controller.route.RouteElementLiteral;
import org.glagoldsl.compiler.ast.declaration.controller.route.RouteElementPlaceholder;
import org.glagoldsl.compiler.ast.declaration.proxy.PhpLabel;
import org.glagoldsl.compiler.ast.identifier.Identifier;
import org.glagoldsl.compiler.ast.namespace.Namespace;
import org.glagoldsl.compiler.syntax.concrete.GlagolLexer;
import org.glagoldsl.compiler.syntax.concrete.GlagolParser;
import org.glagoldsl.compiler.syntax.concrete.GlagolParser.*;
import org.glagoldsl.compiler.syntax.concrete.GlagolVisitor;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class ASTBuilder extends AbstractParseTreeVisitor<Node> implements GlagolVisitor<Node> {
    @Override
    public Namespace visitNamespace(NamespaceContext ctx) {
        List<Declaration> declarations = new ArrayList<>();

        for (DeclarationContext declaration : ctx.declarations) {
            declarations.add((Declaration) visit(declaration));
        }

        return new Namespace((Identifier) visit(ctx.identifier()), declarations);
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
        return new Proxy(new PhpLabel(ctx.PHP_LABEL().getText()), (NamedDeclaration) visit(ctx.proxable()));
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
        Route route = new Route();

        for (RouteElementContext routeElementContext : ctx.routeElement()) {
            route.add((RouteElement) visit(routeElementContext));
        }

        return route;
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

    public Namespace buildNamespace(InputStream inputStream) {
        GlagolLexer lexer = new GlagolLexer(new UnbufferedCharStream(inputStream));
        lexer.setTokenFactory(new CommonTokenFactory(true));
        GlagolParser parser = new GlagolParser(new CommonTokenStream(lexer));

        return visitNamespace(parser.namespace());
    }
}
