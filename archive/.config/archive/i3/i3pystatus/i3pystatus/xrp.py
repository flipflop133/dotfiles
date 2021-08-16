# Retrieve the xrp price in dollars from coinmarketcap.
# Doc: https://coinmarketcap.com/api/documentation/v1/

import json
import os
from i3pystatus import IntervalModule
from requests import Session


class xrp_price(IntervalModule):

    color = "#ffffff"
    on_leftclick = "coinbase"
    settings = (("format", "Format string used for output."),
                ("color", "Standard color"), ("interval", "Update interval."))
    format = "{price}{percent}"
    interval = 700

    def get_xrp_price(self):
        url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
        parameters = {'start': '1', 'limit': '5000', 'convert': 'EUR'}
        f = open("/home/francois/.config/xrp_api_key.txt", "r")
        apiKey = f.readlines()
        for i in apiKey:
            i = i.strip('\n')
            if 'api_key' in i:
                api_key = i.split('=')
                api_key = api_key[1]
            elif 'xrp_amount' in i:
                xrp_amount = i.split('=')
                xrp_amount = xrp_amount[1]

        f.close()
        headers = {
            'Accepts': 'application/json',
            'X-CMC_PRO_API_KEY': str(api_key),
        }

        session = Session()
        session.headers.update(headers)

        try:
            response = session.get(url, params=parameters)
            data = json.loads(response.content)
            data = data["data"]

            for x in data:
                if x['id'] == 52:
                    price = x['quote']['EUR']['price']
                    percent = x['quote']['EUR']['percent_change_24h']
            percent = round(percent, 2)
            if percent > 0:
                percent = str(percent) + '%'
            elif percent == 0:
                percent = str(percent) + ''
            else:
                percent = str(percent) + '%'
            wallet = round((float(xrp_amount) * float(price)), 2)
            price = round(price, 3)
            cdict = {'price': price, 'percent': percent, 'wallet': wallet}
        except:
            cdict = {'price': '', 'percent': '', 'wallet': ''}
        return cdict

    def coinbase(self):
        os.popen("chromium https://www.coinbase.com/dashboard")

    def run(self):
        cdict = self.get_xrp_price()
        self.data = cdict
        self.output = {
            "full_text": self.format.format(**cdict),
            "color": self.color
        }
