# Receipt Processor Challenge (Java + Spring Boot Implementation)

## What is it?

This is a Java + Spring Boot project created via <https://start.spring.io/> with Spring Web and took some steps from
<https://spring.io/guides/topicals/spring-boot-docker/> and from <https://stackoverflow.com/a/27768965> for the
Dockerfile creation.

## Getting Started

### Building and Running Locally

Run the following to build it and run automated tests:

```bash
mvn clean install
```

o run the project and start the server locally, use the following command:

```bash
mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8080"
```

### Building and Running With Docker

1. Have [Docker](https://www.docker.com/) installed.
2. Clone this repo and navigate to this directory.
3. Run `docker build --tag clayton/receipt-processor-java .` to build the image.
4. Run `docker run --publish 8080:8080 clayton/receipt-processor-java:latest` to run the image.

### Testing Manually with Postman

Go to Postman and try to interact with it, e.g.:
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
* `GET` to `http://localhost:8080/receipts/:id/points` (Setting the `:id` path parm with the ID of a receipt returned from the
  `POST` response above)

### Running Automated Tests

To execute tests, use the following command:

```bash
mvn test
```
