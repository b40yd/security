package org.secdomain.exp;
import java.rmi.Remote;

public interface RemoteObject extends Remote {
    boolean upload(String var1, byte[] var2, boolean var3);

    String exec(String var1);

    void unbind(String var1);
}