package org.glagoldsl.compiler.ast.nodes.declaration;

import org.glagoldsl.compiler.ast.nodes.declaration.controller.Controller;
import org.glagoldsl.compiler.ast.nodes.module.Import;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.glagoldsl.compiler.ast.nodes.module.Namespace;

import java.util.Objects;

public class DeclarationPointer {
    private final String pointer;

    public DeclarationPointer(Module module, NamedDeclaration declaration) {
        pointer = module.getNamespace().toString() + Namespace.NAMESPACE_DELIMITER + declaration.getIdentifier().toString();
    }

    public DeclarationPointer(Module module, Controller controller) {
        pointer = module.getNamespace().toString() + " -> controller " + controller.getRoute().toString();
    }

    public DeclarationPointer(Module module, Repository repository) {
        // find the entity import to which the repository references
        Import entityImport = module.getImports().lookupByAlias(repository.getEntityIdentifier());

        pointer = module.getNamespace().toString()
                + " -> repository <"
                + entityImport.getNamespace().toString()
                + Namespace.NAMESPACE_DELIMITER
                + entityImport.getDeclaration().toString()
                + ">";
    }

    public DeclarationPointer(Module module) {
        pointer = module.getNamespace().toString() + " -> null";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        DeclarationPointer that = (DeclarationPointer) o;
        return Objects.equals(pointer, that.pointer);
    }

    @Override
    public int hashCode() {
        return Objects.hash(pointer);
    }

    @Override
    public String toString() {
        return pointer;
    }
}
