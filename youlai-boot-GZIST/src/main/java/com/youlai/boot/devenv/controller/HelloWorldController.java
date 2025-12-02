package com.youlai.boot.devenv.controller;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/shopping")
public class HelloWorldController {
//    @GetMapping(value = "/hello")
    @RequestMapping(value = "/hello", method = RequestMethod.GET)
    public String SayHi(){
        return "Hi, the new world.";
    }
}
