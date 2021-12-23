package org.glagoldsl.compiler.ast.nodes.declaration.member.proxy;

import org.glagoldsl.compiler.ast.nodes.declaration.DeclarationVisitor;
import org.glagoldsl.compiler.ast.nodes.declaration.member.Member;

public class ProxyRequire extends Member {
    final private String pkg;
    final private String version;

    public ProxyRequire(
            String pkg,
            String version
    ) {
        this.pkg = pkg;
        this.version = version;
    }

    public String getPackage() {
        return pkg;
    }

    public String getVersion() {
        return version;
    }

    public <T, C> T accept(DeclarationVisitor<T, C> visitor, C context) {
        return visitor.visitProxyRequire(this, context);
    }
}
