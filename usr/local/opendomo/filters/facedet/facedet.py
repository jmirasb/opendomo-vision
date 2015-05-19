#!/bin/python
#desc: Face detection filter using an image
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
config.read('/etc/opendomo/vision/' + IDC + '/filters/facedet.conf')
confID = config.get('Definition', 'ID')
confNAME = config.get('Definition', 'NAME')

#Only developer
#print confID
#print confNAME

# File cascade
faceCascade = cv2.CascadeClassifier('/usr/local/opendomo/filters/facedet/haarcascade_frontalface_default.xml')

# Load image
img = cv2.imread('/var/www/data/' + confID + '.jpg')

imgc = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

#Detect faces
faces = faceCascade.detectMultiScale(
    imgc,
    scaleFactor=1.1,
    minNeighbors=5,
    minSize=(20, 20),
    flags = cv2.cv.CV_HAAR_SCALE_IMAGE
)

# Rectangle
for (x, y, w, h) in faces:
    cv2.rectangle(img, (x, y), (x+w, y+h), (0, 255, 0), 2)
# save log
subprocess.call(["/usr/bin/logevent", "facedet", "opencvodos", "detection of faces in " + confID +  " /var/www/data/" + confID + "_facedet.png"])
#save output image
cv2.imwrite('/var/www/data/' + confID + '_facedet.png',img)
