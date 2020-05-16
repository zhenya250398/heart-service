package com.example.heart.controller;

import com.example.heart.domain.Heart;
import com.example.heart.domain.User;
import com.example.heart.repos.HeartRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
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

import static com.example.heart.FilesActions.delete;
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
        Iterable<Heart> hearts;

        if (filter != null && !filter.isEmpty()) {
            hearts = heartRepo.findByText(filter);
        } else {
            hearts = heartRepo.findAll();
        }

        model.addAttribute("hearts", hearts);
        model.addAttribute("filter", filter);
        return "main";
    }

    @PostMapping("/delete")
    @Transactional
    public String deleteImage(@RequestParam("name") String fileName,@RequestParam("id") int hId) {
        long del = heartRepo.deleteById(hId);
        File inputFile = new File(uploadPath+"/"+fileName);
        File outputFile = new File(uploadPath+"/segmentation/"+fileName);
        if(inputFile!=null) delete(inputFile);
        if(outputFile!=null) delete(outputFile);
        return "redirect:/main";
    }

    @PostMapping("/main/addImage")
    public String addImage(
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
            System.out.println(similarity);
            file.delete();
            if (similarity>=80) {
                inputImage = resize(inputImage, 224, 224);

                File newFile = new File(uploadPath + "/" + resultFilename);
                ImageIO.write(inputImage, "png", newFile);

                heart.setFilename(resultFilename);
                heart.setFiletype("Изображение");
            }
        }
        if(similarity>=80) {
            heartRepo.save(heart);
        }
        Iterable<Heart> hearts = heartRepo.findAll();
        model.put("hearts", hearts);

        return "redirect:/main";
    }

    @PostMapping("/main/addVideo")
    public String addVideo(
            @AuthenticationPrincipal User user,
            @RequestParam String text,
            @RequestParam Map<String, Object> model,
            @RequestParam("file") MultipartFile mFile
    ) throws IOException {
        Heart heart = new Heart(text, user);
        if (mFile != null && !mFile.getOriginalFilename().isEmpty()) {
            File uploadDir = new File(uploadPath);

            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            String uuidFile = UUID.randomUUID().toString();
            String resultFilename = uuidFile + "." + mFile.getOriginalFilename();
            mFile.transferTo(new File(uploadPath + "/" + resultFilename));
            heart.setFilename(resultFilename);
            heart.setFiletype("Видео");
        }
        heartRepo.save(heart);

        Iterable<Heart> hearts = heartRepo.findAll();

        model.put("hearts", hearts);

        return "redirect:/main";
    }
}
