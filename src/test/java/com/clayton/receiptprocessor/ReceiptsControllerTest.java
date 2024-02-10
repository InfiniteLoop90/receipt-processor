package com.clayton.receiptprocessor;

import com.clayton.model.Item;
import com.clayton.model.Receipt;
import com.clayton.receiptprocessor.response.GetPointsResponse;
import com.clayton.receiptprocessor.response.StoredReceiptResponse;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.Month;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpEntity;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class ReceiptsControllerTest {
    private static final String LOCALHOST_HOST_WITH_PORT_COLON = "http://localhost:";
    private static final String RECEIPTS_PATH = "/receipts";
    private static final String PROCESS_PATH = "/process";
    private static final String POINTS_PATH = "/points";

    @Value(value="${local.server.port}")
    private int port;

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    void postAndResponseOfFirstExampleShouldReturnExpectedPoints () {
        String postURL = createPostReceiptUrl(port);
        Receipt receipt = new Receipt();
        receipt.setRetailer("Target");
        receipt.setPurchaseDate(LocalDate.of(2022, Month.JANUARY, 1));
        receipt.setPurchaseTime(LocalTime.of(13, 1));
        receipt.setItems(
            List.of(new Item(
                "Mountain Dew 12PK",
                    new BigDecimal("6.49")
                ),
                new Item(
                    "Emils Cheese Pizza",
                    new BigDecimal("12.25")
                ),
                new Item(
                    "Knorr Creamy Chicken",
                    new BigDecimal("1.26")
                ),
                new Item(
                    "Doritos Nacho Cheese",
                    new BigDecimal("3.35")
                ),
                new Item(
                    "   Klarbrunn 12-PK 12 FL OZ  ",
                    new BigDecimal("12.00")
                )
            )
        );
        receipt.setTotal(new BigDecimal("35.35"));

        HttpEntity<Receipt> postRequest = new HttpEntity<>(receipt);
        StoredReceiptResponse postResponse = this.restTemplate.postForObject(postURL, postRequest, StoredReceiptResponse.class);
        UUID responseUuid = postResponse.getId();
        assertThat(responseUuid).isNotNull();

        String getURL = createGetReceiptPointsUrl(port, responseUuid);
        GetPointsResponse getResponse = this.restTemplate.getForObject(getURL, GetPointsResponse.class);
        assertThat(getResponse.getPoints()).isEqualTo(28L);
    }

    @Test
    void postAndResponseOfSecondExampleShouldReturnExpectedPoints () {
        String postURL = createPostReceiptUrl(port);
        Receipt receipt = new Receipt();
        receipt.setRetailer("M&M Corner Market");
        receipt.setPurchaseDate(LocalDate.of(2022, Month.MARCH, 20));
        receipt.setPurchaseTime(LocalTime.of(14, 33));
        receipt.setItems(
            List.of(
                new Item(
                    "Gatorade",
                    new BigDecimal("2.25")
                ),
                new Item(
                    "Gatorade",
                    new BigDecimal("2.25")
                ),
                new Item(
                    "Gatorade",
                    new BigDecimal("2.25")
                ),
                new Item(
                    "Gatorade",
                    new BigDecimal("2.25")
                )
            )
        );
        receipt.setTotal(new BigDecimal("9.00"));

        HttpEntity<Receipt> postRequest = new HttpEntity<>(receipt);
        StoredReceiptResponse postResponse = this.restTemplate.postForObject(postURL, postRequest, StoredReceiptResponse.class);
        UUID responseUuid = postResponse.getId();
        assertThat(responseUuid).isNotNull();

        String getURL = createGetReceiptPointsUrl(port, responseUuid);
        GetPointsResponse getResponse = this.restTemplate.getForObject(getURL, GetPointsResponse.class);
        assertThat(getResponse.getPoints()).isEqualTo(109L);
    }

    private String createPostReceiptUrl (int port) {
        return LOCALHOST_HOST_WITH_PORT_COLON + port + RECEIPTS_PATH + PROCESS_PATH;
    }

    private String createGetReceiptPointsUrl (int port, UUID id) {
        return LOCALHOST_HOST_WITH_PORT_COLON + port + RECEIPTS_PATH + "/" + id + POINTS_PATH;
    }


}
