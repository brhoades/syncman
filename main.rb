require 'yaml'
require 'net/ssh'

cfg = YAML.load File.open "config.yml"
sshc = cfg['ssh']
downc = cfg['download']
print cfg, "\n\n"
files = ""

#Contact the server via SSH and get a file readout with ls
Net::SSH.start( sshc['server'], sshc['username'], :password => [sshc['pass']], :port => sshc['port'] ) do |ssh|
  #Name relative to directory\tsize in bytes\tunix timestamp\n
files = ssh.exec! "cd " + sshc['directory'] + "&& find -type f -newermt @#{Date.today.to_time.to_i - downc['time']*3600} -printf '%p\t%s\t%Ts\n'"
end

#Take each line of the string recieved above and split it into an array of its values
files = files.lines.map( &:chomp ).map { |l| l.split "\t" }

files.each do |filex|
  
  
  
end  