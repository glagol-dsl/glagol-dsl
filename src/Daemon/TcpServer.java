package Daemon;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

import org.rascalmpl.interpreter.result.ICallableValue;
import org.rascalmpl.value.IInteger;
import org.rascalmpl.value.IString;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.IValueFactory;
import org.rascalmpl.value.type.Type;

public class TcpServer {

	private IValueFactory values;
	private static PrintWriter outputBuffer = null;
	
	public TcpServer(IValueFactory values) throws IOException {	
		this.values = values;
	}
	
	public void openSocket(IInteger port, IValue handler) throws IOException {	
		boolean reopen = true;
		
		try ( 
		    ServerSocket serverSocket = new ServerSocket(port.intValue());
		    Socket clientSocket = serverSocket.accept();
		    PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true);
		    BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
		) {
			outputBuffer = out;
			String inputLine;

		    while ((inputLine = in.readLine()) != null) {
		    	
		    	if (inputLine.equals("quit")) {
		    		reopen = false;
		    		break;
		    	}
		    	
		    	processHandler((ICallableValue) handler, inputLine);
		    }

		    clientSocket.close();
		    serverSocket.close();
		    
		    if (reopen)
		    	openSocket(port, handler);
		}
	}

	public void socketWriteLn(IString line) {
		if (outputBuffer != null)
			outputBuffer.println(line.getValue());
	}
	
	private void processHandler(ICallableValue handler, String inputLine) {
		IString input = values.string(inputLine);
		handler.call(new Type[]{input.getType()}, new IValue[]{input}, null);
	}
}
