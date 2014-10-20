module Exos
  module Commands
    class Command

      class << self
        include ::Commander::Methods
      end

      attr_reader :args, :options

      def initialize(args, options)
        @args = args
        @options = options
      end

      private

        def log(str)
          out = "[exos]".green
          out << " #{ str }"
          puts out
        end

        def fail(str)
          out = "[exos]".red
          out << " #{ str }"
          abort out
        end

        def ec2
          @ec2 ||= ::Fog::Compute::AWS.new
        end

        def elb
          @elb ||= ::Fog::AWS::ELB.new
        end

        def self.humanize(str)
          str.gsub("_", " ").gsub(/\b(?<!['’`])[a-z]/) { $&.capitalize }
        end
    end
  end
end
