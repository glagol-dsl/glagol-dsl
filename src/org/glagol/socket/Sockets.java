package org.glagol.socket;


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Base64;
import java.util.HashMap;

import io.usethesource.vallang.*;
import org.rascalmpl.interpreter.utils.RuntimeExceptionFactory;

import static java.util.Base64.getDecoder;

public class Sockets {
	private static HashMap<IInteger, ServerSocket> serverSockets = new HashMap<IInteger, ServerSocket>();
	private static HashMap<IInteger, Socket> clientSockets = new HashMap<IInteger, Socket>();
	private static HashMap<IInteger, PrintWriter> socketWriters = new HashMap<IInteger, PrintWriter>();
	private static HashMap<IInteger, BufferedReader> socketReaders = new HashMap<IInteger, BufferedReader>();
	private static IInteger socketCounter = null;	
	private final IValueFactory vf;

	public Sockets(IValueFactory vf) {
		this.vf = vf;
	}
	
	public IInteger createServerSocket(IInteger port) {
		int portNumber = port.intValue();
		try {
			ServerSocket ss = new ServerSocket(portNumber);
			if (socketCounter == null) socketCounter = vf.integer(0);
			socketCounter = socketCounter.add(vf.integer(1));
			serverSockets.put(socketCounter, ss);
			return socketCounter;
		} catch (IOException e) {
			throw RuntimeExceptionFactory.javaException(e, null, null);
		}
	}
	
	public synchronized IInteger createListener(IInteger socketId) {
		ServerSocket ss = serverSockets.get(socketId);
		try {
			Socket cs = ss.accept();
			PrintWriter out = new PrintWriter(cs.getOutputStream(), true);
			BufferedReader in = new BufferedReader(new InputStreamReader(cs.getInputStream()));
			clientSockets.put(socketCounter,  cs);
			socketWriters.put(socketCounter,  out);
			socketReaders.put(socketCounter,  in);
			return socketCounter;
		} catch (IOException e) {
			throw RuntimeExceptionFactory.javaException(e, null, null);
		}
	}
	
	public synchronized void closeListener(IInteger socketId) {
		PrintWriter out = socketWriters.get(socketId);
		BufferedReader in = socketReaders.get(socketId);
		Socket cs = clientSockets.get(socketId);
		
		try {
			out.close();
			in.close();
			cs.close();
		} catch (IOException e) {
			; // do nothing, we are closing them anyway
		}
		
		clientSockets.remove(socketId);
		socketReaders.remove(socketId);
		socketWriters.remove(socketId);
	}
	
	public synchronized void closeServerSocket(IInteger socketId) {
		ServerSocket ss = serverSockets.get(socketId);
		try {
			ss.close();
		} catch (IOException e) {
			; // do nothing, we are closing it anyway
		}
		
		serverSockets.remove(socketId);
	}
	
	public synchronized IString readFrom(IInteger socketId) {
		System.out.println("Java: checking for key on clientSockets...");
		if (!clientSockets.containsKey(socketId)) {
			throw RuntimeExceptionFactory.illegalArgument(socketId, null, null);
		}
		
		try {
			System.out.println("Java: about to read bytes from stream...");
			BufferedReader in;
			if (socketReaders.containsKey(socketId)) {
				in = socketReaders.get(socketId);
			} else {
				throw RuntimeExceptionFactory.illegalArgument(socketId, null, null);
			}
			String line = in.readLine();

			if (line == null) {
				return vf.string("");
			}

			System.out.println("VF:");
			System.out.println(vf);
			System.out.println("Decoder:");
			System.out.println(getDecoder());
			System.out.println("Line:");
			System.out.println(line);

			return vf.string(new String(getDecoder().decode(line.getBytes())));
		} catch (IOException e) {
			throw RuntimeExceptionFactory.javaException(e, null, null);
		} catch (NullPointerException e) {
			e.printStackTrace();
			throw e;
		}
	}
	
	public void writeTo(IInteger socketId, IString msg) {
		if (!clientSockets.containsKey(socketId)) {
			throw RuntimeExceptionFactory.illegalArgument(socketId, null, null);
		}
		
		PrintWriter out = null;
		if (socketWriters.containsKey(socketId)) {
			out = socketWriters.get(socketId);
		} else {
			throw RuntimeExceptionFactory.illegalArgument(socketId, null, null);
		}
		out.println(Base64.getEncoder().encodeToString(msg.getValue().getBytes()));
	}

}