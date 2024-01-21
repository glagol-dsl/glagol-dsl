package org.glagoldsl.compiler.typechecker;

import org.glagoldsl.compiler.ast.nodes.declaration.Declaration;
import org.glagoldsl.compiler.ast.nodes.declaration.NullDeclaration;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.glagoldsl.compiler.ast.nodes.module.ModuleSet;
import org.glagoldsl.compiler.ast.nodes.module.NullModule;
import org.glagoldsl.compiler.ast.nodes.type.Type;
import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.Map;

/**
 * Contains errors, definitions and import for a particular scope (node).
 * For example, local variables defined within a method are scoped to this method alone.
 */
public class Environment {
    private ModuleSet modules = new ModuleSet();
    private Module module = new NullModule();
    private Declaration declaration = new NullDeclaration();
    private ErrorCollection errors = new ErrorCollection();
    private Map<Identifier, Type> definitions = new HashMap<>();
    private Map<Identifier, Declaration> imports = new HashMap<>();

    public ErrorCollection getErrors() {
        return errors;
    }

    public Module getModule() {
        return module;
    }

    public Declaration getDeclaration() {
        return declaration;
    }

    public Environment withModules(ModuleSet modules) {
        var environment = copy();
        environment.modules = modules;
        return environment;
    }

    public Environment inModule(Module module) {
        var environment = copy();
        environment.module = module;
        return environment;
    }

    public Environment inDeclaration(Declaration declaration) {
        var environment = copy();
        environment.declaration = declaration;
        return environment;
    }

    @NotNull
    private Environment copy() {
        var environment = new Environment();
        environment.modules = this.modules;
        environment.module = this.module;
        environment.declaration = this.declaration;
        environment.errors = this.errors;
        environment.definitions = this.definitions;
        environment.imports = this.imports;
        return environment;
    }
}
