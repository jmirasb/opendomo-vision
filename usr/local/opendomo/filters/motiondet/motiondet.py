#!/bin/python
#desc: Motion detection filter using an image
#package:opencvodos

### Copyright(c) 2014 OpenDomo Services SL. Licensed under GPL v3 or later

import sys
import cv2
import time
import ConfigParser
import numpy as np
import subprocess

IDC=sys.argv[1]

# Read parameters or arguments
config = ConfigParser.ConfigParser()
config.read('/etc/opendomo/vision/' + IDC + '/filters/motiondet.conf')
confID = config.get('Definition', 'ID')
confNAME = config.get('Definition', 'NAME')

#Only developer
#print confID
#print confNAME

# Load images
imga = cv2.imread('/var/www/data/' + confID + '.jpg')
imgb = cv2.imread('/var/www/data/prev_' + confID + '.jpg')

imgac = cv2.cvtColor(imga, cv2.COLOR_BGR2GRAY)
imgbc = cv2.cvtColor(imgb, cv2.COLOR_BGR2GRAY)

img1 = imgac[10:330, 10:870]
img2 = imgbc[10:320, 10:870]

#Only developer
# cv2.imwrite('/var/www/data/' + confID + '_motiondet.png',imgb)

start = time.clock()
#diff images, detect motion
d = cv2.absdiff(img1,img2)
s = d.sum()
t = time.clock() - start

#Only developer
#print 'absdiff ', t
#print s

if s != 0 :
  # save log
  subprocess.call(["/bin/logevent", "motiondet", "opencvodos", "Motion detected in " + confID +  " /var/www/data/" + confID + "_motiondet.png"])
  # save output image
  cv2.imwrite('/var/www/data/' + confID + '_motiondet.png',imgb)

#Only developer
start = time.clock()
s = cv2.norm(img1, img2, cv2.NORM_L1)
t = time.clock() - start

#Only developer
#print 'norm L1 ',  t
#print s
