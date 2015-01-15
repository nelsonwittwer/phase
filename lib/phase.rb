require 'terminal-table'
require 'active_support'
require 'progressbar'
require 'colorize'
require 'fog'
require 'capistrano'
require 'sshkit'

require 'dotenv'
::Dotenv.load if defined?(::Dotenv)

require 'phase/adapter'
require 'phase/adapters/abstract'
require 'phase/adapters/aws'

require "phase/mixins/loggable"

require 'phase/ssh/backend'
# require 'phase/ssh/bastion'
require 'phase/ssh/bastion_coordinator'
require 'phase/ssh/command'
require 'phase/ssh/runners'

require 'phase/configuration'
require 'phase/version'


module Phase
  class << self

    def config
      @@config ||= Configuration.new
    end

    def reset_config!
      @@config = nil
    end

    def configure(&block)
      yield config
    end

    def adapter
      config.adapter
    end

  end

  class ResourceNotFoundError < ::StandardError; end
end
