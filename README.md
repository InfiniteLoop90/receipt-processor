# Receipt Processor Challenge

## What is it?

This is a Spring Boot project created via <https://start.spring.io/> with Spring Web and took some steps from
<https://spring.io/guides/topicals/spring-boot-docker/> for the Docker file creation to try out the Fetch
coding challenge [here](https://github.com/fetch-rewards/receipt-processor-challenge).

## Getting Started

1. Have Java 17 installed. This README assumes Java 17 is your default Java for simplicity.
2. Have [Maven](https://maven.apache.org/) installed.
3. Have [Docker](https://www.docker.com/) installed.
4. Clone this repo.
5. Run `mvn clean package`
6. Run `docker build -t clayton/receipt-processor .`
7. Run `docker run -p 8080:8080 clayton/receipt-processor`
8. Go to Postman and try to interact with it, e.g.:
   * `POST` to `http://localhost:8080/receipts/process` with a body like:
      ```json
      {
        "retailer": "M&M Corner Market",
        "purchaseDate": "2022-03-20",
        "purchaseTime": "14:33",
        "items": [
          {
            "shortDescription": "Gatorade",
            "price": "2.25"
          },{
            "shortDescription": "Gatorade",
            "price": "2.25"
          },{
            "shortDescription": "Gatorade",
            "price": "2.25"
          },{
            "shortDescription": "Gatorade",
            "price": "2.25"
          }
        ],
        "total": "9.00"
      }
      ```
     and note the `id` in the JSON response.
  * `GET` to `http://localhost:8080/receipts/{id}/points` (Replacing `{id}` with the ID of a receipt returned from the
    `POST` response above)
