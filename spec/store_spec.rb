require 'spec_helper'

include Ramdo
describe Store do
  after(:all) do
    DiskInstance.list.each do |disk|
      disk.destroy!
    end
  end

  it 'should create a new store and append data to it' do
    test_data = 'make me sexy'

    store = Store.new
    store.data = test_data

    expect(IO.read(store.file)).to eq(test_data)
    expect(store.data).to eq(test_data)
  end

  it 'should create a new store with a specific file extension' do
    extension = '.bin'

    store = Store.new(extension: extension)
    expect(File.extname(store.file)).to eq(extension)
  end

  it 'should create a new store with data' do
    test_data = 'make me sexy'

    store = Store.new(data: test_data)
    expect(IO.read(store.file)).to eq(test_data)
  end

  it 'should create a new store and write data to it' do
    test_data = 'make me sexy'

    store = Store.new
    IO.write(store.file, test_data)

    expect(IO.read(store.file)).to eq(test_data)
    expect(store.data).to eq(test_data)
  end

  it 'should be able to truncate any data' do
    store = Store.new
    store.data = 'Test'
    store.truncate
    expect(File.exist?(store.file)).to be_falsey
    expect(Dir.exist?(store.dir)).to be_falsey
  end

  it 'should use existing RAM disk if available' do
    DiskInstance.list.each { |disk| disk.destroy! }
    expect(DiskInstance.list.length).to eq(0)
    store_1 = Store.new
    expect(DiskInstance.list.length).to eq(1)
    store_2 = Store.new
    expect(DiskInstance.list.length).to eq(1)
  end

  it 'should allow to define a specific file extension' do
    store = Store.new(extension: 'png')
    store.data = 'make me sexy'
    expect(File.extname(store.file)).to eq('.png')

    store = Store.new(extension: '.png')
    store.data = 'make me sexy'
    expect(File.extname(store.file)).to eq('.png')
  end
end
