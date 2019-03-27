Create example hanami app

```zsh
# create hanami app
hanami new bookshelf
cd bookshelf

# add webpacker via yarn
yarn add @rails/webpacker
yarn add --dev webpack-dev-server

# add gem 'webpacker' to Gemfile and execute
bundle install

# create bin folder
mkdir bin

# download those files from my webpacker-example repository
curl https://raw.githubusercontent.com/aganov/hanami-webpacker-example/master/lib/webpacker.rb -o lib/webpacker.rb
curl https://raw.githubusercontent.com/aganov/hanami-webpacker-example/master/config/initializers/webpacker.rb config/initializers/webpacker.rb
curl https://raw.githubusercontent.com/aganov/hanami-webpacker-example/master/apps/web/helpers/assets.rb -o apps/web/helpers/assets.rb
curl https://raw.githubusercontent.com/aganov/hanami-webpacker-example/master/apps/web/views/head_elements_helper.rb apps/web/views/head_elements_helper.rb

curl https://raw.githubusercontent.com/aganov/hanami-webpacker-example/master/bin/webpack -o bin/webpack-dev-server
curl https://raw.githubusercontent.com/aganov/hanami-webpacker-example/master/bin/webpack-dev-server -o bin/webpack-dev-server

chmod +x bin/webpack
chmod +x bin/webpack-dev-server

# download those files from webpacker install directory
curl https://raw.githubusercontent.com/rails/webpacker/master/lib/install/config/.browserslistrc -o .browserslistrc
curl https://raw.githubusercontent.com/rails/webpacker/master/lib/install/config/babel.config.js -o babel.config.js
curl https://raw.githubusercontent.com/rails/webpacker/master/lib/install/config/postcss.config.js -o postcss.config.js

# webpacker configs
curl https://raw.githubusercontent.com/rails/webpacker/master/lib/install/config/webpacker.yml -o config/webpacker.yml

mkdir config/webpack
curl https://raw.githubusercontent.com/rails/webpacker/master/lib/install/config/webpack/development.js -o config/webpack/development.js
curl https://raw.githubusercontent.com/rails/webpacker/master/lib/install/config/webpack/production.js -o config/webpack/production.js
curl https://raw.githubusercontent.com/rails/webpacker/master/lib/install/config/webpack/test.js -o config/webpack/test.js
curl https://raw.githubusercontent.com/rails/webpacker/master/lib/install/config/webpack/environment.js -o config/webpack/environment.js
```

Now its time for some editing

 * Edit `config/webpacker.yml` and modify it with something like this

```yaml
default: &default
  source_path: apps/client
  source_entry_path: bundles
  public_output_path: bundles
development:
  <<: *default
  compile: false
test:
  <<: *default
  compile: false
  public_output_path: bundles-test
```

  * Edit `apps/web/application.rb` according this example

```ruby
require "hanami/helpers"
require "webpacker/helper" # replace "hanami/assets"

require_relative "../../lib/webpacker"
require_relative "./views/head_elements_helper"

module Web
  class Application < Hanami::Application
    configure do
     load_paths << [
        'controllers',
        'helpers', # add helpers directory
        'views'
      ]

      # Add Webpacker::DevServerProxy
      if Hanami.env?(:development)
        require "webpacker/dev_server_proxy"
        middleware.use Webpacker::DevServerProxy, ssl_verify_none: true
      end

      view.prepare do
        include Hanami::Helpers
        include Web::Helpers::Assets # Replace Web::Assets::Helpers with our's Web::Helpers::Assets
      end

      # REMOVE assets section
    end
  end
end
```

Create `apps/client` structure

```
mkdir -p apps/client/bundles
echo "console.log('Webpacker!')" > apps/client/bundles/application.js
```

Execute

```
bundle exec bin/webpack-dev-server
```

You should get some output like this one

```
ℹ ｢wdm｣: Hash: abcadbecc8eb7c6a65b0
Version: webpack 4.29.6
Time: 3558ms
Built at: 03/27/2019 12:45:41 PM
                                     Asset       Size       Chunks             Chunk Names
    js/application-624db69a410523992ade.js    375 KiB  application  [emitted]  application
js/application-624db69a410523992ade.js.map    425 KiB  application  [emitted]  application
                             manifest.json  372 bytes               [emitted]
ℹ ｢wdm｣: Compiled successfully.
```

Now you can use `javascript_pack_tag` and `stylesheet_pack_tag` helpers in your hanami application

```erb
<!DOCTYPE html>
<html>
  <head>
    <title>Web</title>
    <%= javascript_pack_tag "application" %>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

