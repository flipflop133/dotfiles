from i3pystatus import IntervalModule
import subprocess
import os
import requests
from bs4 import BeautifulSoup
from time import sleep


def get_website():
    """try to retrieve the html weather page
        return
        ------
        page: html page(object)
        """
    URL = 'https://weather.com/weather/today/l/020a9eb8513910dd137f5e7f8d48fee51517e56c16dd146fea40aae4ab5ae559'
    page = ''
    while page == '':
        # try to retrieve the HTML page
        try:
            page = requests.get(URL, timeout=5)
            print("page suceed")
        # if it fails to retrieve the HTML page, check again every 60
        except (ConnectionError, requests.exceptions.Timeout,
                requests.exceptions.TooManyRedirects,
                requests.exceptions.RequestException):
            print("web error")
            sleep(60)
            page = ''
    return page


def get_weather():
    """Find weather informations in the html page
    return
    ------
    cdict: dictionary with icon and temp(dict)
    """
    page = get_website()
    cdict = {}
    while cdict == {}:
        try:
            soup = BeautifulSoup(page.content, 'html.parser')

            # retrieve temperature in HTML code
            job_elems = soup.find_all(
                'div',
                class_=
                '_-_-components-src-organism-CurrentConditions-CurrentConditions--primary--2DOqs'
            )
            temp = job_elems[0]
            temp = temp.text
            temp = temp.split('°')
            temperature = temp[0]
            conditions = temp[1].lower()
            print("no errors")
            # determine the icon
            icon = get_icon(conditions)

            cdict = {"icon": icon, "temp": temperature}
            return cdict
        except IndexError:
            print("get weather error")
            sleep(60)
            get_weather()


def get_icon(conditions):
    # determine icon in function of the weather conditions and the hour
    # check the hour
    icon = ''
    hour = subprocess.run(['date', '+%H'],
                          check=True,
                          stdout=subprocess.PIPE,
                          universal_newlines=True)
    hour = (hour.stdout).strip()
    # night icons
    if int(hour) > 22 or int(hour) < 7:
        if "cloud" in conditions:
            icon = ''
        elif "sun" in conditions:
            icon = ''
        elif "rain" in conditions:
            icon = ''
        elif "clear" in conditions:
            icon = ''
    # day icons
    else:
        if "partly cloudy" in conditions:
            icon = ''
        elif "cloud" in conditions:
            icon = ''
        elif "sun" in conditions:
            icon = ''
        elif "rain" in conditions:
            icon = ''
        elif "clear" in conditions:
            icon = ''
        elif "fair" in conditions:
            icon = ''
    return icon


print(get_weather())
