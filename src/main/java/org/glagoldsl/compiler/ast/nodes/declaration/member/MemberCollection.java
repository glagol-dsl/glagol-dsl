package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.List;

public class MemberCollection extends ArrayList<Member> {

    public List<Property> properties() {
        return filter(Property.class);
    }

    public List<Method> methods() {
        return filter(Method.class);
    }

    public List<Constructor> constructors() {
        return filter(Constructor.class);
    }

    public List<Action> actions() {
        return filter(Action.class);
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitMembers(this, context);
    }

    @NotNull
    private <T extends Member> ArrayList<T> filter(Class<T> type) {
        var collection = new ArrayList<T>();

        forEach(member -> {
            if (type.isInstance(member)) {
                collection.add(type.cast(member));
            }
        });

        return collection;
    }
}
