import re
import os
from robot.api.deco import keyword

def printft(a,b,ifile,ofile):
    """Read from line ``a`` to line ``b`` in the input ``ifile`` then write to output ``ofile``

    ``a,b`` : interger value, a must be smaller than b

    ``ifile, ofile`` URL like '/root/ect/sometext.txt

    """
    f = open(ifile,'r')
    track = 0
    with open(ofile, 'a+') as fi:
        while track < a:
            track = track + 1
            f.readline()
        while track < b:
            track = track + 1
            print(f.readline(),end='',file=fi)
        print ("-------------------------",file=fi)


def match_regex_item (_rg):
    f = open('/root/Bao/auto/ex1/result.txt','r+')
    for num, each in enumerate(f, 1):
        match = re.search(_rg,each)
        if match: print(each)

def match_regex_customer (ifile,ofile):
    """Find all customer's info in ``ifile``, then write to ``ofile``
    
    ``ifile, ofile``: URL like /root/ect/sometext.txt

    Need importing re library first.
    
    """
    f = open(ifile,'r')
    for num, line in enumerate(f, 0):  
        match = re.search(r'^Name\:[a-zA-Z0-9\s]+$',line)
        if match: 
            printft(num,num+7,ifile,ofile)

def verify_customer_output(ofile):
    """Verify the output ``ofile`` of ``List all customers`` function after adding some new customers. 

    Each customer should contain these info:

        ``Name``: non empty letter and space sequence 

        ``Address``: non empty letter and space sequence 

        ``Phone num``: non empty number sequence

        ``Id``: auto increment number, start from ``2023002``

        ``Order list``: number sequences

        ``Total spent``: float value

        ``Rank``: non empty letter sequence, default is ``Bronze``

    """
    file = open(ofile,'r')
    n=0
    for num, line in enumerate(file, 0):  
        match = re.search(r'^Name\:[a-zA-Z0-9\s]+$',line)
        if match:
            n=n+1
            match = re.search(r'^Name\:\s[a-zA-Z]+[a-zA-Z\s]+$',line)
            if not match: return "Fail at Name field - profile " + str(n) + "\nActual value: " + '\"' + line.strip() + '"' + "\nExpect value: non empty letter sequence"
            line = file.readline()
            match = re.search(r'^Address\:\s[a-zA-Z]+[a-zA-Z\s]+$',line)
            if not match: return "Fail at Address field - profile " + str(n) + "\nActual value: " + '\"' + line.strip() + '"' + "\nExpect value: non empty letter sequence"
            line = file.readline()
            match = re.search(r'^Phone num\:[0-9\s]+$',line)
            if not match: return "Fail at Phone field - profile " + str(n) + "\nActual value: " + '\"' + line.strip() + '"' + "\nExpect value: non empty number sequence"
            line = file.readline()
            match = re.search(r'^Id\:\s[0-9]+$',line)
            if not match: return "Fail at Id field - profile " + str(n) + "\nActual value: " + '\"' + line.strip() + '"' + "\nExpect value: non empty number sequence"
            line = file.readline()
            match = re.search(r'^Order list\:[0-9\s]|[\s]+$',line)
            if not match: return "Fail at Order-list field - profile " + str(n) + "\nActual value: " + line
            line = file.readline()
            match = re.search(r'^Total\sspent\:[0-9.\s]|[\s]+$',line)
            if not match: return "Fail at Total-spent field - profile " + str(n) + "\nActual value: " + '\"' + line.strip() + '"' + "\nExpect value: float"  
            line = file.readline()        
            match = re.search(r'^Rank\:[a-zA-Z\s]+$',line)
            if not match: return "Fail at Rank field - profile " + str(n) + "\nActual value: " + line
    return n


def empty_file(filename):
    """Clear content of ``filename`` 
    
    Parameter ``filename``: URL like "/root/etc/sometext.txt"

    """
    f = open(filename,'w')
    print('',end='',file=f)

def delete_file(filename):
    """Delete ``filename`` 
    
    Parameter ``filename``: URL like "/root/etc/sometext.txt"
    
    """
    os.remove(filename)

def verify_orderID_in_customer(filename,name):
    """Search for the Order's Assigned ID in ``file name`` after making an order. 
    Then search for ``Order list`` of the customer that have just made this order
    and verify that the ``Order's Assigned ID`` now has been in the customer's ``Order list``
    """
    f = open(filename,'r')
    Oline = ""
    Nline = ""
    for num, line in enumerate(f,0):
        assi = re.search(r'^Assigned order\'s ID\:\s[0-9]+$',line)
        if assi: Oline = line
    f.close()
    Oline = re.search(r'[0-9]+',Oline)
    Oline = Oline.group()
    f = open(filename,'r')
    thisreg = "Name: " + name
    for num, line in enumerate(f,0):
        thisname = re.search(thisreg,line)
        if thisname: 
            for i in range (0,3):
                f.readline()
            Nline = f.readline()
            match = re.search(Oline,Nline)
            if match: return "Found the new order ID in customer's order list"
    return 0





