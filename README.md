## Csvsplitter
The project proposes a solution with an API that receives a file and returns it split into 50 lines each, along with a user interface for easy interaction.<br>
<br>

## Settings
In your terminal, clone the project.
Rename the `.env.example.rb` file to `.env` and replace the database values according to your preference.
Build the application containers and settings:
```sh
docker compose build
```
<br>

## Using the API
In your terminal, after running `docker-compose build`, start the application with:
```sh
docker compose up
```

In Postman, access the url http://localhost:3000/api/v1/import <br>
In **Body**, select **form-data**, set the key `csv_file` and choose the file. (_*The app has a template file in spec/fixtures/files/customer_data_100.csv*_)<br>
Set the key `email` and enter any email address. <br>
Go to http://localhost:3000/letter_opener/ and check if the email has arrived. <br>
When you click **Send**, the following message should appear:
```sh
File received successfully! Please wait for the conversion in the specified email.
```
<br>

To stop the application:
```sh
docker compose down
```
<br>

## Registration of requests
To access the database:
Start the container terminal:
```sh
docker exec -it csvsplitter /bin/bash
```

Once in the container, access the console:
```sh
rails c
```

Within the console it's possible to access the requests by typing the command below:
```sh
ImportData.all
```

To exit the console:
```sh
exit
```

<br>

## Web application
In your terminal, after running `docker-compose build`, start the application with:
```sh
docker compose up
```

- Access the url http://localhost:3000; <br>
- Add any valid email, a csv file and click on "Split csv"; <br>
- In development, go to http://localhost:3000/letter_opener/ and check if the email has arrived; <br>

To stop the application:
```sh
docker compose down
```
<br>

## Email Configuration
This project is also pre-configured to receive emails in production.
To do so, replace the variables below on the `.env` file with your preferred values:

  ```sh
  MAIL_USER = your_delivery_email@email.com
  MAIL_PASSWORD = your_password
  ```

 (*For gmail, you may need to enable two-step verification and use app password as described [here](https://support.google.com/accounts/answer/185833)).


## Tests
Start the container terminal:
```sh
docker exec -it csvsplitter /bin/bash
```

Run the test command:
```sh
rspec
```
<br>
