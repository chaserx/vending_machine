require_relative 'spec_helper'

describe 'VendingMachine', type: :aruba do
  before do
    setup_aruba
  end

  it "asserts the truth" do
    expect(true).to eq(true)
  end

  it "prompts the user for a selection" do
    run_command('vending_machine')
    expect(last_command_started).to have_output("Please Make Your Selection")
    stop_all_commands
  end

  it "returns the selection after prompt" do
    run_command('vending_machine')
    type("A1")
    stop_all_commands
    expect(last_command_started.output).to include("A1")
  end
end
