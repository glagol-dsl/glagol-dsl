package org.glagoldsl.compiler.ast;

import org.glagoldsl.compiler.ast.meta.Location;
import org.glagoldsl.compiler.ast.meta.SourcePath;
import org.glagoldsl.compiler.ast.meta.UndefinedLocation;
import org.glagoldsl.compiler.ast.meta.UndefinedSourcePath;

public abstract class Node {
    private Location location = new UndefinedLocation();
    private SourcePath path = new UndefinedSourcePath();

    public Location getLocation() {
        return location;
    }

    public void setLocation(Location location) {
        this.location = location;
    }

    public SourcePath getPath() {
        return path;
    }

    public void setPath(SourcePath path) {
        this.path = path;
    }
}
