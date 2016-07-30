require 'spec_helper'

include Ramdo
describe Ramdisk::Factory do
  before(:each) do
    wrapper = Ramdisk::Factory.get
    wrapper.list.each do |disk|
      disk.destroy!
    end
  end


  it 'should check if a ramdisk already exists' do
    wrapper = Ramdisk::Factory.get
    disks = wrapper.list
    expect(disks).to be_an(Array)
    expect(disks.length).to be_a(Integer)
    expect(disks.length).to be(0)
  end

  it 'should check if enough RAM space is free' do
    wrapper = Ramdisk::Factory.get
    expect(wrapper.send(:enough_ram?, '100 MB')).to be_truthy
    expect(wrapper.send(:enough_ram?, '100 GB')).to be_falsey
  end

  it 'should create a new RAM disk and save a file to it', focus: true do
    size = '100 MB'

    wrapper = Ramdisk::Factory.get
    disk = wrapper.create(size)

    expect(disk).to be_an(Ramdisk::Instance)
    expect { IO.write("#{disk.path}/test.bin", IO.read('/dev/urandom', 100000)) }.not_to raise_error
  end

  it 'should remove a RAM disk' do
    wrapper = Ramdisk::Factory.get
    disk = wrapper.create('100 MB')

    count = wrapper.list.length
    expect(disk.destroy!).to be_truthy
    expect(disk.destroy!).to be_falsey # Should not work another time

    expect(wrapper.list.length).to be(count - 1)
  end

  it 'should list all available RAM disks' do
    wrapper = Ramdisk::Factory.get
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
