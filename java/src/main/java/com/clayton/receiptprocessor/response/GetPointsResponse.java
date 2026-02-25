package com.clayton.receiptprocessor.response;

/**
 * The response to send back to the client when retrieving the points total for a given receipt.
 */
public record GetPointsResponse (long points) {}
