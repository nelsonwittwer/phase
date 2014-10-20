module Exos
  module Commands
    class SSH < Command

      command :ssh do |c|
        c.syntax = "exos ssh [-i instance_id] [-n instance_name] [-r instance_role] [-u user] [-c conn_str] [username@instance_name|instance_id]"

        c.option "-i", "--id instance_id", String, "Connects to the instance with this ID."
        c.option "-n", "--name instance_name", String, "Connects to the instance with this 'Name' tag."
        c.option "-r", "--role instance_role", String, "Connects to an instance with this 'Role' tag. Default is 'ssh'."
        c.option "-u", "--user username", String, "Remote username to connect with."
        c.option "-c", "--conn conn_str", String, "Invokes conn_str to establish terminal session (e.g. --ssh 'ssh -i key.pem')."

        c.description = "Connects to the the specified instance via SSH."
        c.action do |args, options|
          options.default role: "ssh", conn: "ssh"
          new(args, options).run
        end
      end

      attr_accessor :user, :instance

      def run
        log "connecting to instance #{ instance.id }..."
        exec "#{ options.conn } #{ user }@#{ instance.dns_name }"
      end

      private

        def user
          # Handle "connection string" style parameter.
          if conn = args.first
            user, str = conn.split("@")

            fail "Malformed parameter: user@[instance-name|instance-id]." if str.nil?

            str.match(/i-[0-9a-f]+/i) ? options.id = str : options.name = str
          else
            user = options.user
          end

          fail "Must specify username with -u or 'user@instance-name' parameter." if user.nil?

          user
        end

        def instance
          if options.id
            instance = ec2.servers.all("instance-id" => options.id).first
          elsif options.name
            instance = ec2.servers.all("tag:Name" => options.name).first
          else
            instance = ec2.servers.all("tag:Role" => options.role).first
          end

          fail "no instance found." if instance.nil?

          instance
        end

    end
  end
end
