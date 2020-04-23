package com.example.heart.controller;

import com.example.heart.domain.Heart;
import com.example.heart.repos.HeartRepo;
import com.opencsv.CSVReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.FileReader;
import java.io.IOException;

@Controller
public class ProcessingController {
    @Autowired
    private HeartRepo heartRepo;

    @GetMapping("/processing")
    public String registration(@RequestParam("id") int hId, Model model) throws IOException {
        CSVReader reader = new CSVReader(new FileReader("C:/Users/zhenya/uploadImages/output.csv"));
        String[] line;
        while ((line = reader.readNext()) != null) {
            System.out.println(line[0]+","+line[1]);
        }
        Iterable<Heart> hearts = heartRepo.findById(hId);
        model.addAttribute("hearts", hearts);
        return "processing";
    }
}