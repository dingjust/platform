package com.nbyjy.android.nbyjymodule.algorithm;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.MessageDigest;

public class MD5 {
    public MD5() {
    }

    public static final String getMessageDigest(byte[] bytes) {
        char[] var1 = new char[]{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

        try {
            MessageDigest messageDigest;
            (messageDigest = MessageDigest.getInstance("MD5")).update(bytes);
            int var8;
            char[] var3 = new char[(var8 = (bytes = messageDigest.digest()).length) * 2];
            int var4 = 0;

            for (int i = 0; i < var8; ++i) {
                byte var6 = bytes[i];
                var3[var4++] = var1[var6 >>> 4 & 15];
                var3[var4++] = var1[var6 & 15];
            }

            return new String(var3);
        } catch (Exception var8) {
            return null;
        }
    }

    public static final byte[] getRawDigest(byte[] bytes) {
        try {
            MessageDigest messageDigest;
            (messageDigest = MessageDigest.getInstance("MD5")).update(bytes);
            return messageDigest.digest();
        } catch (Exception var2) {
            return null;
        }
    }

    public static final String getMD5(FileInputStream fileInputStream, int var1, int var2, int var3) {
        if (fileInputStream != null && var1 > 0 && var2 >= 0 && var3 > 0) {
            try {
                if (fileInputStream.skip((long) var2) < (long) var2) {
                    return null;
                } else {
                    MessageDigest var10 = MessageDigest.getInstance("MD5");
                    StringBuilder var4 = new StringBuilder(32);
                    byte[] var9 = new byte[var1];
                    int var6 = 0;

                    int var11;
                    while ((var11 = fileInputStream.read(var9)) != -1 && var6 < var3) {
                        if (var6 + var11 <= var3) {
                            var10.update(var9, 0, var11);
                            var6 += var11;
                        } else {
                            var10.update(var9, 0, var3 - var6);
                            var6 = var3;
                        }
                    }

                    byte[] var8 = var10.digest();

                    for (var1 = 0; var1 < var8.length; ++var1) {
                        var4.append(Integer.toString((var8[var1] & 255) + 256, 16).substring(1));
                    }

                    return var4.toString();
                }
            } catch (Exception var10) {
                return null;
            }
        } else {
            return null;
        }
    }

    public static final String getMD5(FileInputStream fileInputStream, int var1) {
        if (fileInputStream != null && var1 > 0) {
            try {
                MessageDigest var2 = MessageDigest.getInstance("MD5");
                StringBuilder var3 = new StringBuilder(32);
                byte[] var7 = new byte[var1];

                int var8;
                while ((var8 = fileInputStream.read(var7)) != -1) {
                    var2.update(var7, 0, var8);
                }

                byte[] var6 = var2.digest();

                for (var1 = 0; var1 < var6.length; ++var1) {
                    var3.append(Integer.toString((var6[var1] & 255) + 256, 16).substring(1));
                }

                return var3.toString();
            } catch (Exception var7) {
                return null;
            }
        } else {
            return null;
        }
    }

    public static String getMD5(String var0) {
        File var1;
        return var0 == null ? null : ((var1 = new File(var0)).exists() ? getMD5(var1, 102400) : null);
    }

    public static String getMD5(File file) {
        return getMD5(file, 102400);
    }

    public static String getMD5(File file, int var1) {
        if (file != null && var1 > 0 && file.exists()) {
            FileInputStream var2 = null;
            boolean var8 = false;

            String var14;
            label133:
            {
                try {
                    var8 = true;
                    var14 = getMD5(var2 = new FileInputStream(file), (int) ((long) var1 <= file.length() ? (long) var1 : file.length()));
                    var2.close();
                    var8 = false;
                    break label133;
                } catch (Exception var18) {
                    var8 = false;
                } finally {
                    if (var8) {
                        try {
                            if (var2 != null) {
                                var2.close();
                            }
                        } catch (IOException var16) {
                        }
                    }

                }

                try {
                    if (var2 != null) {
                        var2.close();
                    }
                } catch (IOException var15) {
                }

                return null;
            }

            try {
                var2.close();
            } catch (IOException var17) {
            }

            return var14;
        } else {
            return null;
        }
    }

    public static String getMD5(String var0, int var1, int var2) {
        File var3;
        return var0 == null ? null : ((var3 = new File(var0)).exists() ? getMD5(var3, var1, var2) : null);
    }

    public static String getMD5(File file, int var1, int var2) {
        if (file != null && file.exists() && var1 >= 0 && var2 > 0) {
            FileInputStream var3 = null;
            boolean var9 = false;

            String var15;
            label127:
            {
                try {
                    var9 = true;
                    var15 = getMD5(var3 = new FileInputStream(file), 102400, var1, var2);
                    var3.close();
                    var9 = false;
                    break label127;
                } catch (Exception var19) {
                    var9 = false;
                } finally {
                    if (var9) {
                        try {
                            if (var3 != null) {
                                var3.close();
                            }
                        } catch (IOException var16) {
                        }
                    }

                }

                try {
                    if (var3 != null) {
                        var3.close();
                    }
                } catch (IOException var17) {
                }

                return null;
            }

            try {
                var3.close();
            } catch (IOException var18) {
            }

            return var15;
        } else {
            return null;
        }
    }
}
