package com.clayton.receiptprocessor.response;

import java.util.Objects;
import java.util.UUID;

/**
 * The response to send back to the client when storing a new receipt.
 */
public class StoredReceiptResponse {

    private UUID id;

    public UUID getId () {
        return id;
    }

    public void setId (UUID id) {
        this.id = id;
    }

    /**
     * Creates a new {@code StoredReceiptResponse} instance with the given ID.
     * @param id the id
     * @return the response object
     */
    public static StoredReceiptResponse of (UUID id) {
        Objects.requireNonNull(id);
        StoredReceiptResponse response = new StoredReceiptResponse();
        response.setId(id);
        return response;
    }
}
