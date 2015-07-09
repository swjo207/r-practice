#! /usr/bin/python2.7
# -*- coding: utf-8 -*-

import sys
import csv, codecs, cStringIO, csvutils
from time import time

from konlpy import tag
from konlpy.utils import csvwrite, pprint

reload(sys)
sys.setdefaultencoding('utf-8')
r1 = []
r2 = []

def tagging(tagger, text):

    try:
        r1 = getattr(tag, tagger)().pos(text[1])
        r2 = getattr(tag, tagger)().pos(text[2])		
    except Exception as e:
        print "Uhoh,", e
    return r1+r2

def measure_accuracy(taggers, text):
    result = []
	
    for tagger in taggers:
        r = tagging(tagger, text)
        result.append(map(lambda s: ':'.join(s), r))
	
    
    f = codecs.open('/data/result/itfind_analysis_report_result.csv','a','utf-8')
    
    for i in range(len(text)):
        if i==0:
            print ("row : "+'\t'+text[i])
        data = text[i]+','
        f.write(data)
    for i in range(len(result)):
        csvutils.UnicodeWriter(f).writerow(result[i])
    
    
    titleFile = codecs.open('/data/result/itfind_analysis_report_title_result.csv','a','utf-8')
    
    for i in range(len(text)):
        if i==0:
            data = text[i]+','
            titleFile.write(data)
    csvutils.UnicodeWriter(titleFile).writerow(map(lambda s: ':'.join(s), getattr(tag, tagger)().pos(text[1])))

    abstractsFile = codecs.open('/data/result/itfind_analysis_report_abstracts_result.csv','a','utf-8')
    
    for i in range(len(text)):
        if i==0:
            data = text[i]+','
            abstractsFile.write(data)
    csvutils.UnicodeWriter(abstractsFile).writerow(map(lambda s: ':'.join(s), getattr(tag, tagger)().pos(text[2])))

    return result
	
if __name__=='__main__':
	contents = []
	with open('/data/a.txt', 'r') as f:
		contents = f.readlines()

	taggers = ['Twitter']
	cnt = 0	
	for content in contents:                
		data = content.rstrip('\r\n').decode('utf-8').split('\t')
		measure_accuracy(taggers,data)
        cnt += 1
        print ('row : '+str(cnt))