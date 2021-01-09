# frozen_string_literal: true

# Config helpers
module Config
  def self.[](server_id)
    ServerConfig[server_id]
  end

  def self.help_msg(event, command, avail)
    cmd = Config[event.server.id].prefix + command
    subcmds = subcommands(command, avail)

    embed event, <<~TEXT
      ```
      #{t 'cfg.usage'} #{cmd} <#{t 'cfg.subcmd'}> [#{t 'cfg.options'}]

      #{t 'cfg.avail_subcmd'}
      #{subcmds}
      ```
    TEXT
  end

  def self.subcommands(command, avail)
    tid_pfx = command.split.join('.')
    descriptions = avail.map { |name| t "#{tid_pfx}.help.#{name}" }

    avail.zip(descriptions).map { |cmd, desc| "    #{cmd} - #{desc}" }.join("\n")
  end

  def self.save_prefix(event, cfg, new_prefix)
    cfg.prefix = new_prefix
    cfg.save!

    embed event, t('cfg.prefix.saved', new_prefix)
  end
end
