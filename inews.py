#! /usr/bin/python

from sys import stdin
from nntplib import NNTP
from os import environ

s = NNTP(environ['NNTPSERVER'])
s.post(stdin)
s.quit()
