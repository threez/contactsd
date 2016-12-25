require 'contactsd/version'

# stdlib
require 'securerandom'
require 'json'
require 'base64'

# rubygems
gem 'rb-scpt', '~> 1.0.1'
gem 'sinatra', '~> 1.4.7'
gem 'vcardigan', '~> 0.0.9'
gem 'thor', '~> 0.19.4'
gem 'puma', '~> 3.6.2'
gem 'pidfile', '~> 0.3.0'

require 'osax' # from rb-scpt
require 'sinatra/base'
require 'vcardigan'
require 'thor'
require 'puma'
require 'pidfile'

# set default encoding
Encoding.default_internal = Encoding::UTF_8

module Contactsd
  class NotFound < StandardError; end

  autoload :API, 'contactsd/api'
  autoload :CLI, 'contactsd/cli'
  autoload :Database, 'contactsd/database'
end
