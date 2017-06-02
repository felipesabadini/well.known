package br.com.munif.well.known;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;

public class Principal {

    public static void main(String... args) throws IOException {
        System.out.println("Server well.known started");
        int port = args.length > 0 ? Integer.parseInt(args[0]) : 8080;
        InetSocketAddress isa = new InetSocketAddress(port);
        HttpServer server = HttpServer.create(isa, 0);
        server.createContext("/.well-known/acme-challenge", new HttpHandler() {//.well-known/acme-challenge
            @Override
            public void handle(HttpExchange he) throws IOException {
                URI requestURI = he.getRequestURI();
                String arquivo = requestURI.toString().substring(requestURI.toString().lastIndexOf("/"));
                String home = System.getProperty("user.home") + "/gumgafiles/.well-known/acme-challenge/";
                Path path = Paths.get(home + arquivo);

                FileOutputStream fos = new FileOutputStream(home+"/log.txt",true);
                String mensagem="Request from "+he.getRemoteAddress()+" on "+new Date()+"\n";
                fos.write(mensagem.getBytes());
                fos.close();
                
                byte[] data = Files.readAllBytes(path);
                he.sendResponseHeaders(200, data.length);
                OutputStream responseBody = he.getResponseBody();
                responseBody.write(data);
                responseBody.close();
            }
        });
        server.createContext("/shutdown", new HttpHandler() {
            @Override
            public void handle(HttpExchange he) throws IOException {
                URI requestURI = he.getRequestURI();
                byte[] data = "Goodbye".getBytes();
                he.sendResponseHeaders(200, data.length);
                OutputStream responseBody = he.getResponseBody();
                responseBody.write(data);
                responseBody.close();
                server.stop(0);
                System.exit(0);
            }
        });
        server.start();
    }

}
