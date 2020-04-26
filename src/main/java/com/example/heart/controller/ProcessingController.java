package com.example.heart.controller;

import com.example.heart.domain.Heart;
import com.example.heart.repos.HeartRepo;
import com.opencsv.CSVReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;

@Controller
public class ProcessingController {
    @Autowired
    private HeartRepo heartRepo;
    
    @GetMapping("/processing")
    public String processing(@RequestParam("id") int hId, Model model) throws IOException {
//        CSVReader reader = new CSVReader(new FileReader("C:/Users/Home/uploadImages/output.csv"));
//        String[] line;
//        while ((line = reader.readNext()) != null) {
//            System.out.println(line[0]+","+line[1]);
//        }
        Iterable<Heart> hearts = heartRepo.findById(hId);
        model.addAttribute("hearts", hearts);
        return "processing";
    }

//    @GetMapping("/output.csv")
//    public String output(Model model) throws IOException {
//        CSVReader reader = new CSVReader(new FileReader("C:/Users/zhenya/uploadImages/segmentation/4db4b8a3-0bc9-4fcc-a58a-1956958c0dc8.1.bmp/output.csv"));
//        File file = new File("C:/Users/zhenya/uploadImages/segmentation/4db4b8a3-0bc9-4fcc-a58a-1956958c0dc8.1.bmp/output.csv");
//        String[] line;
//        while ((line = reader.readNext()) != null) {
//            System.out.println(line[0]+","+line[1]);
//        }
//        model.addAttribute("reader",file);
//        return "processing";
//    }
}