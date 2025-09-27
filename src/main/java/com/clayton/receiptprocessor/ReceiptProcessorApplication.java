package com.clayton.receiptprocessor;

import com.clayton.model.Receipt;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ReceiptProcessorApplication {

    public static final Map<UUID, Receipt> receiptStore = new HashMap<>();

    // Even though Java 25 doesn't need the public modifier
    public static void main(String[] args) {
        SpringApplication.run(ReceiptProcessorApplication.class, args);
    }

}
