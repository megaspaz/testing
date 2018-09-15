module OsSniffer
  include RbConfig
  def self.get_local_os
    STDOUT.puts "Determining host operating system... #{RbConfig::CONFIG['host_os']}"

    case RbConfig::CONFIG['host_os']
    when /mswin|windows/i
      return "windows"
    when /linux|arch/i
      return "windows" if Dir.exist?("/mnt/c/Windows")
      return "linux"
    when /sunos|solaris/i
      return "sun"
    when /darwin/i
      return "mac"
    else
      return nil
    end
  end
end
