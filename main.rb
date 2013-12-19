require 'yaml'
require 'net/ssh'

cfg = YAML.load File.open "config.yml"
sshc = cfg['ssh']
downc = cfg['download']
$filters = cfg['download']['filter'].split ","
files = ""
folders = {} #Our folder indicies that point to our files
delete = [] #Put things to delete in here as we go

def filter( fn )
  $filters.each do |filter|
    if fn.match /#{filter}$/
      return true
    end
  end
  
  return false
end

#Contact the server via SSH and get a file readout with ls
Net::SSH.start( sshc['server'], sshc['username'], :password => [sshc['pass']], :port => sshc['port'] ) do |ssh|
  #Name relative to directory\tsize in bytes\tunix timestamp\n
files = ssh.exec! "cd " + sshc['directory'] + "&& find -type f -newermt @#{Date.today.to_time.to_i - downc['time']*3600} -printf '%p\t%s\t%Ts\n'"
end

if files == nil
  print "No files to download\n"
  exit 0
end

#Take each line of the string recieved above and split it into an array of its values
files = files.lines.map { |l| l.chomp.split "\t" }

files.each do |filex|
  filex[0].gsub!( /^\.\//, '' )
  folder = []
  fn = filex[0]
  size = filex[1]
  folder = []
  
  #Remove the folder names (if there are any) and make them later
  if fn.match '/'
    fnarray = fn.split '/'
    while fnarray.size > 1
      folder.push fnarray.shift
    end
    
    fn = fnarray.join
  end
  
  folder = folder.join '/'
  
  #second fn is a backup for downloading
  data = [fn, size, fn]
  if folder.size == 0
    folder = ""
  end

  if folders.has_key? folder
    folders[folder].push data
  else
    folders[folder] = [data]
  end  
end  

#Remove filtered files
folders.keys.each do |folder|
  folders[folder].each do |file|
    if filter file[0]
      folders[folder].delete file
    end
  end
end

#FIXME: backup reldirectory
#Now move folders with one file to the main directory
folders.keys.each do |folder|
  if folder == ""
    next
  end
  
  if folders[folder].size == 0
    folders.remove folder
  elsif folders[folder].size == 1
    if not folders.has_key? ""
      folders[""] = []
    end
    
    folders[""].push folders[folder][0]
    folders.delete folder
  end
end

print folders
