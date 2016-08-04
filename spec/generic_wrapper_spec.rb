require 'spec_helper'

include Ramdo
describe Ramdisk::GenericWrapper do
  before(:each) do
    wrapper = Ramdisk::GenericWrapper.new
    wrapper.list.each do |disk|
      disk.destroy!
    end
  end


  it 'should check if a ramdisk already exists' do
    wrapper = Ramdisk::GenericWrapper.new
    disks = wrapper.list
    expect(disks).to be_an(Array)
    expect(disks.length).to be_a(Integer)
    expect(disks.length).to be(0)
  end

  it 'should create a new disk and save a file to it' do
    size = '100 MB'

    wrapper = Ramdisk::GenericWrapper.new
    disk = wrapper.create(size)

    expect(disk).to be_an(Ramdisk::Instance)
    expect { IO.write("#{disk.path}/test.bin", IO.read('/dev/urandom', 100000)) }.not_to raise_error
  end

  it 'should remove a RAM disk' do
    wrapper = Ramdisk::GenericWrapper.new
    disk = wrapper.create('100 MB')

    count = wrapper.list.length
    expect(disk.destroy!).to be_truthy
    expect(disk.destroy!).to be_falsey # Should not work another time

    expect(wrapper.list.length).to be(count - 1)
  end

  it 'should list all available RAM disks' do
    wrapper = Ramdisk::GenericWrapper.new
    disk = wrapper.create('100 MB')

    list = wrapper.list
    expect(list.length).to eq(1)
    expect(list.first.device).not_to be_empty
    expect(File.exist?(list.first.device)).to be_truthy
    expect(Dir.exist?(list.first.path)).to be_truthy

    disk = wrapper.create('200 MB')

    list = wrapper.list
    expect(list.length).to eq(2)
    expect(list.last.device).not_to be_empty
    expect(File.exist?(list.last.device)).to be_truthy
    expect(Dir.exist?(list.last.path)).to be_truthy

  end

end
