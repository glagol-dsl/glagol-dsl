package org.glagoldsl.compiler.ast.nodes.declaration;

import org.glagoldsl.compiler.ast.nodes.declaration.controller.Controller;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.List;

public class DeclarationCollection extends ArrayList<Declaration> {

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitDeclarations(this, context);
    }

    public Declaration lookupOne(Identifier identifier) {
        for (NamedDeclaration declaration : named()) {
            if (declaration.getIdentifier().equals(identifier)) {
                return declaration;
            }
        }

        return new NullDeclaration();
    }

    public DeclarationCollection lookupMany(Identifier identifier) {
        return new DeclarationCollection() {{
            addAll(named().stream().filter(declaration -> identifier.equals(declaration.getIdentifier())).toList());
        }};
    }

    public List<Controller> controllers() {
        return filter(Controller.class);
    }

    private List<NamedDeclaration> named() {
        return filter(NamedDeclaration.class);
    }

    @NotNull
    private <T extends Declaration> ArrayList<T> filter(Class<T> type) {
        var collection = new ArrayList<T>();

        forEach(member -> {
            if (type.isInstance(member)) {
                collection.add(type.cast(member));
            }
        });

        return collection;
    }
}
