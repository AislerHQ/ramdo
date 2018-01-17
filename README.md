# Ramdo

Fast temporary store powered by RAM disks.

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

## License

Ramdo is Copyright © 2018 by AISLER B.V. It is free software, and may be
redistributed under the terms specified in the license file.

## About AISLER

![AISLER](https://cdn.aisler.net/assets/logo-abba89df5e5998f1ff738bb2a7952e5b47999bc90235994a2c415d00b43d5e36.svg)

Ramdo is developed and funded by AISLER B.V.

Want to build powerful electronic prototypes? Visit us at [AISLER](https://aisler.net)
