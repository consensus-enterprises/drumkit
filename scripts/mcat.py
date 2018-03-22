#!/usr/bin/python

# Minimalist CLI Matrix client.
# Ref.: https://fort.kickass.systems/git/rrix/matrix-cat/src/master

from __future__ import print_function

import argparse
import json
import os
import sys
import time

import yaml
from matrix_client.client import MatrixClient


class MCat:
    def __init__(self, config):
        self.client = MatrixClient(config['server'])
        self.token = self.client.login_with_password(username=config['user'],
                                                     password=config['password'])
        self.room = self.client.join_room(config['room'])
        self.room_id = config['room']
        self.message_queue = []
        self.limited_until = None

    def dequeue(self):
        """Dequeue as many messages as the server lets us"""
        for message in self.message_queue:
            if time.time() * 1000 < self.limited_until:
                return

            try:
                self.room.send_html(message)
                self.message_queue.pop(0)
            except Exception as e:
                necessary_delay = json.loads(e.content)['retry_after_ms']
                sys.stderr.write("Sleeping for %s seconds... Queue depth %s\n" % (necessary_delay, len(self.message_queue)))
                sys.stderr.flush()
                self.limited_until = time.time() * 1000 + necessary_delay

    def enqueue(self, message):
        self.message_queue.append(message)

    def f_to_matrix(self, f):
        for line in f:
            self.enqueue(line)
            self.dequeue()
        while len(self.message_queue) > 0:
            self.dequeue()

    def matrix_to_f(self, f):
        def stdout_cb(chunk):
            if chunk[u'type'] != u"m.presence" and chunk[u'room_id'] == self.room_id:
                f.write(json.dumps(chunk))
                f.write('\n')
                f.flush()
        self.client.add_listener(stdout_cb)
        self.client.listen_forever()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Pipe in to and out of a Matrix room")
    parser.add_argument('--room', '-r',
                        default=os.environ.get('MATRIX_ROOM'),
                        help='The room to pipe to or from. (MATRIX_ROOM)')
    parser.add_argument('--server', '-s',
                        default=os.environ.get('MATRIX_SERVER', 'https://matrix.org'),
                        help='The server to connect to. (MATRIX_SERVER)')
    parser.add_argument('--user', '-u',
                        default=os.environ.get('MATRIX_USER'),
                        help='The account to connect as. (MATRIX_USER)')
    parser.add_argument('--password', '-p',
                        default=os.environ.get('MATRIX_PASSWORD'),
                        help='The account password (MATRIX_PASSWORD)')
    parser.add_argument('--stdin', '-i',
                        action='store_const',
                        const=True,
                        help="Pipe stdin to a room")
    parser.add_argument('--stdout', '-o',
                        action='store_const',
                        const=True,
                        help="Pipe a room to stdout")
    args = parser.parse_args()
    if args.room is None:
        print("The '--room' argument (or MATRIX_ROOM environment variable) is required")
        sys.exit(1)
    if args.user is None:
        print("The '--user' argument (or MATRIX_USER environment variable) is required")
        sys.exit(1)
    if args.password is None:
        print("The '--password' argument (or MATRIX_PASSWORD environment variable) is required")
        sys.exit(1)
    config = {}
    config['user'] = args.user
    config['password'] = args.password
    config['server'] = args.server
    config['room'] = args.room
    mcat = MCat(config)
    if args.stdin and args.stdout:
        print("Cowardly refusing to create a in/out loop. Use only one.")
        sys.exit(1)
    elif args.stdin:
        mcat.f_to_matrix(sys.stdin)
    elif args.stdout:
        mcat.matrix_to_f(sys.stdout)
