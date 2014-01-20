AVAILABLE = 0
STARTED = 1
COMPLETE = 2

class Notify
  @@filename = nil
  @@tag = "unk"
  @@description = "Unknown file: "
  
  def initialize( fn )
    @@filename = fn
    @@tag = "unk"
    @@description = @@description + fn
    
    renderMessage
  end
  
  def available
    getUsers AVAILABLE
  end
  
  def started
    getusers STARTED
  end
  
  def complete
    getUsers COMPLETE
  end
  
  private
  
  # Get our file's information by looking in config
  #   Looks for matches in the file name according to the regex
  #   spots in parenthesis. Then replaces in details $1-$4.
  def renderMessage
    $notifyc.keys.each do |tag|
      if tag == "unk" or tag == "all"
	next
      elsif match = fn.match($notifyc[tag]['regex'])
	one, two, three, four = match.captures
	ret = $notifyc[tag]['details']
	ret = ret.sub /\$1/, one
	ret = ret.sub /\$2/, two

	if three != nil
	  ret = ret.sub /\$3/, three
	else
	  ret = ret.sub /\$3/, ""
	end

	if four != nil
	  ret.sub /\$4/, four
	else
	  ret.sub /\$4/, ""
	end
	
	@tag = tag
	@description = ret
      end
    end
  end
  
  # Wrapper function for easier calling of each type of notification
  def getUsers( type )
    $usersc.keys.each do |user|
      tags = user['tags'].split ','
      if ( tags.include? "all" or tags.include? tag ) \
	and user['notify'].split( ',' ).include? type
	dispatch type, user
      end
    end
  end
  
  # Actually send our notifications out
  def dispatch( type, user )
  end
  
  def description=( val )
    @@description = val
  end
  
  def description( )
    @@description
  end
  
  def description=( val )
    @@description = val
  end
  
  def fn( )
    @@filename
  end
  
  def filename( )
    @@filename
  end
  
  def filename=( val )
    @@filename = val
  end
end