#!/bin/env python

import os,sys,threading,time
from sys import stdin,stdout,version_info
from multiprocessing.pool import ThreadPool

class ProgressBar(object):
	def __init__(self, total, progressChar=None):
		self.total = total
		self.blockcount = 0
		self.block = '';
		#
		# See if caller passed me a character to use on the
		# progress bar (like "*").  If not use the block
		# character that makes it look like a real progress
		# bar.
		#
		if not progressChar: 
			self.progressChar = chr(178)
		else:                
			self.progressChar = progressChar
		#
		# Get pointer to sys.stdout so I can use the write/flush
		# methods to display the progress bar.
		#
		self.buf = stdout
		#
		# If the final count is zero, don't start the progress gauge
		#
		if not self.total : 
			print("[Total Count] must be greater than zero")
			return
		self.buf.write('\n------------------- % Progress -------------------\n')
		return
 
	def progress(self, count):

		count = min(count, self.total)

		if self.total:
			percent = int(round(100*count/self.total))
			if percent < 1: percent=0
		else:
			percent=100
			
		blockcount = int(percent/2)

		if blockcount > self.blockcount:
			self.block += self.progressChar
		self.buf.write(self.block + str(percent) + "%\r")
		self.buf.flush()
		self.blockcount = blockcount
		return

class TaskManager(object):
	def __init__(self, processes):
		self.pool = ThreadPool(processes=processes)
		self.workers = threading.Semaphore(processes)
		self.counter = 0
		self.sizes = 0
		self.total = 0
		self.progress_line = 0
		self.progress_bar = ''

	def new(self,task, arg):
		self.workers.acquire()
		self.sizes += 1
		self.pool.apply_async(task, args=(arg, ), callback=self.done)

	def done(self, args):
		self.workers.release()
		self.sizes -= 1
		self.setCount(1)

	def setTotal(self,total):
		self.total = total
		return self
	
	def getTotal(self):
		return self.total
	
	def setCount(self,num):
		self.counter += num
		return self
		
	def getCount(self):
		return self.counter
	#
	# The progress() of the outdated abandoned
	# Using the ProgressBar showed the progress bar 
	# Example: 
	#	progressBar = ProgressBar(100,"#")
	#	for i in range(0,99):
	#		progressBar.progress(i)
	def progress(self):
		if self.getCount() != 0:
			self.percent = int((float(self.getCount())/(self.getTotal()-1))*100)
			blockcount = int(self.percent/2)

			if blockcount > self.progress_line:
				self.progress_bar += '#'
			self.progress_line = blockcount
			
		log = str((self.getTotal()))+'||'+str(self.getCount())
		log += '||'+self.progress_bar+'->||'+str(self.progress_line)+"%\r"
		stdout.write(log)
		stdout.flush()
		return

	def size(self):
		return self.sizes

	def __len__(self):
		return self.sizes
		
class Spider(TaskManager):
	def __init__(self,filename,poolsize,total):
		self.fd = open(filename,"a+")
		super(Spider,self).__init__(poolsize)
		self.progressBar = ProgressBar(total,"\033[0;33;43m \033[0m")
	
	def start(self):
		for line in self.fd:
			self.new(self.run,line)
			
	def run(self,args):
		try:
			os.system("/bin/bash script.sh "+args)
			self.progressBar.progress(self.getCount())
		except Exception as e:
			print("Exception:\t"+str(e))
			return None
			
if __name__ == '__main__':		
	if len(sys.argv) < 4:
		print(sys.argv[0] + ' [FILE] [Process Count] [Total Count] [Time Out]')
		sys.exit(0)
	spider = None
	try:	
		poolsize = int(sys.argv[2])
		total = int(sys.argv[3])
		if poolsize <= 0 and total <= 0:
			print(sys.argv[0] + '[Process Count] and [Total Count] must be greater than zero,')
			sys.exit(0)
		filename = sys.argv[1]
		if os.path.exists(filename):
			spider = Spider(filename,poolsize,total-1)
			spider.setTotal(total)
			spider.start()
	except KeyboardInterrupt:
		pass

	while True:
		#print(spider)
		sleep_time = float(sys.argv[4])
		time.sleep(sleep_time)
		if spider.getCount() == total and spider.size() == 0:
			print("\nTotal:\t"+str(total))
			break
