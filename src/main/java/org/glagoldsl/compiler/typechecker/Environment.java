package org.glagoldsl.compiler.typechecker;

import org.glagoldsl.compiler.ast.nodes.module.ModuleSet;
import org.glagoldsl.compiler.ast.nodes.Node;
import org.glagoldsl.compiler.ast.nodes.NullNode;
import org.glagoldsl.compiler.ast.nodes.declaration.Declaration;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;
import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.Map;

/**
 * Contains errors, definitions and import for a particular scope (node).
 *
 * For example, local variables defined within a method are scoped to this method alone.
 */
public class Environment {
    private ModuleSet modules;
    private Node scope;
    private ErrorCollection errors;
    private Map<Identifier, Type> definitions;
    private Map<Identifier, Declaration> imports;

    public Environment() {
        this.modules = new ModuleSet();
        this.scope = new NullNode();
        errors = new ErrorCollection();
        definitions = new HashMap<>();
        imports = new HashMap<>();
    }

    public Node getScope() {
        return scope;
    }

    public ErrorCollection getErrors() {
        return errors;
    }

    public Map<Identifier, Type> getDefinitions() {
        return definitions;
    }

    public Map<Identifier, Declaration> getImports() {
        return imports;
    }

    public ModuleSet getModules() {
        return modules;
    }

    public Environment withScope(Node scope) {
        var environment = copy();
        environment.scope = scope;
        return environment;
    }

    public Environment withModuleSet(ModuleSet modules) {
        var environment = copy();
        environment.modules = modules;
        return environment;
    }

    @NotNull
    private Environment copy() {
        var environment = new Environment();
        environment.scope = this.scope;
        environment.modules = this.modules;
        environment.errors = this.errors;
        environment.definitions = this.definitions;
        environment.imports = this.imports;
        return environment;
    }
}
