package main

import (
	"database/sql"
	"flag"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/rpc"
	"github.com/gorilla/rpc/json"
	"github.com/timpalpant/ngramsdb"
	"log"
	"net/http"
	"strings"
)

type NgramService struct {
	database, user, password string
}

func NewNgramService(database, user, password string) *NgramService {
	return &NgramService{
		database: database,
		user:     user,
		password: password,
	}
}

func (ngs *NgramService) connectionString() string {
	return ngs.user + ":" + ngs.password + "@/" + ngs.database
}

type YearFreqRequest struct {
	Ngram string
}

type YearFreqResponse struct {
	Years []uint64
	Freqs []uint64
	Vols  []uint64
}

func (ngs *NgramService) YearFreq(r *http.Request,
	args *YearFreqRequest, reply *YearFreqResponse) error {
	tokens := strings.Fields(args.Ngram)
	conn, err := sql.Open("mysql", ngs.connectionString())
	if err != nil {
		return err
	}

	n := len(tokens)
	stmt := fmt.Sprintf("SELECT year_freq FROM %vgram", n)
	params := make([]interface{}, len(tokens))
	for i, word := range tokens {
		stmt += fmt.Sprintf(" JOIN 1gram w%v ON w%v.id=%vgram.word%v_id AND w%v.word=?", i+1, i+1, n, i+1, i+1)
		params[i] = word
	}

	row := conn.QueryRow(stmt, params...)
	var yearFreqHex string
	err = row.Scan(&yearFreqHex)
	if err != nil {
		return err
	}

	yearFreq, err := ngramsdb.DecodeFreq(yearFreqHex)
	if err != nil {
		return err
	}

	for i := 0; i < len(yearFreq); i += 3 {
		reply.Years = append(reply.Years, yearFreq[i])
		reply.Freqs = append(reply.Freqs, yearFreq[i])
		reply.Vols = append(reply.Vols, yearFreq[i])
	}

	return nil
}

func main() {
	database := flag.String("database", "ngram", "MySQL database name")
	user := flag.String("user", "pi", "MySQL user name")
	password := flag.String("password", "ngram", "MySQL password")
	port := flag.Int("port", 8080, "Port to listen on")
	flag.Parse()

	s := rpc.NewServer()
	s.RegisterCodec(json.NewCodec(), "application/json")
	ngram := NewNgramService(*database, *user, *password)
	s.RegisterService(ngram, "")
	http.Handle("/rpc", s)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%v", *port), nil))
}
