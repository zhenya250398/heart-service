package com.example.heart.controller;

import com.example.heart.domain.Heart;
import com.example.heart.domain.User;
import com.example.heart.repos.HeartRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.UUID;

import static com.example.heart.imagecheck.ImageCheck.compare;
import static com.example.heart.imagecheck.Resize.convert;
import static com.example.heart.imagecheck.Resize.resize;

@Controller
public class MainController {
    @Autowired
    private HeartRepo heartRepo;

    @Value("${upload.path}")
    private String uploadPath;

    @GetMapping("/")
    public String greeting(Map<String, Object> model) {
        return "greeting";
    }

    @GetMapping("/main")
    public String main(@RequestParam(required = false, defaultValue = "") String filter, Model model) {
        Iterable<Heart> hearts = heartRepo.findAll();

        if (filter != null && !filter.isEmpty()) {
            hearts = heartRepo.findByText(filter);
        } else {
            hearts = heartRepo.findAll();
        }

        model.addAttribute("hearts", hearts);
        model.addAttribute("filter", filter);

        return "main";
    }

    @PostMapping("/main")
    public String add(
            @AuthenticationPrincipal User user,
            @RequestParam String text,
            @RequestParam Map<String, Object> model,
            @RequestParam("file") MultipartFile mFile
    ) throws IOException {
        Heart heart = new Heart(text, user);
        int similarity = 0;

        if (mFile != null && !mFile.getOriginalFilename().isEmpty()) {
            File uploadDir = new File(uploadPath);

            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            String uuidFile = UUID.randomUUID().toString();
            String resultFilename = uuidFile + "." + mFile.getOriginalFilename();
            File file = convert(mFile,resultFilename);
            BufferedImage inputImage = ImageIO.read(file);
            similarity = compare(file);
            file.delete();
            if (similarity>=50) {
                inputImage = resize(inputImage, 224, 224);

                File newFile = new File(uploadPath + "/" + resultFilename);
                ImageIO.write(inputImage, "png", newFile);

                heart.setFilename(resultFilename);
            }
        }
        if(similarity>=50) {
            heartRepo.save(heart);
        }
        Iterable<Heart> hearts = heartRepo.findAll();

        model.put("hearts", hearts);

        return "main";
    }
}
