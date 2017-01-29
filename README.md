Intrinio API Library and Command Line
==================================================

[![Gem](https://img.shields.io/gem/v/intrinio.svg?style=flat-square)](https://rubygems.org/gems/intrinio)
[![Travis](https://img.shields.io/travis/DannyBen/intrinio.svg?style=flat-square)](https://travis-ci.org/DannyBen/intrinio)
[![Code Climate](https://img.shields.io/codeclimate/github/DannyBen/intrinio.svg?style=flat-square)](https://codeclimate.com/github/DannyBen/intrinio)
[![Gemnasium](https://img.shields.io/gemnasium/DannyBen/intrinio.svg?style=flat-square)](https://gemnasium.com/DannyBen/intrinio)

---

This gem provides both a Ruby library and a command line interface for the 
[Intrinio][1] data service.

---

Install
--------------------------------------------------

```
$ gem install intrinio
```

Or with bundler:

```ruby
gem 'intrinio'
```

Features
--------------------------------------------------

* Easy to use interface.
* Use as a library or through the command line.
* Access any Intrinio endpoint directly.
* Display output in various formats.
* Save output to a file.
* Includes a built in file cache (disabled by default).

Usage
--------------------------------------------------

First, require and initialize with your username and password.

```ruby
require 'intrinio'
intrinio = Intrinio::API.new username: 'me', password: 'secret'
```

Now, you can access any Intrinio endpoint with any optional parameter, like
this:

```ruby
result = intrinio.get "indices", type: 'economic', page_size: 5
```

In addition, for convenience, you can use the first part of the endpoint as
a method name, like this:

```ruby
result = intrinio.indices type: 'economic', page_size: 5
```

By default, you will get a ruby hash in return. If you wish to get the raw
output, you can use the `get!` method:

```ruby
result = intrinio.get! "indices", type: 'economic', page_size: 5 
# => JSON string
```

To save the output directly to a file, use the `save` method:

```ruby
intrinio.save "filename.json", "indices", type: 'economic', page_size: 5
```

Debugging your request and adding "sticky" query parameters that stay with
you for the following requests is also easy:

```ruby
intrinio.debug = true
intrinio.param page_size: 10, order_direction: 'asc'
puts intrinio.historical_data identifier: '$INTDSRUSM193N', item: 'level'
# => "https://api.intrinio.com/historical_data?page_size=10&order_direction=asc&identifier=%24INTDSRUSM193N&item=level

intrinio.param page_size: nil # remove param
```

Command Line
--------------------------------------------------

The command line utility `intrinio` acts in a similar way. To use your 
Intrinio authentication, simply set it in the environment variables 
`INTRINIO_AUTH`:

`$ export INTRINIO_AUTH=username:password`

These commands are available:

`$ intrinio get PATH [PARAMS...]` - print the output.  
`$ intrinio pretty PATH [PARAMS...]` - print a pretty JSON.  
`$ intrinio see PATH [PARAMS...]` - print a colored output.  
`$ intrinio url PATH [PARAMS...]` - show the constructed URL.  
`$ intrinio save FILE PATH [PARAMS...]` - save the output to a file.  

Run `intrinio --help` for more information, or view the [full usage help][2].

Caching
--------------------------------------------------

We are using the [WebCache][3] gem for automatic HTTP caching.
To take the path of least surprises, caching is disabled by default.

You can enable and customize it by either passing options on 
initialization, or by accessing the `WebCache` object directly at 
a later stage.

```ruby
intrinio = Intrinio::API.new username: user, password: pass, 
  use_cache: true

intrinio = Intrinio::API.new username: user, password: pass, 
  use_cache: true, cache_dir: 'tmp'

intrinio = Intrinio::API.new username: user, password: pass, 
  use_cache: true, cache_life: 120

# or 

intrinio = Intrinio::API.new username: user, password: pass
intrinio.cache.enable
intrinio.cache.dir = 'tmp/cache'   # Change cache folder
intrinio.cache.life = 120          # Change cache life to 2 minutes
```

To enable caching for the command line, simply set one or both of 
these environment variables:

```
$ export INTRINIO_CACHE_DIR=cache   # default: 'cache'
$ export INTRINIO_CACHE_LIFE=120    # default: 3600 (1 hour)
$ intrinio get indices
# => This call will be cached
```


[1]: https://www.intrinio.com
[2]: https://github.com/DannyBen/intrinio/blob/master/lib/intrinio/docopt.txt
[3]: https://github.com/DannyBen/webcache
