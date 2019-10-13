require_relative '../lib/inventory'

RSpec.describe Inventory do
  describe 'any?' do
    context 'with complete storefile' do
      it 'returns true' do
        @inventory = Inventory.new(storefile: File.expand_path('spec/support/test-data.yml'))
        allow(Inventory).to receive(:new).and_return(@inventory)
        expect(described_class.any?).to be true
      end
    end

    context 'with empty storefile' do
      it 'returns false' do
        @inventory = Inventory.new(storefile: File.expand_path('spec/support/bad-data.yml'))
        allow(Inventory).to receive(:new).and_return(@inventory)
        expect(described_class.any?).to be false
      end
    end
  end

  describe 'all' do
    it 'returns an array' do
      @inventory = Inventory.new(storefile: File.expand_path('spec/support/test-data.yml'))
      allow(Inventory).to receive(:new).and_return(@inventory)
      expect(described_class.all.class).to eq(Array)
    end
  end

  describe 'find by location' do
    it 'returns an array' do
      @inventory = Inventory.new(storefile: File.expand_path('spec/support/test-data.yml'))
      allow(Inventory).to receive(:new).and_return(@inventory)
      expect(described_class.find_by_location('b1').class).to eq(Array)
    end

    it 'returns an array with an OpenStruct' do
      @inventory = Inventory.new(storefile: File.expand_path('spec/support/test-data.yml'))
      allow(Inventory).to receive(:new).and_return(@inventory)
      expect(described_class.find_by_location('b1').first.class).to eq(OpenStruct)
    end
  end

  describe 'available?' do
    context 'with sufficient quantity' do
      it 'returns true' do
        @inventory = Inventory.new(storefile: File.expand_path('spec/support/test-data.yml'))
        allow(Inventory).to receive(:new).and_return(@inventory)
        expect(described_class.available?('b1')).to be true
      end
    end

    context 'with insufficient quantity' do
      it 'returns false' do
        @inventory = Inventory.new(storefile: File.expand_path('spec/support/test-data.yml'))
        allow(Inventory).to receive(:new).and_return(@inventory)
        expect(described_class.available?('c8')).to be false
      end
    end
  end

  describe 'subtract' do
    it 'updates the quanity of an item by 1' do
      @inventory = Inventory.new(storefile: File.expand_path('spec/support/test-data.yml'))
      allow(Inventory).to receive(:new).and_return(@inventory)
      # rubocop:disable Lint/AmbiguousBlockAssociation
      expect { described_class.subtract('b1', 1) }.to change { described_class.find_by_location('b1').first.quantity }
      # rubocop:enable Lint/AmbiguousBlockAssociation
    end
  end
end
