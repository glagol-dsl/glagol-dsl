package org.glagoldsl.compiler.ast.nodes.module;

import org.glagoldsl.compiler.ast.nodes.identifier.Identifier;

import java.util.ArrayList;

public class ImportCollection extends ArrayList<Import> {
    public Import lookupByAlias(Identifier identifier) {
        // find an import with the given alias
        for (Import anImport : this) {
            if (anImport.getAlias().equals(identifier)) {
                return anImport;
            }
        }

        return new NullImport();
    }
}
