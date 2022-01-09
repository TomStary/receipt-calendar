# How to run application

First, you need to install docker and docker compose. After that its couple of steps to run application.

In root folder of this repository, run this command `docker-compose up` to start application.

Before first request there needs to be executed two more actions, in second terminal in the same folder run this commands:
- `docker-compose run web rake db:create`
- `docker-compose run web rake db:seed`

And that's all folks!

## Tests

For local testing, there is test file in fixtures folder `test/fixtures/files/receipts.csv`.