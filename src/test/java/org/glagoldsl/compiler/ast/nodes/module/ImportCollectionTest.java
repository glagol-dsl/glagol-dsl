package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ImportCollectionTest {

    @Test
    void it_looks_up_by_alias() {
        Import io = new Import(new Namespace(new Identifier("std"), new Identifier("io")), new Identifier("io"));
        Import math = new Import(new Namespace(new Identifier("std"), new Identifier("math")), new Identifier("math"));

        ImportCollection imports = new ImportCollection() {{
            add(io);
            add(math);
        }};

        Import ioImport = imports.lookupByAlias(new Identifier("io"));
        Import mathImport = imports.lookupByAlias(new Identifier("math"));
        Import unknown = imports.lookupByAlias(new Identifier("null"));

        assertEquals(io, ioImport);
        assertEquals(math, mathImport);
        assertEquals(new NullImport(), unknown);
    }
}