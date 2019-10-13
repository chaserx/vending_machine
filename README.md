# Vending Machine

A command line vending machine

## Motivation

My friend Amina, [Nirvikalpa108](https://github.com/Nirvikalpa108), was working on a [vending machine app](https://github.com/Nirvikalpa108/vending-machine) to strengthen some TDD skills. I am following along privately for comparitive anatomy reasons. We'll share and compare in a future pairing session. Fun.

## Developing

For your convenience, there's a `bin/setup` script that will install dependencies and generate a `data.yml` file for inventory storage.

## Testing

Run `bundle exec rspec` to run tests. Coverage information will be collected in the `coverage` directory.

Run `bundle exec rubocop` to lint.

Run `bundle exec reek` to run some sniff tests.

## Usage

Run `bin/vending_machine` to start.

Use `Ctrl-c` to quit. Inventory is persisted between runs stored in a data.yml flat file.
