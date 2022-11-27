import http.client
import json

# Fetch from rest country API
conn = http.client.HTTPSConnection("restcountries.com")
payload = ''
headers = {}
conn.request("GET", "/v3.1/all", payload, headers)
res = conn.getresponse()
data = res.read()

# Fetch from local database
local = json.load(open("assets/data.json"))

for offCountry in json.loads(data):
    isFound = False

    for country in local["Countries"]:
        if country["country"] == offCountry["name"]["common"] or country["country"] == offCountry["name"]["common"] or ("alpha3" in country and country["alpha3"] == offCountry["cca3"]) or ("alpha2" in country and country["alpha2"] == offCountry["cca2"]):
            country["cca3"] = offCountry["cca3"]
            country["latitude"] = offCountry["latlng"][0]
            country["longitude"] = offCountry["latlng"][1]
            isFound = True
            break

    if not isFound:
        local["Countries"].append({
            "country" : offCountry["name"]["common"],
            "latitude" : offCountry["latlng"][0],
            "longitude" : offCountry["latlng"][1],
            "cca3" : offCountry["cca3"],
            "zoom" : 5,
        })
print(json.dumps(local["Countries"]))
