package com.clayton.receiptprocessor;

import com.clayton.model.Receipt;
import com.clayton.receiptprocessor.response.GetPointsResponse;
import com.clayton.receiptprocessor.response.StoredReceiptResponse;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

/**
 * Controller for processing receipts.
 */
@RestController
@RequestMapping("/receipts")
public class ReceiptsController {

    /**
     * Consumes a receipt and stores it.
     * @param receipt the receipt
     * @return a response containing the new ID of the receipt
     */
    @PostMapping("/process")
    public StoredReceiptResponse storeReceipt (@RequestBody Receipt receipt) {
        if (receipt == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Receipt must not be null");
        }

        UUID newId = UUID.randomUUID();
        ReceiptProcessorApplication.receiptStore.put(newId, receipt);
        return StoredReceiptResponse.of(newId);
    }

    /**
     * Gets the total number of points for the given receipt based on the ID of the receipt.
     * @param id the id of the receipt
     * @return the number of points for the receipt
     */
    @GetMapping("/{id}/points")
    public GetPointsResponse getPoints (@PathVariable UUID id) {
        Receipt receipt = ReceiptProcessorApplication.receiptStore.get(id);
        if (receipt == null) {
            throw new ResponseStatusException(
                HttpStatus.NOT_FOUND,
                String.format("Receipt with ID %s does not exist", id.toString())
            );
        }
        return GetPointsResponse.of(receipt.getPoints());
    }
}
