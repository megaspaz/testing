module OsSniffer
  include RbConfig
  def self.get_local_os
    STDOUT.print 'Determining host operating system... '
    STDOUT.print "#{RbConfig::CONFIG['host_os']}#{Dir.exist?("/mnt/c/Windows") ? ' /mnt/c/Windows' : ''}\n"

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
