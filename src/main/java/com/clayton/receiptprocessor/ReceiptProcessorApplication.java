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

    public static void main(String[] args) {
        SpringApplication.run(ReceiptProcessorApplication.class, args);
    }

}
