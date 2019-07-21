require "pstore"
require "yaml/store"
require 'ostruct'

class Inventory
  def self.all
    store = YAML::Store.new("data.yml")
    store.transaction(true) do  # begin read-only transaction
      items = []
      store.roots.each do |data_root_name|
        items.push OpenStruct.new(store[data_root_name])
      end
      items
    end
  end

  def self.add(item)
    store = YAML::Store.new("data.yml")
    store.transaction do
      store[item[:location].to_sym] = item
      store.commit
    end
  end

  def self.find_by_location(location)
    self.class.all.select{ |item| item[:location] == location }
  end

  def self.remove(item)
    store = YAML::Store.new("data.yml")
    store.transaction do
      store.delete(item[:location].to_sym)
      store.commit
    end
  end

  def self.update(item)
    store = YAML::Store.new("data.yml")
    store.transaction do
      if store[item[:location]]
        store[item[:location].to_sym] = item
        store.commit
      else
        store.abort
        puts "Item not found"
      end
    end
  end

  def self.available?(location)
    Inventory.all.select { |a| a[:location] == location }.first.fetch(:quantity) > 0
  end
end

