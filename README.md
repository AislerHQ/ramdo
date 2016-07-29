# Ramdo

Fast temporary store supported by RAM disks.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ramdo'
```

And then execute:

    $ bundle

## How to use

Acutally quite simple

```ruby
require 'ramdo'
store = Ramdo::Store.new
store.data = 'Some Data'

puts `cat #{store.file}`
# Some Data

puts store.data
# Some Data

```


## Low-level API usage
### Create a new RAM disk

```ruby
require 'ramdo'
wrapper = Ramdo::Ramdisk::Factory.get
disk = wrapper.create('100 mb')

IO.write(disk.path + '/test_file', 'some important data')
```


by Patrick Franken, created through Tamyca FunFriday 29.07.2016