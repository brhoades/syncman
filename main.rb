require 'yaml'
require 'net/ssh'

cfg = YAML.load File.open "config.yml"

#Contact the server via SSH and get a file readout with ls
print cfg

Net::SSH.start cfg{'server'}, :password => cfg{'password'} do |ssh|
  files = ssh.exec "ls " + cfg{'directory'}
  print files
end