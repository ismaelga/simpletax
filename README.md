# SimpleTax

Ruby gem for interacting with SimpleTax API

## Installation

Add this line to your application's Gemfile:

    gem 'simpletax'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simpletax

## Usage

```ruby
require 'simpletax'

simpletax = SimpleTax::Client.new redirect_url: 'YOUR_CALLBACK_URL', client_id: 'CLIENT_ID', client_secret: 'CLIENT_SECRET'
simpletax.authorize_url
# => "https://secure.gosimpletax.com/o/authorize/?client_id=CLIENT_ID&redirect_uri=YOUR_CALLBACK_URL&response_type=code"
# Authorize it in the browser with the given url

simpletax.fetch_token 'CODE_GOTTEN_FROM_THE_CALLBACK_URL'

simpletax.add_income(2500, description: 'Customer invoice')
simpletax.add_expense(200, description: 'Photoshop license')

# Now check the result on your SimpleTax account'
```

## Contributing

1. Fork it ( http://github.com/ismaelga/simpletax/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
