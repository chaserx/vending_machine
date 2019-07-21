# vending machine stats
# ~6 rows
# 4 or 8 columns per row. top 3 rows have 4 for chips size; next rows have 8 for candies

require_relative "inventory"

class VendingMachine
  attr_accessor :state

  def initialize
    @state = "Not Ready"
  end

  def on
    system_check
    run
  end

  def system_check
    true
  end

  def run
    @state = "Ready"
    until input == 'x' do
      prompt_user
      input = gets.chomp.downcase
      if validate_selection(input)
        process_selection(input)
      end
    end
  end

  def prompt_user
    puts "Please Make Your Selection"
  end

  def process_selection(selection, amount=1)
    Inventory.subtract(selection, amount)
  end

  def validate_selection(selection)
    true
  end
end

