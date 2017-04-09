*If you've never used OpeningAct before, this README will describe the what is contained in your project directory. If you've already used OpeningAct before, you can delete all the text in this file*

# Welcome to OpeningAct

Your project is ready for development! However, there are a few things to point out:

## Configuration

* Please read over the `environment.rb` file and complete Application Name and Author Name sections with the appropriate information. This file houses all our dependencies.
* OpeningAct does not have database support yet, so set up your database and models in the `lib` folder.
* A placeholder homepage has been created for you. Run `heroku local web` if you wish to see it. Otherwise, please replace it with your own.

## Testing

All your tests are housed in either the `test` or `spec` folders, depending on the test framework you specified.

Some failing tests have been created for you. To run the tests:


`bundle exec rake test`

OR

`bundle exec rake spec`
