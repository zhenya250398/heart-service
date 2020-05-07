package com.example.heart;

import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;

public class FilesActions {
    public static void delete(File file)
    {
        if(!file.exists())
            return;
        if(file.isDirectory())
        {
            for(File f : file.listFiles())
                delete(f);
            file.delete();
        }
        else
        {
            file.delete();
        }
    }
    public static void copy(String original,String copied) throws IOException {
        File file1 = new File(original);
        File file2 = new File(copied);
        FileUtils.copyFile(file1, file2);
    }
}
