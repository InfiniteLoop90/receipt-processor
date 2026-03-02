# Receipt Processor Challenge (Swift + Vapor Implementation)

## What is it?

This is a Swift + Vapor 💧 project created via Vapor project initializer <https://docs.vapor.codes/getting-started/hello-world/>.

## Getting Started

**Note:** All of the following commands are ran from this directory.

### Building and Running Locally

To build the project using the Swift Package Manager, run the following command:

```bash
swift build
```

To run the project and start the server locally, use the following command:

```bash
swift run
```

### Building and Running With Docker

To build the Docker image, run the following command:

```bash
docker build --tag clayton/receipt-processor-swift .
```

To run the Docker image, run the following command:

```bash
docker run --publish 8080:8080 clayton/receipt-processor-swift:latest
```

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
swift test
```

### See more

- [Vapor Website](https://vapor.codes)
- [Vapor Documentation](https://docs.vapor.codes)
- [Vapor GitHub](https://github.com/vapor)
- [Vapor Community](https://github.com/vapor-community)
