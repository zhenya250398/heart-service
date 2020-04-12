package com.example.heart.controller;

import com.example.heart.domain.Role;
import com.example.heart.domain.User;
import com.example.heart.repos.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.Collections;
import java.util.Map;

@Controller
public class ProcessingController {

    @GetMapping("/processing")
    public String registration() {
        return "processing";
    }
}