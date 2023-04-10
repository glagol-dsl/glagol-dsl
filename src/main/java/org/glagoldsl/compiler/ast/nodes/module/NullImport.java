package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.ast.nodes.identifier.NullIdentifier;

public class NullImport extends Import {
    public NullImport() {
        super(new NullNamespace(), new NullIdentifier());
    }
}
