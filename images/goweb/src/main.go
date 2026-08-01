package main

import (
  "fmt"
  "net/http"
  "net/http/cgi"
  "os"
  "os/signal"
  "syscall"
  "log"
  "time"
)

func cgiMyDB(w http.ResponseWriter, r *http.Request) {
handler := cgi.Handler{Path: "/opt/www/cgi/mydb.sh"}
handler.ServeHTTP(w, r)
}

func cgiMyData(w http.ResponseWriter, r *http.Request) {
handler := cgi.Handler{Path: "/opt/www/cgi/mydata.sh"}
handler.ServeHTTP(w, r)
}

func cgiInfo(w http.ResponseWriter, r *http.Request) {
handler := cgi.Handler{Path: "/opt/www/cgi/myinfo.sh"}
handler.ServeHTTP(w, r)
}

func main() {
  cancelChan := make(chan os.Signal, 1)
  // catch SIGETRM or SIGINTERRUPT
  signal.Notify(cancelChan, syscall.SIGTERM, syscall.SIGINT, syscall.SIGKILL)

  f, err := os.Create("/opt/www/goweb.out")
  if err != nil {
     fmt.Println(err)
     return
  }

  go func() {
     static := http.FileServer(http.Dir("/opt/www"))
     http.Handle("/",static)

     http.HandleFunc("/db", cgiMyDB)
     http.HandleFunc("/data", cgiMyData)
     http.HandleFunc("/info", cgiInfo)
     fmt.Println("goweb start on port 8080")
     http.ListenAndServe(":8080", nil)
  }()

  sig := <-cancelChan
  log.Printf("Caught signal %v", sig)
  log.Printf("countdown 60 second")
  time.Sleep(60 * time.Second)
  fmt.Fprintf(f, "Caught signal %v", sig)  
}
