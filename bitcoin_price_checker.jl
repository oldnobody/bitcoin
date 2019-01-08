#!/usr/local/bin/julia

using HTTP
using JSON

url = "https://api.coindesk.com/v1/bpi/currentprice/BTC.json"
pricefile = "lastprice.csv"

function getPrice(url::String)::Float64
  r = HTTP.request("GET", url )
  s = String(r.body)
  j = JSON.parse(s)
  p = j["bpi"]["USD"]["rate"]
  p = parse(Float64,replace(p, "," => ""))
  p = round(p, digits=2)
  return p
end

function getLastPrice(file::String)::Float64
  l = 0
  if isfile(file)
    f = open(file, "r")
    p = readlines(f)[1]
    l = parse(Float64,p)
    println("Last price was $l USD")
    close(f)
  end
  return l
end

function savePrice(file::String, price::Float64)
  f = open(file, "w")
  write(f,string(price))
  close(f)
end

price = getPrice(url)
last = getLastPrice(pricefile)
difference = round(price - last, digits=2)

if (last != 0) && (abs(difference) > 0.0)
  direction = difference > 0.0 ? "up" : "down"
  println("Bitcoin is currently at $price USD, $direction $(abs(difference)) USD")
else
  println("Bitcoin is currently at $price USD")
end

savePrice(pricefile, price)

