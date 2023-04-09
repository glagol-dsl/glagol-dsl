package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.junit.jupiter.api.Test;
import org.mockito.junit.jupiter.MockitoExtension;
import org.junit.jupiter.api.extension.ExtendWith;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MemberCollectionTest {
    @Test
    void it_retrieves_properties_only() {
        var members = new MemberCollection();
        var prop1 = mock(Property.class);
        var prop2 = mock(Property.class);
        members.add(prop1);
        members.add(prop2);
        members.add(mock(Method.class));

        assertEquals(2, members.properties().size());
        assertInstanceOf(Property.class, members.properties().get(0));
        assertInstanceOf(Property.class, members.properties().get(1));
    }

    @Test
    void it_retrieves_constructors_only() {
        var members = new MemberCollection();
        var constr1 = mock(Constructor.class);
        var constr2 = mock(Constructor.class);
        members.add(constr1);
        members.add(constr2);
        members.add(mock(Method.class));

        assertEquals(2, members.constructors().size());
        assertInstanceOf(Constructor.class, members.constructors().get(0));
        assertInstanceOf(Constructor.class, members.constructors().get(1));
    }

    @Test
    void it_retrieves_methods_only() {
        var members = new MemberCollection();
        members.add(mock(Constructor.class));
        members.add(mock(Constructor.class));
        var method = mock(Method.class);
        members.add(method);

        assertEquals(1, members.methods().size());
        assertInstanceOf(Method.class, members.methods().get(0));
    }

    @Test
    void it_retrieves_actions_only() {
        var members = new MemberCollection();
        var action1 = mock(Action.class);
        var action2 = mock(Action.class);
        members.add(action1);
        members.add(action2);
        members.add(mock(Method.class));

        assertEquals(2, members.actions().size());
        assertInstanceOf(Action.class, members.actions().get(0));
        assertInstanceOf(Action.class, members.actions().get(1));
    }
}
