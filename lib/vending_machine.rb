# frozen_string_literal: true

# vending machine stats
# ~6 rows
# 4 or 8 columns per row. top 3 rows have 4 for chips size; next rows have 8 for candies

require_relative 'inventory'
require 'tabulo'

class VendingMachine
  attr_accessor :state

  def initialize
    @state = :not_ready # [:not_ready, :ready, :fault, :vending]
  end

  def on
    system_check
    run
  end

  def run
    @state = 'Ready'
    input = ''
    list_selections
    while @state == :ready
      prompt_user
      input = gets.chomp.downcase
      if valid_selection(input)
        process_selection(input)
      else
        poor_selection(input)
      end
    end
  rescue Interrupt
    shut_down
    exit
  end

  private

  def shut_down
    puts "\nThanks for vending. Bye! 👋"
  end

  def system_check
    @state = :ready
    # this could be something like successfully pulling inventory data, minimum amount in the till, etc
    # could throw to a different state if not successful
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
    puts "\nEnjoy your #{Inventory.find_by_location(selection).first.name} 🍫\n\n"
  end

  def valid_selection(selection)
    # matches a location name like `b1`
    Inventory.all.any? { |item| item.location.to_s == selection }
    # possible:
    # there is available inventory for the selection
    # eventually, compare the amount of money provided with the cost of selection
  end

  def list_selections
    all_items = Inventory.all
    longest_name = all_items.map { |item| item.name.length }.max
    table = Tabulo::Table.new(all_items) do |t|
      t.add_column(:location)
      t.add_column(:name, width: longest_name)
      t.add_column(:price)
      t.add_column(:quantity)
    end
    puts table
  end
end
