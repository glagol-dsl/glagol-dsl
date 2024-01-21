package org.glagoldsl.compiler.ast.nodes.declaration;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.glagoldsl.compiler.ast.nodes.module.Module;
import org.glagoldsl.compiler.ast.nodes.module.Namespace;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.*;

class NullDeclarationTest {

    @Test
    void is_null() {
        assertTrue(new NullDeclaration().isNull());
    }

    @Test
    @SuppressWarnings("unchecked")
    void accept() {
        var visitor = (DeclarationVisitor<Void, Void>) mock(DeclarationVisitor.class);
        var nullDeclaration = new NullDeclaration();
        nullDeclaration.accept(visitor, null);

        verify(visitor, times(1)).visitNullDeclaration(nullDeclaration, null);
    }

    @Test
    void pointer() {
        var nullDeclaration = new NullDeclaration();
        var module = mock(Module.class);
        when(module.getNamespace()).thenReturn(new Namespace(new Identifier("org"), new Identifier("glagoldsl")));
        var pointer = nullDeclaration.pointer(module);

        assertEquals("org::glagoldsl -> null", pointer.toString());
    }
}