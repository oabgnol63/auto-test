import re
import os


def printft(a,b,file):
    f = open('/root/Bao/auto/ex1/result2.txt','r')
    track = 0
    with open(file, 'a+') as fi:
        while track < a:
            track = track + 1
            f.readline()
        while track < b:
            track = track + 1
            print(f.readline(),file=fi)
        print ("-------------------------\n",file=fi)


def match_regex_item (_rg):
    f = open('/root/Bao/auto/ex1/result.txt','r+')
    for num, each in enumerate(f, 1):
        match = re.search(_rg,each)
        if match: print(each)

#match_regex_item(r'^Item_no_.\s+.+$')

def match_regex_customer (_rg,ifile,ofile):
    f = open(ifile,'r')
    for num, line in enumerate(f, 0):  
        match = re.search(_rg,line)
        if match: 
            printft(num,num+7,ofile)

def delete_file(filename):
    os.remove(filename)

# match_regex_customer(r'^Name\:[a-zA-Z\s]+$','/root/Bao/auto/ex1/result2.txt','/root/Bao/auto/ex1/conv.txt')


def write_into_file(strg,_file):
    f = open(_file,'a')
    print(strg,file=f)
    printft(0,10,_file)