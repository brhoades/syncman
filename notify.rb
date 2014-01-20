class Notify
  @@filename = nil
  @@tag = "unk"
  @@description = "Unknown file: "
  def initialize( fn )
    @@filename = fn
    @@tag = "unk"
    @@description = @@description + fn
    
    renderMessage( );
  end
   
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
  
  private
  
  def description=( val )
    @@description = val
  end
  
  def description( )
    @@description
  end
  
  def fn( )
    @@filename
  end
  
  def filename( )
    @@filename
  end
  
end


