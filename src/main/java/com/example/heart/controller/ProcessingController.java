package com.example.heart.controller;

import com.example.heart.domain.Heart;
import com.example.heart.repos.HeartRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.File;
import java.io.IOException;

import static com.example.heart.FilesActions.copy;
import static com.example.heart.FilesActions.delete;
import static com.example.heart.VideoToFrames.loadVideo;

@Controller
public class ProcessingController {
    @Autowired
    private HeartRepo heartRepo;

    @Value("${upload.path}")
    private String uploadPath;

    @GetMapping("/processing")
    public String registration(@RequestParam("name") String fileName,@RequestParam("id") int hId, Model model) throws IOException, InterruptedException {
        loadVideo();
        File uploadDir = new File(uploadPath+"/segmentation/"+fileName);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        else {
            return result(hId,fileName,model);
        }
        copy(uploadPath+"/"+fileName,uploadPath+"/segmentation/"+fileName+"/output.bmp");
        copy(uploadPath+"/segmentation/processing.py",uploadPath+"/segmentation/"+fileName+"/processing.py");

        ProcessBuilder builder = new ProcessBuilder("python", "processing.py");
        builder.directory(new File(uploadPath + "/segmentation/" + fileName + "/"));
        builder.redirectError();
        int newProcess = builder.start().waitFor();

        return result(hId,fileName,model);
    }

    private String result(int hId,String fileName,Model model){
        Iterable<Heart> hearts = heartRepo.findById(hId);
        model.addAttribute("hearts", hearts);
        delete(new File(uploadPath+"/segmentation/"+fileName+"/processing.py"));
        return "processing";
    }

}