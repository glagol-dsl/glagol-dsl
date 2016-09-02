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
	
	public TcpServer(IValueFactory values) throws IOException {	
		this.values = values;
	}
	
	public void createServer(IInteger port, IValue handler) {	
		try ( 
		    ServerSocket serverSocket = new ServerSocket(port.intValue());
		    Socket clientSocket = serverSocket.accept();
		    PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true);
		    BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
		) {
			String inputLine, outputLine;

		    while ((inputLine = in.readLine()) != null) {
		    	
		    	outputLine = processHandler((ICallableValue) handler, inputLine);
		    	
		    	if (inputLine.equals("quit") || outputLine.equals("break")) 
		    		break;
		    	
		        out.println(outputLine);
		    }

		    clientSocket.close();
		} catch (IOException e) {
			
		}
	}

	private String processHandler(ICallableValue handler, String inputLine) {
		IString input = values.string(inputLine);
		
		return handler.call(new Type[]{input.getType()}, new IValue[]{input}, null).getValue().toString();
	}
}
