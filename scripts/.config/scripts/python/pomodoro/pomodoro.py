import sys
from time import sleep
import json
import socket
from threading import Thread
import multiprocessing

MAX_LENGTH = 4096
PORT = 10000
HOST = '127.0.0.1'


class Pomodoro:
    next_run_thread = None

    def start_timer(self):
        if self.next_run_thread is not None and self.next_run_thread.is_alive():
            return
        self.next_run_thread = multiprocessing.Process(target=self.timer)
        self.next_run_thread.start()

    def timer(self):
        duration = 30
        while (duration > 0):
            self.write_output(duration)
            duration -= 1
            sleep(60)

    def stop_timer(self):
        self.next_run_thread.terminate()
        self.write_output('')

    def write_output(self, text):
        output = {'text': str(text)}
        sys.stdout.write(json.dumps(output) + '\n')
        sys.stdout.flush()


class Server:
    def start_server(self):
        serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        serversocket.bind((HOST, PORT))
        serversocket.listen(10)
        pomodoro = Pomodoro()
        while 1:
            sleep(0.5)
            (clientsocket, address) = serversocket.accept()
            buf = clientsocket.recv(MAX_LENGTH)
            if buf.decode() == 'start':
                pomodoro.start_timer()
            elif buf.decode() == 'stop':
                pomodoro.stop_timer()


class Client:
    def start_client(self, command):
        s = socket.socket()
        s.connect((HOST, PORT))
        s.send(str.encode(command))
        s.close()
        sys.exit(0)


if __name__ == '__main__':
    if len(sys.argv) > 1:
        if sys.argv[1] == 'start':
            Client().start_client('start')
        elif sys.argv[1] == 'stop':
            Client().start_client('stop')
    else:
        Pomodoro().write_output('')
        Server().start_server()
