# -*- coding: utf-8 -*-
import os.path
import uuid

import tornado.escape
from tornado import ioloop
from tornado.httpserver import HTTPServer
from tornado.options import define, options
from tornado.web import RequestHandler, Application

define('port', default=80, help='input port', type=int)
define('debug', default=False, help='debug mode')

class HealthCheckHandler(RequestHandler):

    def __init__(self,*args,**kwargs):
        super().__init__(*args,**kwargs)

    def get(self):
        self.write(f'[AppID:{self.application.id}] Service running')

class MainHandler(RequestHandler):

    def __init__(self,*args,**kwargs):
        super().__init__(*args,**kwargs)

    def get(self):
        self.write(f'[AppID:{self.application.id}] Hello, world')

class App(Application):

    def __init__(self):
        handlers = [
            (r'/', HealthCheckHandler),
            (r'/hello', MainHandler),
        ]
        settings = {
            'template_path':os.path.join(os.path.dirname(__file__), 'templates'),
            'static_path': os.path.join(os.path.dirname(__file__), 'static'),
            'debug':options.debug
        }
        self.id=uuid.uuid1().hex
        super().__init__(handlers, **settings)

if __name__ == '__main__':
    tornado.options.parse_command_line()
    http_server = HTTPServer(App())
    http_server.listen(options.port)
    ioloop.IOLoop.current().start()