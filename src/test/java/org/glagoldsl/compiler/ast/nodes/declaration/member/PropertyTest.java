package org.glagoldsl.compiler.ast.nodes.declaration.member;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.expression.EmptyExpression;
import org.glagoldsl.compiler.ast.nodes.expression.Expression;
import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.type.Type;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class PropertyTest {
    @Test
    void accept(@Mock DeclarationVisitor<Void, Void> visitor) {
        var node = new Property(Accessor.PUBLIC, mock(Type.class), mock(Identifier.class), mock(Expression.class));
        node.accept(visitor, null);
        verify(visitor, times(1)).visitProperty(any(), any());
    }

    @Test
    void getDefaultValue() {
        var defaultValue = mock(Expression.class);
        var node = new Property(Accessor.PUBLIC, mock(Type.class), mock(Identifier.class), defaultValue);
        assertSame(defaultValue, node.getDefaultValue());
    }

    @Test
    void hasDefaultValue() {
        var node = new Property(Accessor.PUBLIC, mock(Type.class), mock(Identifier.class), mock(Expression.class));
        var node2 = new Property(Accessor.PUBLIC, mock(Type.class), mock(Identifier.class), new EmptyExpression());
        assertTrue(node.hasDefaultValue());
        assertFalse(node2.hasDefaultValue());
    }

    @Test
    void getType() {
        var type = mock(Type.class);
        var node = new Property(Accessor.PUBLIC, type, mock(Identifier.class), mock(Expression.class));
        assertSame(type, node.getType());
    }

    @Test
    void getName() {
        var name = mock(Identifier.class);
        var node = new Property(Accessor.PUBLIC, mock(Type.class), name, mock(Expression.class));
        assertSame(name, node.getName());
    }

    @Test
    void isProperty() {
        var node = new Property(Accessor.PUBLIC, mock(Type.class), mock(Identifier.class), mock(Expression.class));
        assertTrue(node.isProperty());
    }
}
