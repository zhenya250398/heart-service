package com.example.heart.controller;

import com.example.heart.domain.Heart;
import com.example.heart.repos.HeartRepo;
import org.jcodec.api.awt.AWTSequenceEncoder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import static com.example.heart.FilesActions.copy;
import static com.example.heart.FilesActions.delete;
import static com.example.heart.VideoToFrames.loadVideo;
import static com.example.heart.imagecheck.Resize.resize;

@Controller
public class ProcessingController {
    @Autowired
    private HeartRepo heartRepo;

    @Value("${upload.path}")
    private String uploadPath;

    @GetMapping("/imageProcessing")
    public String imageProcessing(@RequestParam("name") String fileName,@RequestParam("id") int hId, Model model) throws IOException, InterruptedException {
        File uploadDir = new File(uploadPath+"/segmentation/"+fileName);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        else {
            return result(hId,fileName,model,"image-processing");
        }
        copy(uploadPath+"/"+fileName,uploadPath+"/segmentation/"+fileName+"/output.bmp");
        copy(uploadPath+"/segmentation/processing.py",uploadPath+"/segmentation/"+fileName+"/processing.py");

        ProcessBuilder builder = new ProcessBuilder("python", "processing.py");
        builder.directory(new File(uploadPath + "/segmentation/" + fileName + "/"));
        builder.redirectError();
        int newProcess = builder.start().waitFor();

        return result(hId,fileName,model,"image-processing");
    }

    @GetMapping("/imageBrainProcessing")
    public String imageBrainProcessing(@RequestParam("name") String fileName,@RequestParam("id") int hId, Model model) throws IOException, InterruptedException {
        File uploadDir = new File(uploadPath+"/segmentation/"+fileName);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        else {
            return result(hId,fileName,model,"image-processing");
        }
        copy(uploadPath+"/"+fileName,uploadPath+"/segmentation/"+fileName+"/output.bmp");
        copy(uploadPath+"/segmentation/processingBrain.py",uploadPath+"/segmentation/"+fileName+"/processing.py");

        ProcessBuilder builder = new ProcessBuilder("python", "processing.py");
        builder.directory(new File(uploadPath + "/segmentation/" + fileName + "/"));
        builder.redirectError();
        int newProcess = builder.start().waitFor();

        return result(hId,fileName,model,"image-processing");
    }

    @GetMapping("/videoProcessing")
    public String videoProcessing(@RequestParam("name") String fileName,@RequestParam("id") int hId, Model model) throws IOException, InterruptedException {
        File uploadDir = new File(uploadPath+"/segmentation/"+fileName);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        else {
//            return result(hId,fileName,model,"video-processing");
            return "redirect:/main";
        }
        copy(uploadPath+"/segmentation/processing.py",uploadPath+"/segmentation/"+fileName+"/processing.py");

//        return result(hId,fileName,model,"video-processing");
        int frameNumber = loadVideo(fileName,uploadPath);
        delete(new File(uploadPath+"/segmentation/"+fileName+"/processing.py"));
        delete(new File(uploadPath+"/segmentation/"+fileName+"/output.bmp"));
        delete(new File(uploadPath+"/segmentation/"+fileName+"/output.csv"));
        AWTSequenceEncoder encoder = AWTSequenceEncoder.createSequenceEncoder(new File(uploadPath + "/segmentation/"+fileName+"/output.mp4"), 30); // fps
        for (int i=1;i<=frameNumber;i++) {
            BufferedImage inputImage = ImageIO.read(new File(uploadPath+"/segmentation/"+fileName+"/output"+i+".bmp"));
            inputImage = resize(inputImage, 448, 448); //224, 224
            Graphics2D g = (Graphics2D) inputImage.getGraphics();
            g.setColor(Color.BLUE);
            String line = "";
            BufferedReader br = new BufferedReader(new FileReader(uploadPath+"/segmentation/"+fileName+"/output"+i+".csv"));
            while ((line = br.readLine()) != null) {
                String[] str = line.split(",");
                g.drawOval(Integer.parseInt(str[1]), Integer.parseInt(str[0]), 1, 1);
            }
            br.close();
            encoder.encodeImage(inputImage);
        }
        encoder.finish();
        return "redirect:/main";
    }

    private String result(int hId,String fileName,Model model,String type){
        Iterable<Heart> hearts = heartRepo.findById(hId);
        model.addAttribute("hearts", hearts);
        delete(new File(uploadPath+"/segmentation/"+fileName+"/processing.py"));
        return type;
    }

}