require 'spec_helper'

include Ramdo
describe Ramdisk::Factory do

  it 'should receive wrapper for the current OS' do
    wrapper = Ramdisk::Factory.get

    if RUBY_PLATFORM =~ /linux/
      expect(wrapper).to be_a(Ramdisk::LinuxWrapper)
    elsif RUBY_PLATFORM =~ /darwin/
      expect(wrapper).to be_a(Ramdisk::DarwinWrapper)
    end
  end

end
