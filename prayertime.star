

load("render.star", "render")
load("schema.star", "schema")
load("http.star", "http")
load("encoding/json.star", "json")

EXAMPLE_LOCATION = {
	"lat": "40.6781784",
	"lng": "-73.9441579",
	"description": "Brooklyn, NY, USA",
	"locality": "Brooklyn",
	"place_id": "ChIJCSF8lBZEwokRhngABHRcdoI",
	"timezone": "America/New_York"
}




def main(config):

    
    location = config.get("location")
    loc = json.decode(location) if location else EXAMPLE_LOCATION
    latitude= loc["lat"]
    longitude= loc["lng"]
    if config.bool("hanafi")==True:
        hanafi=1
    else: hanafi=0
    API_CALL = "http://api.aladhan.com/v1/timings/date_or_timestamp?latitude={}&longitude={}&school={}".format(latitude,longitude,hanafi)
    timings = http.get(API_CALL)
    fajrTime = timings.json()["data"]["timings"]["Fajr"]
    dhuhrTime = timings.json()["data"]["timings"]["Dhuhr"]
    asrTime = timings.json()["data"]["timings"]["Asr"]
    maghribTime = timings.json()["data"]["timings"]["Maghrib"]
    ishaTime = timings.json()["data"]["timings"]["Isha"]

    if config.bool("hr")==True:
        hr12=1
        print("12hr: " ,hr12)
        if int(dhuhrTime[0:2])>12:
            dhuhrTime = "0" + str(int(dhuhrTime[0:2])-12) + dhuhrTime[2:]
        if int(asrTime[0:2])>12:
            asrTime = str(int(asrTime[0:2])-12) + asrTime[2:]           
        if int(maghribTime[0:2])>12:
           maghribTime = str(int(maghribTime[0:2])-12) + maghribTime[2:]
        if int(ishaTime[0:2])>12:
            ishaTime = str(int(ishaTime[0:2])-12) + ishaTime[2:]

        if int(fajrTime[0:2])<10:
            fajrTime= fajrTime[1:2] + fajrTime[2:]

        if int(dhuhrTime[0:2])<10:
            dhuhrTime= dhuhrTime[1:2] + dhuhrTime[2:]

    else: print("12hr off")


        
        
    
    

    return render.Root(


        child = render.Column(
            # scroll_direction = "vertical",
            children = [
                render.Text("Fajr: %s" % fajrTime),
                render.Text("Dhuhr: %s" % dhuhrTime),
                render.Text("Asr: %s" % asrTime),
                render.Text("Maghrib: %s" % maghribTime),
                render.Text("Isha: %s" % ishaTime)

            ]
        )
    )

def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
            schema.Location(
                id = "location",
                name = "Location",
                desc = "Location for which to display prayer times.",
                icon = "locationArrow",
            ),
            schema.Toggle(
                id = "hanafi",
                name = "Hanafi Asr Calculation",
                desc = "Toggle Hanafi Asr calculation.",
                icon = "hourglass",
                default = False,
            ),
            schema.Toggle(
                id = "hr",
                name = "12hr",
                desc = "Toggle Hanafi Asr calculation.",
                icon = "hourglass",
                default = True,
            ),

        ],
    )