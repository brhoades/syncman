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