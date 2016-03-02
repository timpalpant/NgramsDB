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
	"time"
)

type NgramService struct {
	conn *sql.DB
}

func NewNgramService(database, user, password string) (*NgramService, error) {
	log.Println("Connecting to MySQL server")
	conn, err := sql.Open("mysql", connectionString(database, user, password))
	if err != nil {
		return nil, err
	}

	conn.SetMaxIdleConns(4)
	conn.SetMaxOpenConns(16)	
	return &NgramService{
		conn: conn,
	}, nil
}

func connectionString(database, user, password string) string {
	return user + ":" + password + "@/" + database
}

type NgramFreqRequest struct {
	Ngram string
}

type NgramFreqResponse struct {
	TotalFreq uint64
	TotalVol  uint64
	Years     []uint64
	Freqs     []uint64
	Vols      []uint64
}

func (ngs *NgramService) NgramFreq(r *http.Request,
	args *NgramFreqRequest, reply *NgramFreqResponse) error {
	tokens := strings.Fields(args.Ngram)

	n := len(tokens)
	var stmt string
	var params []interface{}
	if n == 1 {
		stmt = "SELECT total_freq, total_vol, HEX(year_freq) FROM 1gram WHERE word=?"
		word := strings.ToLower(tokens[0])
		params = []interface{}{word}
	} else if n > 1 && n <= 5 {
		stmt = fmt.Sprintf(
			"SELECT %vgram.total_freq, %vgram.total_vol, HEX(%vgram.year_freq)"+
				" FROM %vgram", n, n, n, n)
		params = make([]interface{}, len(tokens))
		for i, word := range tokens {
			stmt += fmt.Sprintf(
				" JOIN 1gram w%v ON w%v.id=%vgram.word%v_id AND w%v.word=?",
				i+1, i+1, n, i+1, i+1)
			params[i] = strings.ToLower(word)
		}
	} else {
		return fmt.Errorf("Only 1-5grams are available (not %v)", n)
	}

	log.Printf("Executing query: %v\n", stmt)
	start := time.Now()
	row := ngs.conn.QueryRow(stmt, params...)
	elapsed := time.Since(start)
	log.Printf("Query took: %v\n", elapsed)
	
	var yearFreqHex string
	err := row.Scan(&reply.TotalFreq, &reply.TotalVol, &yearFreqHex)
	if err != nil {
		return err
	}

	yearFreq, err := ngramsdb.DecodeFreq(yearFreqHex)
	if err != nil {
		return err
	}

	for i := 0; i < len(yearFreq); i += 3 {
		reply.Years = append(reply.Years, yearFreq[i])
		reply.Freqs = append(reply.Freqs, yearFreq[i+1])
		reply.Vols = append(reply.Vols, yearFreq[i+2])
	}

	return nil
}

func main() {
	database := flag.String("database", "ngram", "MySQL database name")
	user := flag.String("user", "pi", "MySQL user name")
	password := flag.String("password", "", "MySQL password")
	port := flag.Int("port", 8080, "Port to listen on")
	flag.Parse()

	s := rpc.NewServer()
	s.RegisterCodec(json.NewCodec(), "application/json")
	ngram, err := NewNgramService(*database, *user, *password)
	if err != nil {
		log.Fatal(err)
	}
	s.RegisterService(ngram, "")
	log.Printf("Listening on %v", *port)
	http.Handle("/rpc", s)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%v", *port), nil))
}
