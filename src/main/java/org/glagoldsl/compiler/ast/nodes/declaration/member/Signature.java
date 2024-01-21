package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.CodeCoverageIgnore;
import org.glagoldsl.compiler.ast.nodes.declaration.member.method.Parameter;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;

import java.util.List;
import java.util.Objects;

public class Signature {
    private final Identifier name;
    private final List<Type> types;

    public Signature(Identifier name, List<Type> types) {
        this.name = name;
        this.types = types;
    }

    public Signature(Identifier name, Type... types) {
        this.name = name;
        this.types = List.of(types);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Signature signature = (Signature) o;
        return Objects.equals(name, signature.name) && Objects.equals(types, signature.types);
    }

    @CodeCoverageIgnore
    @Override
    public int hashCode() {
        return Objects.hash(name, types);
    }

    @Override
    public String toString() {
        List<String> stringifiedTypes = types.stream().map(Type::toString).toList();

        return name + "(" + String.join(", ", stringifiedTypes) + ")";
    }
}
