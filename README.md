# frc-child-context-bug
An example to demonstrate a bug with NSFetchedResultsController when targeting saved child contexts

## Usage

Run the unit tests in the iOS simulator. It should fail because the FRC will generate 0 sections, instead of the expected 2.
Comment out the line where we save the child context will fix the FRC's results.
