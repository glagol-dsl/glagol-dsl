package org.glagoldsl.compiler.ast.nodes.declaration;

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

public interface DeclarationVisitor<T, C> {
    // declarations
    default T visitDeclarations(DeclarationCollection node, C context) {
        return null;
    }

    default T visitEntity(Entity node, C context) {
        return null;
    }

    default T visitRepository(Repository node, C context) {
        return null;
    }

    default T visitService(Service node, C context) {
        return null;
    }

    default T visitValue(Value node, C context) {
        return null;
    }

    default T visitRestController(RestController node, C context) {
        return null;
    }
    // controller nodes

    default T visitRoute(Route node, C context) {
        return null;
    }

    default T visitRouteElementLiteral(RouteElementLiteral node, C context) {
        return null;
    }

    default T visitRouteElementPlaceholder(RouteElementPlaceholder node, C context) {
        return null;
    }
    // members

    default T visitAccessor(Accessor node, C context) {
        return null;
    }

    default T visitAction(Action node, C context) {
        return null;
    }

    default T visitMembers(MemberCollection node, C context) {
        return null;
    }

    default T visitConstructor(Constructor node, C context) {
        return null;
    }

    default T visitMethod(Method node, C context) {
        return null;
    }

    default T visitProperty(Property node, C context) {
        return null;
    }
    // method nodes

    default T visitBody(Body node, C context) {
        return null;
    }

    default T visitParameter(Parameter node, C context) {
        return null;
    }
    // proxy members

    default T visitProxyConstructor(ProxyConstructor node, C context) {
        return null;
    }

    default T visitProxyMethod(ProxyMethod node, C context) {
        return null;
    }

    default T visitProxyProperty(ProxyProperty node, C context) {
        return null;
    }

    default T visitProxyRequire(ProxyRequire node, C context) {
        return null;
    }
    // proxy nodes

    default T visitPhpLabel(PhpLabel node, C context) {
        return null;
    }

    default T visitProxy(Proxy node, C context) {
        return null;
    }
    // when nodes

    default T visitWhen(When node, C context) {
        return null;
    }

    default T visitWhenEmpty(WhenEmpty node, C context) {
        return null;
    }
    // null declaration

    default T visitNullDeclaration(NullDeclaration node, C context) {
        return null;
    }
}
