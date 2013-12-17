require 'yaml'
require 'net/ssh'

cfg = YAML.load File.open "config.yml"
sshc = cfg['ssh']
print cfg, "\n\n"

#Contact the server via SSH and get a file readout with ls
Net::SSH.start( sshc['server'], sshc['username'], :password => [sshc['pass']], :port => sshc['port'] ) do |ssh|
  #Name relative to directory\tsize in bytes\tunix timestamp\n
  files = ssh.exec "cd " + sshc['directory'] + "&& find -type f -printf '%p\t%s\t%Ts\n'"
end