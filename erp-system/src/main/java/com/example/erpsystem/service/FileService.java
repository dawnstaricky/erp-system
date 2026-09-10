package com.example.erpsystem.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class FileService {
    @Value("${file.upload.expense}")
    private String uploadDir;

    /**
     * 上传多个文件，返回逗号分隔的URL
     */
    public String uploadFiles(List<MultipartFile> files) throws IOException {
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        List<String> urlList = new ArrayList<>();
        for (MultipartFile file : files) {
            if (file.isEmpty()) continue;
            String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();
            File dest = new File(uploadDir + fileName);
            file.transferTo(dest);
            urlList.add("/uploads/expense/" + fileName);
        }
        return String.join(",", urlList);
    }

    /**
     * 获取文件用于预览
     */
    public File getFileByUrl(String url) {
        String fileName = url.substring(url.lastIndexOf("/") + 1);
        return new File(uploadDir + fileName);
    }
}