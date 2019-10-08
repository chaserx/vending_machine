# frozen_string_literal: true

# vending machine stats
# ~6 rows
# 4 or 8 columns per row. top 3 rows have 4 for chips size; next rows have 8 for candies

require_relative 'inventory'
require 'tabulo'

class VendingMachine
  attr_accessor :state

  def initialize
    @state = 'Not Ready' # ['Not Ready', 'Ready', 'Fault', 'Vending']
  end

  def on
    system_check
    run
  end

  def system_check
    true
    # this could be something like successfully pulling inventory data, minimum amount in the till, etc
    # could throw to a different state if not successful
  end

  def run
    @state = 'Ready'
    input = ''
    list_selections
    until input == 'x'
      prompt_user
      input = gets.chomp.downcase
      if validate_selection(input)
        process_selection(input)
      else
        poor_selection(input)
      end
    end
  end

  def prompt_user
    puts 'Please Make Your Selection:'
  end

  def poor_selection(selection)
    puts "Um. Your selection of #{selection} appears to be invalid."
  end

  def parrot_selection(selection)
    puts "You chose #{selection}. Nice choice. One moment."
  end

  def process_selection(selection, amount = 1)
    parrot_selection(selection)
    Inventory.subtract(selection, amount)
  end

  def validate_selection(selection)
    # matches a location name like `b1`
    Inventory.all.any? { |item| item.location.to_s == selection }
    # possible:
    # there is available inventory for the selection
    # eventually, compare the amount of money provided with the cost of selection
  end

  def list_selections
    max_width = Inventory.all.map { |item| item.name.length }.max
    table = Tabulo::Table.new(Inventory.all) do |t|
      t.add_column(:location)
      t.add_column(:name, width: max_width)
      t.add_column(:price)
      t.add_column(:quantity)
    end
    puts table
  end
end
