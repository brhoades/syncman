# Get our file's information by looking in config
#   Looks for matches in the file name according to the regex
#   spots in parenthesis. Then replaces in details $1-$4.
def fetchInfo( fn, typ=0 )
  $notifyc.keys.each do |tag|
    print fn + "=~" + $notifyc[tag]['regex'] + "\n"
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
      
      if typ == 0
	return tag, ret
      else
	return one, two, three, four
      end
    end
  end
  return "unk", "Unknown file: " + fn
end

