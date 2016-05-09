package org.heysec.exp;

/**
 * Created by lenovo on 2016/5/27.
 */

import java.io.FileInputStream;
import java.util.Arrays;

public class Utils {
    public Utils() {
    }

    public static byte[] hexStringToBytes(String hexString) {
        if(hexString != null && !hexString.equals("")) {
            hexString = hexString.toUpperCase();
            int length = hexString.length() / 2;
            char[] hexChars = hexString.toCharArray();
            byte[] d = new byte[length];

            for(int i = 0; i < length; ++i) {
                int pos = i * 2;
                d[i] = (byte)(charToByte(hexChars[pos]) << 4 | charToByte(hexChars[pos + 1]));
            }

            return d;
        } else {
            return null;
        }
    }

    private static byte charToByte(char c) {
        return (byte)"0123456789ABCDEF".indexOf(c);
    }

    public static byte[] byteMerger(byte[] byte_1, byte[] byte_2) {
        byte[] byte_3 = new byte[byte_1.length + byte_2.length];
        System.arraycopy(byte_1, 0, byte_3, 0, byte_1.length);
        System.arraycopy(byte_2, 0, byte_3, byte_1.length, byte_2.length);
        return byte_3;
    }

    public static byte[] GetByteByFile(String FilePath) throws Exception {
        FileInputStream fi = new FileInputStream(FilePath);
        byte[] temp = new byte[50000000];
        boolean length = true;
        int length1 = fi.read(temp);
        byte[] file = Arrays.copyOfRange(temp, 0, length1);
        fi.close();
        Object temp1 = null;
        return file;
    }
}
