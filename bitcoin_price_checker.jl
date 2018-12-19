#!/usr/local/bin/julia

using HTTP
using JSON

url = "https://api.coindesk.com/v1/bpi/currentprice/BTC.json"
pricefile = "lastprice.cvs"

function getPrice(url::String)::String
  r = HTTP.request("GET", url )
  s = String(r.body)
  j = JSON.parse(s)
  price = j["bpi"]["USD"]["rate"]
  return price
end

# get the price from url
price = getPrice(url)
floatprice = parse(Float64,replace(price, "," => ""))

function getLastPrice(file::String)::Float64
  lastprice = 0

  if isfile(file)
    f = open(file, "r")
    p = readlines(f)[1]
    lastprice = parse(Float64,replace(p, "," => ""))
    close(f)
  else
    f = open(file, "w")
    write(f,price)
    close(f)
    println("Writing lastprice.cvs")
  end

  return lastprice
end

getLastPrice(pricefile)
println(string("Bitcoin is currently at ", floatprice, " USD"))

