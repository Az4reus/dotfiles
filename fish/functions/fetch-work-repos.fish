# Defined in /var/folders/g7/r4g4b9_n1rqd3gk8fdq9d6wm0000gn/T//fish.K7RVhc/fetch-work-repos.fish @ line 2
function fetch-work-repos
	for dir in ~/work/*
    if test -d $dir 
      echo "updating $dir"
      pushd $dir
      git fetch -a --prune
      popd
    else
      echo "skipping $dir"
    end
  end
end
