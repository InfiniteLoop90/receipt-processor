package com.clayton.receiptprocessor;

import org.springframework.boot.SpringBootVersion;
import org.springframework.core.SpringVersion;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.ZoneId;
import java.time.ZonedDateTime;

/**
 * Dummy controller to render a Thymeleaf template so that I can see something easily in the browser when the
 * application is deployed.
 */
@Controller
public class IndexController {

    @GetMapping("/")
    public String index (Model model) {
        model.addAttribute("currentTimestamp", ZonedDateTime.now(ZoneId.systemDefault()));
        model.addAttribute("springVersion", SpringVersion.getVersion());
        model.addAttribute("springBootVersion", SpringBootVersion.getVersion());
        return "index"; // Returns the name of the HTML template (index.html)
    }
}
