require 'spec_helper'

include Ramdo
describe Cleaner do
  it 'should clean up all stores' do
    stores = []
    10.times { stores << Store.new }

    Timecop.freeze(Time.local(2100)) do
      stores.each { |store| expect(Dir.exist?(store.dir)).to be_truthy }

      new_store = Store.new
      stores.each { |store| expect(Dir.exist?(store.dir)).to be_falsey }
    end
  end

end
