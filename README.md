Intrinio API Library and Command Line
==================================================

[![Gem](https://img.shields.io/gem/v/intrinio.svg?style=flat-square)](https://rubygems.org/gems/intrinio)
[![Build](https://img.shields.io/travis/DannyBen/intrinio/master.svg?style=flat-square)](https://travis-ci.org/DannyBen/intrinio)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/DannyBen/intrinio.svg?style=flat-square)](https://codeclimate.com/github/DannyBen/intrinio)
[![Issues](https://img.shields.io/codeclimate/issues/github/DannyBen/intrinio.svg?style=flat-square)](https://codeclimate.com/github/DannyBen/intrinio)
[![Dependencies](https://img.shields.io/gemnasium/DannyBen/intrinio.svg?style=flat-square)](https://gemnasium.com/DannyBen/intrinio)

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
* Access any Intrinio endpoint and option directly.
* Display output as JSON or CSV.
* Save output to a file as JSON or CSV.
* Includes a built in file cache (disabled by default).


Usage
--------------------------------------------------

First, require and initialize with your username and password.

```ruby
require 'intrinio'
intrinio = Intrinio::API.new username: 'me', password: 'secret'
# or: Intrinio::API.new auth: 'me:secret'
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

In other words, these calls are the same:

```ruby
intrinio.get 'endpoint', param: value
intrinio.endpoint, param: value
```

as well as these two:

```ruby
intrinio.get 'endpoint/sub', param: value
intrinio.endpoint 'sub', param: value
```

By default, you will get a ruby hash in return. If you wish to have more 
control over the response, use the `get!` method instead:

```ruby
result = intrinio.get! "indices", type: 'economic', page_size: 5 

# Request Object
p payload.request.class
# => HTTParty::Request

# Response Object
p payload.response.class
# => Net::HTTPOK

p payload.response.body
# => JSON string

p payload.response.code
# => 200

p payload.response.msg
# => OK

# Headers Object
p payload.headers
# => Hash with headers

# Parsed Response Object
p payload.parsed_response
# => Hash with HTTParty parsed response 
#    (this is the content returned with #get)
```

You can get the response as CSV by calling `get_csv`:

```ruby
result = intrinio.get_csv "indices", page_size: 5
# => CSV string
```

Intrinio automatically decides which part of the data to convert to CSV.
When there is an array in the response, it will be used as the CSV data. 
Otherwise, the entire response will be treated as a single-row CSV.

To save the output directly to a file, use the `save` method:

```ruby
intrinio.save "filename.json", "indices", type: 'economic', page_size: 5
```

Or, to save CSV, use the `save_csv` method:

```ruby
intrinio.save_csv "filename.csv", "indices", page_size: 5
```



Command Line
--------------------------------------------------

The command line utility `intrinio` acts in a similar way. To use your 
Intrinio authentication, simply set it in the environment variables 
`INTRINIO_AUTH`:

`$ export INTRINIO_AUTH=username:password`

These commands are available:

`$ intrinio get [--csv] PATH [PARAMS...]` - print the output.  
`$ intrinio pretty PATH [PARAMS...]` - print a pretty JSON.  
`$ intrinio see PATH [PARAMS...]` - print a colored output.  
`$ intrinio url PATH [PARAMS...]` - show the constructed URL.  
`$ intrinio save [--csv] FILE PATH [PARAMS...]` - save the output to a file.  

Run `intrinio --help` for more information, or view the [full usage help][2].

Examples:

```bash
# Shows the first 5 indices
$ intrinio see indices page_size:5

# Pass arguments that require spaces
$ intrinio see indices "query:interest rate" page_size:5

# Saves a file
$ intrinio save --csv aapl.csv historical_data identifier:AAPL \
    item:adj_close_price frequency:monthly page_size:10

# Shows the URL that Intrinio has constructed, good for debugging
$ intrinio url indices query:interest page_size:5
# => https://api.intrinio.com/indices?query=interest&page_size=5

```


Caching
--------------------------------------------------

We are using the [Lightly][3] gem for automatic HTTP caching.
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
[3]: https://github.com/DannyBen/lightly
