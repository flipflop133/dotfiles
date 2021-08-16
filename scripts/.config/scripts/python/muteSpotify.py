import subprocess


def muteSpotify():
    # run the command
    appList = subprocess.run(["pacmd", "list-sink-inputs"],
                             stdout=subprocess.PIPE)

    # parse the output
    parsed = {}
    lines = appList.stdout.decode('utf-8').replace("\t",
                                                   "").replace(" ",
                                                               "").split("\n")
    current_index = 0
    cross_properties = False

    for line in lines:
        if not cross_properties:
            splited = line.split(":")
            cross_properties = splited[0] == "properties"

            if splited[0] == "index":
                current_index = int(splited[1])

        else:
            splited = line.split("=")
            if splited[0] == "application.name":
                parsed[splited[1]] = current_index
                current_index = 0
                cross_properties = False

    # mute
    index = parsed["\"Spotify\""]
    subprocess.run(["pacmd", "set-sink-input-mute", str(index), "true"])


muteSpotify()
