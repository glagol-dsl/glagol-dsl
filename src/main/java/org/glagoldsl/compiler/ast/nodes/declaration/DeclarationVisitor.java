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
    T visitEntity(Entity node, C context);
    T visitRepository(Repository node, C context);
    T visitService(Service node, C context);
    T visitValue(Value node, C context);
    T visitRestController(RestController node, C context);

    // controller nodes
    T visitRoute(Route node, C context);
    T visitRouteElementLiteral(RouteElementLiteral node, C context);
    T visitRouteElementPlaceholder(RouteElementPlaceholder node, C context);

    // members
    T visitAccessor(Accessor node, C context);
    T visitAction(Action node, C context);
    T visitConstructor(Constructor node, C context);
    T visitMethod(Method node, C context);
    T visitProperty(Property node, C context);

    // method nodes
    T visitBody(Body node, C context);
    T visitParameter(Parameter node, C context);

    // proxy members
    T visitProxyConstructor(ProxyConstructor node, C context);
    T visitProxyMethod(ProxyMethod node, C context);
    T visitProxyProperty(ProxyProperty node, C context);
    T visitProxyRequire(ProxyRequire node, C context);

    // proxy nodes
    T visitPhpLabel(PhpLabel node, C context);
    T visitProxy(Proxy node, C context);

    // when nodes
    T visitWhen(When node, C context);
    T visitWhenEmpty(WhenEmpty node, C context);
}
