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

Ramdo is Copyright © 2017 by AISLER B.V. It is free software, and may be
redistributed under the terms specified in the license file.

## About AISLER

![AISLER](https://cdn-2.aisler.net/assets/logo_invert_orange-7ca49b7abecdf2f857639df2c0de142889a9dc23d33af4b9f875db54c0bc417e.png)

Ramdo is developed and funded by AISLER B.V.

Looking for industry quality and affordable PCBs, visit us at [AISLER GO](https://go.aisler.net)
