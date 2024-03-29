# frozen_string_literal: true

require 'pstore'
require 'yaml/store'
require 'ostruct'

class Inventory
  attr_reader :store

  def initialize(storefile: 'data.yml')
    @store = YAML::Store.new(storefile)
  end

  def self.all
    store = new.store
    store.transaction(true) do # begin read-only transaction
      items = []
      store.roots.each do |data_root_name|
        # NOTE(chaserx): could maybe walk down a path with an item class instead of this, maybe.
        items.push OpenStruct.new(store[data_root_name])
      end
      items
    end
  end

  # TODO(chaserx): might be nice to have this accept an optional block
  def self.any?
    store = new.store
    store.transaction(true) do
      store.roots.any?
    end
  end

  def self.add(item)
    store = new.store
    store.transaction do
      store[item[:location].to_sym] = item
      store.commit
    end
  end

  def self.find_by_location(location)
    all.select { |item| item[:location] == location }
  end

  def self.remove(item)
    store = new.store
    store.transaction do
      store.delete(item[:location].to_sym)
      store.commit
    end
  end

  def self.subtract(location, amount)
    store = new.store
    store.transaction do
      store[location.to_sym][:quantity] -= amount
      store.commit
    end
  end

  def self.update(item)
    store = new.store
    store.transaction(true) do
      return [] if store.roots.none? { |root| root == item[:location].to_sym }
    end

    store.transaction do
      store[item[:location].to_sym] = item
      store.commit
    end

    find_by_location(item[:location]).first
  end

  def self.available?(location)
    find_by_location(location).first.quantity.positive?
  end
end
