# Parking Lot

## How to run ?

- Run bin/setup.
- Run bin/parking_lot text.txt or bin/parking_lot (Type in commands).

## Directory Structure

- Bin - Contains executables.
    * driver - driver program called from parking_lot.
    * parking_lot - starting the program. This accepts a file or can be given set of commands.
    * require_tree - require various classes in this project.
    * run_tests - runs test cases using rspec.
    * setup - sets up your local machine.
- Models - Data models for persisting data in memory and defines relationships between them.
- Services - Business Logic class responsible for doing one activity.
    * CommandParserService - responsible for parsing commands from input, fetching args and sending it for processing.
    * CommandValidatorService - responsible for validating commands and their arguments.
    * IndexingService - responsible for adding in memory hash tables for lookup on data. This can be generalized with ruby meta programming.
    * ParkingService - responsible for holding the main logic and acting as an interface for accessing models.
    * OutputformatterService - responsible for formatting outputs.
- Specs - Holds the test cases.
- Errors - Defines the errors. There's errors which are raised for invalid commands and parking lot errors is raised for parking lot business logic.
- Gemfile - Defines external libraries which are required. This project requires rspec for running tests and pry/pry-nav for debugging.
- Gemfile.lock - locked versions of external libraries.
- .ruby-version - Required ruby version.
- README.md - README file.

## What does setup do ?

bin/setup will install following things on your laptop:

- rvm - Ruby version manager.
- Ruby 2.7.0.
- bundler gem for Gemfile.

## More enhancements.

- Move Autoincrement into one class/module and make it extensible. A counter has to be defined as class level variable.
- Add repository pattern for persisting memory. PersistenceService will hold data instead of individual models. 
This will allow passing the ids between related models. Models can use ID and class name to get data from PersistenceService.
 
