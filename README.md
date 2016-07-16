# Ridgepole-rails

Ridgepole-rails provides two Rake tasks: `ridgepole:export` and `ridgepole:apply`
They wrap `[ridgepole](https://github.com/winebarrel/ridgepole)`'s `ridgepole --export` and
`ridgepole --apply` respectively.

## Usage

To export current schema of the database to Schemafile

    rake ridgepole:export

To apply Schemafile to the database

    rake ridgepole:apply

Some db tasks of Rails are replaced as follows:

* `db:migrate` invokes `ridgepole:apply` then `ridgepole:export`
* `db:schema:dump` invokes `ridgepole:export`
* `db:schema:load` invokes `ridgepole:apply`
* `db:test:load` invokes `ridgepole:apply` with first argument: `test`
* `db:migrate:status`, `db:rollback` and `db:version` are undefined

TODO: Some means not to replace these tasks above.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'ridgepole-rails'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install ridgepole-rails
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
