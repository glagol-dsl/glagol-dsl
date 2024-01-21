package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.ast.nodes.identifier.NullIdentifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;

import java.util.List;

public class ConstructorSignature extends Signature {
    public ConstructorSignature(List<Type> types) {
        super(new NullIdentifier(), types);
    }

    @Override
    public String toString() {
        List<String> stringifiedTypes = getTypes().stream().map(Type::toString).toList();

        return "constructor (" + String.join(", ", stringifiedTypes) + ")";
    }
}
