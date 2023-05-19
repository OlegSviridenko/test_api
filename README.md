For build

````docker-compose build````

For run application (db creation and migrations automated)

````docker-compose up````

by default starting on http://localhost:3000/

To run tests

````docker-compose run -e "RAILS_ENV=test" web bundle exec rspec spec````

