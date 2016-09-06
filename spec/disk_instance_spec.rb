require 'spec_helper'

include Ramdo
describe DiskInstance do
  before(:each) do
    DiskInstance.list.each do |disk|
      disk.destroy!
    end
  end


  it 'should check if a ramdisk already exists' do
    disks = DiskInstance.list
    expect(disks).to be_an(Array)
    expect(disks.length).to be_a(Integer)
    expect(disks.length).to be(0)
  end

  it 'should create a new disk and save a file to it' do
    disk = DiskInstance.create

    expect(disk).to be_an(DiskInstance)
    expect { IO.write("#{disk.path}/test.bin", IO.read('/dev/urandom', 100000)) }.not_to raise_error
  end

  it 'should remove a RAM disk' do
    disk = DiskInstance.create

    count = DiskInstance.list.length
    expect(disk.destroy!).to be_truthy
    expect(disk.destroy!).to be_falsey # Should not work another time

    expect(DiskInstance.list.length).to be(count - 1)
  end

  it 'should list all available disks' do
    disk = DiskInstance.create

    list = DiskInstance.list
    expect(list.length).to eq(1)
    expect(Dir.exist?(list.first.path)).to be_truthy

    disk = DiskInstance.create

    list = DiskInstance.list
    expect(list.length).to eq(2)
    expect(Dir.exist?(list.last.path)).to be_truthy

  end

end
