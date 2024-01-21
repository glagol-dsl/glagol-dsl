package org.glagoldsl.compiler.typechecker;

import org.glagoldsl.compiler.ast.nodes.annotation.AnnotationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.*;
import org.glagoldsl.compiler.ast.nodes.declaration.controller.RestController;
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
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.glagoldsl.compiler.ast.nodes.module.*;
import org.glagoldsl.compiler.ast.nodes.type.Type;

/**
 * Visitor checking for type mismatches
 */
public class TypeMismatch implements ModuleVisitor<Type, Environment>,
        DeclarationVisitor<Type, Environment>,
        AnnotationVisitor<Type, Environment> {

    @Override
    public Type visitModuleSet(ModuleSet node, Environment context) {
        var environment = context.withModules(node);

        node.forEach(module -> module.accept(this, environment));

        return null;
    }

    @Override
    public Type visitModule(
            Module node, Environment context
    ) {
        node.getDeclarations().forEach(declaration -> declaration.accept(this, context.inModule(node)));

        return null;
    }

    @Override
    public Type visitEntity(
            Entity node, Environment context
    ) {
        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));
        node.getMembers().accept(this, context);

        return null;
    }

    @Override
    public Type visitRepository(
            Repository node, Environment context
    ) {
        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));
        node.getMembers().forEach(member -> member.accept(this, context));

        return null;
    }

    @Override
    public Type visitService(
            Service node, Environment context
    ) {
        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));
        node.getMembers().forEach(member -> member.accept(this, context));

        return null;
    }

    @Override
    public Type visitValue(
            Value node, Environment context
    ) {
        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));
        node.getMembers().forEach(member -> member.accept(this, context));

        return null;
    }

    @Override
    public Type visitRestController(
            RestController node, Environment context
    ) {
        node.getAnnotations().forEach(annotation -> annotation.accept(this, context));
        node.getMembers().forEach(member -> member.accept(this, context));

        return null;
    }

    @Override
    public Type visitMembers(MemberCollection node, Environment context) {
        node.properties().forEach(property -> property.accept(this, context));
        node.constructors().forEach(constructor -> constructor.accept(this, context));
        node.methods().forEach(method -> method.accept(this, context));
        node.actions().forEach(action -> action.accept(this, context));

        return null;
    }

    @Override
    public Type visitAction(
            Action node, Environment context
    ) {
        node.getGuard().accept(this, context);
        node.getBody().accept(this, context);
        node.getParameters().forEach(parameter -> parameter.accept(this, context));

        return null;
    }

    @Override
    public Type visitConstructor(
            Constructor node, Environment context
    ) {

        return null;
    }

    @Override
    public Type visitMethod(
            Method node, Environment context
    ) {
        return null;
    }

    @Override
    public Type visitProperty(
            Property node, Environment context
    ) {
        return null;
    }

    @Override
    public Type visitBody(
            Body node, Environment context
    ) {
        return null;
    }

    @Override
    public Type visitParameter(
            Parameter node, Environment context
    ) {
        return null;
    }

    @Override
    public Type visitProxyConstructor(
            ProxyConstructor node, Environment context
    ) {
        return null;
    }

    @Override
    public Type visitProxyMethod(
            ProxyMethod node, Environment context
    ) {
        return null;
    }

    @Override
    public Type visitProxyProperty(
            ProxyProperty node, Environment context
    ) {
        return null;
    }

    @Override
    public Type visitProxyRequire(
            ProxyRequire node, Environment context
    ) {
        return null;
    }

    @Override
    public Type visitPhpLabel(
            PhpLabel node, Environment context
    ) {
        return null;
    }

    @Override
    public Type visitProxy(
            Proxy node, Environment context
    ) {
        return null;
    }

    @Override
    public Type visitWhen(
            When node, Environment context
    ) {
        return null;
    }

    @Override
    public Type visitWhenEmpty(
            WhenEmpty node, Environment context
    ) {
        return null;
    }
}
