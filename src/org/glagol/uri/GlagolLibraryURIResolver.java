package org.glagol.uri;

import org.rascalmpl.uri.libraries.ClassResourceInput;

public class GlagolLibraryURIResolver extends ClassResourceInput {
    public GlagolLibraryURIResolver() {
        super("glagol", GlagolLibraryURIResolver.class, "/library");
    }
}
