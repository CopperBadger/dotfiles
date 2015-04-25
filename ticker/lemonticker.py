# Lemonticker, simple desktop RSS feeder
# by Copper Badger
# ---
# Set RSS feed names and URLs in .ticker.conf,
# read ticker.log in three cut-able columns
# (feed name, item title, and URL).
# ---
# Uncomment line in notify method to automtically
# send new feed items to your notification manager

from html.parser import HTMLParser
import email.utils
from urllib.request import urlopen,HTTPError
import time,sys,os,re
from datetime import datetime
from subprocess import call
from queue import PriorityQueue

now = time.time()
urlpat=re.compile("^url=")

class TickerManager():
	"""docstring for TickerManager"""
	def __init__(self):
		super(TickerManager, self).__init__()
		self.readers = {}
		self.channels = {}
		self.cache = PriorityQueue()
		self.daemonChannel = {"title":"DAEMON"}
		self.notify(self.daemonChannel,{"title":"Starting up..."})

	def addChannel(self, url, profile):
		if url in self.channels:
			print("[Warning] Duplicate URL:",url)
			return 0
		if profile['src_type'] not in self.readers:
			r = self.readers[profile['src_type']] = getReader(profile['src_type'])(self)
			if r == None:
				print("[Warning] No reader found for type \"",profile.src_type,"\"")
		r = self.readers[profile['src_type']]
		if r == None:
			return 0
		else:
			self.channels[url]=profile

	def notify(self, channel, item):
		d = c = i = l = ""
		if 'timestamp' in item:
			d = datetime.fromtimestamp(item['timestamp'])
		if 'title' in channel:
			c = channel['title']
		else:
			c = "<Unknown Channel>"

		if 'title' in item:
			i = item['title']
		else:
			i = "<Untitled>"

		if 'link' in item:
			l = item['link']
		else:
			l = ""
		msg = "[ {0} ]\t{1}\t{2}".format(c,i,l)
		print(msg)
		# call(["notify-send",msg])
		logfile = open('ticker.log','a')
		logfile.write(msg+os.linesep)
		logfile.close()

	def serve(self):
		while True:
			print("[Info] Checking",len(self.channels),"channels...")
			for c in self.channels:
				c = self.channels[c]
				reader = self.readers[c['src_type']]
				if c['latest'] == 0:
					# self.notify(self.daemonChannel,{"title":"Attempting to initialize [ {0} ]".format(c['title'])})
					reader.initChannel(c,self.cache)
				else:
					reader.readChannel(c)
			if self.cache:
				idx = 15
				lst = []
				while not self.cache.empty() and idx > 0:
					lst.append(self.cache.get())
					idx -= 1
				lst.reverse()
				for l in lst:
					self.notify(l[1],l[2])
				self.cache = None
			time.sleep(30)

class RSSReader(HTMLParser):
	"""docstring for RSSReader"""

	def __init__(self, manager):
		super(RSSReader, self).__init__()
		self.src_type = SRC_TYPE_RSS
		self.itemFlag = False
		self.tagName = None
		self.channel = None
		self.item = {}
		self.pushItem = False
		self.initStage = False
		self.newest = 0
		self.manager = manager
		self.cache = None

	def readChannel(self, channel):
		self.channel = channel
		src = None
		try:
			src = urlopen(channel['url'],timeout=2).read().decode('utf-8')
		except HTTPError as httpe:
			print("[Info] |",channel['title'],'HTTP error, skipping:',httpe)
		except KeyboardInterrupt:
			print("[Info] | (Keyboard Interrupt; exiting)")
			exit(0)
		except:
			print("[Info] |",channel['title'],'Unknown error, skipping:',sys.exc_info()[0])
			return 0
		if src:
			self.feed(src)
		self.channel['latest'] = self.newest

	def initChannel(self, channel, cache=None):
		self.initStage = True
		self.cache = cache
		self.readChannel(channel)
		self.cache = None
		self.initStage = False
		if channel['latest'] > 0:
			print("[Info] Channel",channel['title'],"initialized, latest:",datetime.fromtimestamp(self.channel['latest']))

	def handle_starttag(self, tag, attrs):
		self.tagName = tag
		if tag == "item":
			self.item = {}
			self.itemFlag = True

	def handle_endtag(self, tag):
		self.tagName = None
		if tag == "item":
			self.itemFlag = False
			if self.initStage and not self.cache == None:
				t = now-self.item['timestamp']
				self.cache.put((t,self.channel,self.item))
			if self.pushItem:
				if not self.initStage:
					self.pushItem = False
					self.manager.notify(self.channel,self.item)

	def handle_data(self, data):
		if self.itemFlag:
			if self.tagName == "title":
				self.item['title'] = data
			if self.tagName == "link":
				self.item['link'] = urlpat.sub("",data)
			if self.tagName == "pubdate":
				t = time.mktime(email.utils.parsedate(data))
				self.item['timestamp'] = t
				if t > self.channel['latest']:
					self.pushItem = True
				if self.newest == None or t > self.newest:
					self.newest = t






SRC_TYPE_RSS = "rss"
readerLookup = {
	SRC_TYPE_RSS: RSSReader
}
def getReader(src_type):
	if src_type in readerLookup:
		return readerLookup[src_type]
	else:
		return None

# Set up manager and read channels
manager = TickerManager();
conf = open('.ticker.conf','r')
for l in conf:
	k = l.split('\t')
	manager.addChannel(k[1],{
		'url': k[1],
		'title': k[0],
		'src_type': SRC_TYPE_RSS,
		'latest': 0
	})
conf.close()
manager.serve()
