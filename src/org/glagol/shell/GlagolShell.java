package org.glagol.shell;

import org.rascalmpl.shell.*;

import java.io.IOException;
import java.io.PrintWriter;

public class GlagolShell {
    public static void main(String[] args) throws IOException {
        try {
            ShellRunner runner = new ModuleRunner(new PrintWriter(System.out), new PrintWriter(System.err, true));
            runner.run(args);

            System.exit(0);
        }
        catch (Throwable e) {
            System.err.println("\n\nunexpected error: " + e.getMessage());
            e.printStackTrace(System.err);
            System.exit(1);
        }
        finally {
            System.out.flush();
            System.err.flush();
        }
    }
}
