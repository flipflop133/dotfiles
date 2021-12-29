import json
import requests
from time import sleep
from datetime import datetime
from pathlib import Path
home = str(Path.home())

error_time = 0


def error_handling():
    global error_time
    sleep(error_time)
    if error_time < 600:
        error_time += 10
    get_sunset_sunrise()


def get_sunset_sunrise():
    """Retrieve current sunset and sunrise from weatherapi.com
    """
    data = ""
    try:
        # retrieve data from json file
        with open(home + "/.config/weather-script/weather_settings.json",
                  'r') as read_file:
            data = json.load(read_file)
        url = "http://api.weatherapi.com/v1/forecast.json"
        key = data['key']
        parameters = data['parameters']
        # retrieve weather from weatherapi.com
        request = "{}?key={}&q={}".format(url, key, parameters)
        response = requests.get(request)
        data = json.loads(response.content)
        sunrise = datetime.strptime(
            data['forecast']['forecastday'][0]['astro']['sunrise'], '%I:%M %p')
        sunrise = (str(sunrise.time())[:-3]).replace(":", "")
        sunset = datetime.strptime(
            data['forecast']['forecastday'][0]['astro']['sunset'], '%I:%M %p')
        sunset = (str(sunset.time())[:-3]).replace(":", "")
        return sunrise, sunset
    except:  # we don't get about the error here, we just need to retry
        error_handling()
