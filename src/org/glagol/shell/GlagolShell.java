package org.glagol.shell;

import org.rascalmpl.shell.ShellRunner;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

public class GlagolShell {

    private static final String DEFAULT_PORT = "51151";
    private static final String ENV_KEY_GLAGOL_PORT = "GLAGOL_PORT";

    private static final Map<String, String> commandToModule = new HashMap<String, String>() {{
        put("daemon", "Daemon::Compile");
        put("test", "Tests");
    }};

    public static void main(String[] args) throws IOException {
        List<String> arguments = new ArrayList<>(Arrays.asList(args));

        checkForCommand(arguments);
        assembleArgs(arguments);
        runModule(arguments);
    }

    private static void runModule(List<String> arguments) {
        System.out.println("Initializing Glagol...");

        try {
            ShellRunner runner = new ModuleRunner(new PrintWriter(System.out), new PrintWriter(System.err, true));
            runner.run(arguments.toArray(new String[0]));

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

    private static void assembleArgs(List<String> arguments) {
        String command = arguments.get(0);

        if (commandToModule.containsKey(command)) {
            arguments.set(0, commandToModule.get(command));

            if (command.equals("daemon") && arguments.size() == 1) {
                String glagolEnvPort = System.getenv(ENV_KEY_GLAGOL_PORT);
                arguments.add(glagolEnvPort == null ? DEFAULT_PORT : glagolEnvPort);
            }

        } else {
            System.err.println("Command '" + command + "' is unrecognized");
            System.exit(1);
        }
    }

    private static void checkForCommand(List<String> arguments) {
        if (arguments.size() == 0) {
            System.err.println("No commands passed");
            System.exit(1);
        }
    }
}
