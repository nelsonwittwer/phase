module Phase
  module CLI
    class IPA < Command

      command :ipa do |c|
        c.syntax = "phase ipa [version_number] [filename|pattern]..."

        c.description = <<-EOS.strip_heredoc
          Generates enterprise distribution .plists for .ipa app bundles and uploads
          all required files to the web for distribution.
        EOS

        c.action do |args, options|
          new(args, options).run
        end
      end

      attr_accessor :version, :filenames

      def initialize(args, options)
        @version   = args.shift
        @filenames = args

        if @version.blank? || @filenames.blank?
          fail "invalid syntax: phase ipa [--version version_number] [filename|glob_pattern]..."
        end

        if Phase.config.bundle_id_prefix.blank?
          fail "missing setting: set `Phase.config.bundle_id_prefix = [PREFIX] in Phasefile"
        elsif Phase.config.ipa_bucket_name.blank?
          fail "missing setting: set `Phase.config.ipa_bucket_name = [BUCKET]` in Phasefile"
        elsif Phase.config.ipa_directory_prefix.blank?
          fail "missing setting: set `Phase.config.ipa_directory_prefix = [PREFIX] in Phasefile"
        end

        super
      end

      def run
        deployment = ::Phase::IPA::EnterpriseDeployment.new(version, *filenames)
        deployment.run!
      end

    end
  end
end
