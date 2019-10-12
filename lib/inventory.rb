# frozen_string_literal: true

require 'pstore'
require 'yaml/store'
require 'ostruct'
require 'dotenv/load'

class Inventory
  STOREFILE = ENV.fetch('STOREFILE', 'data.yml')

  def self.all
    store = YAML::Store.new(STOREFILE)
    store.transaction(true) do # begin read-only transaction
      items = []
      store.roots.each do |data_root_name|
        items.push OpenStruct.new(store[data_root_name])
      end
      items
    end
  end

  def self.any?
    store = YAML::Store.new(STOREFILE)
    store.transaction(true) do
      store.roots.any?
    end
  end

  def self.add(item)
    store = YAML::Store.new(STOREFILE)
    store.transaction do
      store[item[:location].to_sym] = item
      store.commit
    end
  end

  def self.find_by_location(location)
    all.select { |item| item[:location] == location }
  end

  def self.remove(item)
    store = YAML::Store.new(STOREFILE)
    store.transaction do
      store.delete(item[:location].to_sym)
      store.commit
    end
  end

  def self.subtract(location, amount)
    store = YAML::Store.new(STOREFILE)
    store.transaction do
      store[location.to_sym][:quantity] -= amount
      store.commit
    end
  end

  def self.update(item)
    store = YAML::Store.new(STOREFILE)
    store.transaction do
      if store[item[:location]]
        store[item[:location].to_sym] = item
        store.commit
      else
        store.abort
        puts 'Item not found'
      end
    end
  end

  def self.available?(location)
    all.select { |item| item[:location] == location }.first.fetch(:quantity).positive?
  end
end
