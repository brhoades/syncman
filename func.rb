require 'open-uri'

# If a filter in our global filters list matches, we return true
def filter( fn )
  $filters.each do |filter|
    if fn.match /#{filter}$/
      return true
    end
  end
  
  return false
end

# Substitutes dates out of the file name
def folderDate( folder )
  return Time.new.strftime folder
end

# Downlaods the file and creates appropriate directories
def download( filex, downc )
  # Create the directory recursively, substituting the date in
  system "mkdir -p \"" + folderDate( downc['destination'] ) + "\""
  if filex[2] != ""
    filex[2] += "/"
  end
  print downc['baseurl'] + filex[2] + filex[0] + " " + "..." + " "
  # Open an HTTP connection
  File.open( folderDate( downc['destination'] ) + filex[0], "wb") do |file|
    if downc['user'] != nil
      file.write open( URI::encode( downc['baseurl'] + filex[2] + filex[0] ), 
		      :http_basic_authentication => [downc['user'], downc['pass']],
		      :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE ).read
    else
      file.write open( URI::encode( downc['baseurl'] + filex[2] + filex[0] ),
		      :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE ).read
    end
  end
  
  print "done\n"
end