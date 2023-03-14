package com.clayton.receiptprocessor.response;

/**
 * The response to send back to the client when retrieving the points total for a given receipt.
 */
public class GetPointsResponse {
    private long points;

    public long getPoints () {
        return points;
    }

    public void setPoints (long points) {
        this.points = points;
    }

    /**
     * Creates a new {@code GetPointsResponse} instance with the given points amount.
     * @param points the points
     * @return the response object
     */
    public static GetPointsResponse of (long points) {
        GetPointsResponse response = new GetPointsResponse();
        response.setPoints(points);
        return response;
    }
}
