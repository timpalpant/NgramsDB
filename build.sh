DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export GOPATH=${DIR}:${GOPATH}

go build github.com/timpalpant/ngramsdb/unigrams_prep
go build github.com/timpalpant/ngramsdb/ngramsdb_prep
go build github.com/timpalpant/ngramsdb/collapse_dups
go build github.com/timpalpant/ngramsdb/server
