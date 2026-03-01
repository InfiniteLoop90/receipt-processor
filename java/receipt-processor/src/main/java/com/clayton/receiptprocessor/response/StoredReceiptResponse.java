package com.clayton.receiptprocessor.response;

import java.util.UUID;

/**
 * The response to send back to the client when storing a new receipt.
 */
public record StoredReceiptResponse(UUID id) {}
