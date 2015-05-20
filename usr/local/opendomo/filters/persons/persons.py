#!/bin/python
#desc: Detect a person
#package:opencvodos

### Copyright(c) 2015 OpenDomo Services SL. Licensed under GPL v3 or later
import numpy as np
import cv2
import ConfigParser
import subprocess
import sys

IDC=sys.argv[1]

# Read parameters or arguments
config = ConfigParser.ConfigParser()
config.read('/etc/opendomo/vision/' + IDC + '/filters/persons.conf')
confID = config.get('Definition', 'ID')
confNAME = config.get('Definition', 'NAME')

#Only developer 
#print confID
#print confNAME

def inside(r, q):
    rx, ry, rw, rh = r
    qx, qy, qw, qh = q
    return rx > qx and ry > qy and rx + rw < qx + qw and ry + rh < qy + qh
#detect persons
def draw_detections(img, rects, thickness = 1):
    for x, y, w, h in rects:
        pad_w, pad_h = int(0.15*w), int(0.05*h)
        cv2.rectangle(img, (x+pad_w, y+pad_h), (x+w-pad_w, y+h-pad_h), (0, 255, 0), thickness)
        
if __name__ == '__main__':
    import sys
    from glob import glob
    import itertools as it

    hog = cv2.HOGDescriptor()
    hog.setSVMDetector( cv2.HOGDescriptor_getDefaultPeopleDetector() )
    #load image
    img = cv2.imread('/var/www/data/' + confID + '.jpg')
    found, w = hog.detectMultiScale(img, winStride=(8,8), padding=(32,32), scale=1.05),0
    found_filtered = []
    for ri, r in enumerate(found):
	for qi, q in enumerate(found):
    		if ri != qi and inside(r, q):
    			break
    		else:
    			found_filtered.append(r)
    draw_detections(img, found)
    draw_detections(img, found_filtered, 3)
    # save log
    subprocess.call(["/usr/bin/logevent", "persons", "odvision", "Person detected in " + confID +  " /var/www/data/" + confID + "_persons.png"])
    # save output image
    cv2.imwrite('/var/www/data/' + confID + '_persons.png',img)
