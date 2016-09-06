# README
API application built with Ruby on Rails for Sensly.

## Branches
* `master` is the branch used by production.
* `dev` is the branch used for development. `master is periodically updated from this.
* Other branches are used to develop new features or fix bugs, before being merged in `dev`.

*To do: use tags for production releases*

## Setup
For production setup, clone [`api-deploy`](https://github.com/matthwdell/api-deploy) and this repository to your home directory on the production server, and follow the instructions in `api-deploy`.

For development setup, see the instructions in [`api-vagrant`](https://github.com/mattdowdell/api-vagrant). Note that running the test suite or rubocop will vary slightly from the below instructions. See the instructions in `api-vagrant` for more details on how to run these commands in your vagrant box.

## Tests
To run the test suite:
```
$ rake test
```

## Rubocop
Rubocop is used to maintain code quality.

To run rubocop:
```
$ rubocop --rails
```

To send the result to `.rubocop_todo.yml`:
```
$ rubocop --rails --auto-gen-config
```

The generated config file can then beworked through and corrected as needed.

To run rubocop with the config in `rubocop_todo.yml`:
```
$ rubocop --rails --config `.rubocop_todo.yml`
