from __future__ import print_function
import PIL
from PIL import Image
import os.path

alpha = {0: [' ',(0,0,0),'|'], 1: ['a',(1,0,0),'A'], 2: ['b',(2,0,0),'B'], 3: ['c',(3,0,0),'C'], 
4: ['d',(0,1,0),'D'], 5: ['e',(1,1,0),'E'], 6: ['f',(2,1,0),'F'], 7: ['g',(3,1,0),'G'], 
8: ['h',(0,2,0),'H'], 9: ['i',(1,2,0),'I'], 10: ['j',(2,2,0),'J'], 11: ['k',(3,2,0),'K'],
12: ['l',(0,3,0),'L'], 13: ['m',(1,3,0),'M'], 14: ['n',(2,3,0),'N'], 15: ['o',(3,3,0),'O'],
16: ['p',(0,0,1),'P'], 17: ['q',(1,0,1),'Q'], 18: ['r',(2,0,1),'R'], 19: ['s',(3,0,1),'S'], 
20: ['t',(0,1,1),'T'], 21: ['u',(1,1,1),'U'], 22: ['v',(2,1,1),'V'], 23: ['w',(3,1,1),'W'], 
24: ['x',(0,2,1),'X'], 25: ['y',(1,2,1),'Y'], 26: ['z',(2,2,1),'Z'], 27: ['.',(3,2,1),'>'],
28: [',',(0,3,1),'<'], 29: ['/',(1,3,1),'?'], 30: ['[',(2,3,1),']'], 31: ['1',(3,3,1),'!'], 
32: ['2',(0,0,2),'@'], 33: ['3',(1,0,2),'#'], 34: ['4',(2,0,2),'$'], 35: ['5',(3,0,2),'%'], 
36: ['6',(0,1,2),'^'], 37: ['7',(1,1,2),'&'], 38: ['8',(2,1,2),'*'], 39: ['9',(3,1,2),'('], 
40: ['0',(0,2,2),')'], 41: ['-',(1,2,2),'_'], 42: ['=',(2,2,2),'+'], 43: ['{',(3,2,2),'}'], 
44: [';',(0,3,2),':'], 45: ['"',(1,3,2),"'"], 46: ['4',(2,3,2),'$'], 47: ['5',(3,3,2),'%'], 
48: ['2',(0,0,3),'@'], 49: ['3',(1,0,3),'#'], 50: ['4',(2,0,3),'$'], 51: ['5',(3,0,3),'%'], 
52: ['2',(0,1,3),'@'], 53: ['3',(1,1,3),'#'], 54: ['4',(2,1,3),'$'], 55: ['5',(3,1,3),'%'], 
56: ['2',(0,2,3),'@'], 57: ['3',(1,2,3),'#'], 58: ['4',(2,2,3),'$'], 59: ['5',(3,2,3),'%'], 
60: ['2',(0,3,3),'@'], 61: ['|',(1,3,3),'|'], 62: ['~',(2,3,3),'|'], 63: ['`',(3,3,3),'|']}
'''
Updates for V1.7:
 Minor fixes, set to encode into pngs only to prevent data loss.
'''
def Opener(i):
    while 1 == 1:
        imgname = raw_input('')
        if (i == 1 and '.png' not in imgname):
            imgname = imgname + '.png'
        directory = os.path.dirname(os.path.abspath(__file__))  
        startimg_file = os.path.join(directory, imgname)
        try: 
            im = Image.open(startimg_file)
            return im,imgname
        except IOError:
            print('Image not found. Make sure to include the file extension.')
    
def Equilizer(im, x, y):
    R = im.getpixel((x, y))[0]
    G = im.getpixel((x, y))[1]
    B = im.getpixel((x, y))[2]
    if R%2 == 1:
        if ((R - 1)/2)%2 == 1:
            im.putpixel((x,y), (R-3,G,B))
            R -= 3
        else: 
            im.putpixel((x,y), (R-1,G,B))
            R -= 1
    elif (R/2)%2 == 1:
        im.putpixel((x,y), (R-2,G,B))
        R -= 2
    else:
        im.putpixel((x,y), (R,G,B))
    if G%2 == 1:
        if ((G - 1)/2)%2 == 1:
            im.putpixel((x,y), (R,G-3,B))
            G -= 3
        else: 
            im.putpixel((x,y), (R,G-1,B))
            G -= 1
    elif (G/2)%2 == 1:
        im.putpixel((x,y), (R,G-2,B))
        G -= 2
    else:
        im.putpixel((x,y), (R,G,B))
    if B%2 == 1:
        if ((B - 1)/2)%2 == 1:
            im.putpixel((x,y), (R,G,B-3))
            B -= 3
        else: 
            im.putpixel((x,y), (R,G,B-1))
            B -= 1
    elif (B/2)%2 == 1:
        im.putpixel((x,y), (R,G,B-2))
        B -= 2
    else:
        im.putpixel((x,y), (R,G,B))
    return (R,G,B)

def Encoder():
    noms = False
    print('Type the full name of the image you wish encode your message to and',
          ' its file extension:',sep='')
    im, imgname = Opener(0)
    width, height = im.size
    message = raw_input('Type the message you wish to encode (Do not include "`" or "~"): \n')
    message = message + '~ '
    mslen = len(message) #needed spots, message length
    print('Encoding ',mslen-1,' byte (',(mslen-1)*6,' bits) message to ',
    imgname,'... \n', sep='')
    skipone = False
    n = 0
    die = False
    for y in range(height): # vertical coords
        if die == True:
            break
        if y == height-1:
            print('Message is too big for image, try a bigger image.')
            noms = True
            break
        for x in range(width): # horizontal coords
            R = Equilizer(im, x, y)[0]
            G = Equilizer(im, x, y)[1]
            B = Equilizer(im, x, y)[2]
            if skipone == True:
                im.putpixel((x,y), (R+3,G+3,B+3))
                skipone = False
                pass
            else:
                for e in alpha.iteritems():
                    r = e[1][1][0]
                    g = e[1][1][1]
                    b = e[1][1][2]
                    if e[1][0] == message[n]: #if letter is letter
                        im.putpixel((x,y), (R+r,G+g,B+b))
                    elif e[1][2] == message[n]:
                        im.putpixel((x,y), (R+r,G+g,B+b))
                        skipone = True
                if n < mslen-1: 
                    n += 1
                else:
                    die = True
                    break
    if noms == False:
        print('Done. What would you like to save the new image as? ',
              '(Image will be saved as a .png, file extension is included for you)', sep='')
        while 1 == 1:
            newname = raw_input('')
            if (len(newname) > 0):
                try:
                    if '.png' not in newname:
                        newname = newname + '.png'
                    im.save(newname)
                    break
                except KeyError:
                    print('File name not valid.')
            print('File must have a name.')
        if newname == imgname:
            print('Image encoded.\n')
        else:
            print('Image created.\n')
    again = raw_input('Encode or decode another image? (Yes or No)\n')
    if 'Y' in again.upper():
        ScribeStartUp()
################################################################################
def DeFunc(c):
    if c%2 == 1:
        if ((c - 1)/2)%2 == 1:
            D1 = D2 = 1
        else: 
            D1 = 1
            D2 = 0
    elif (c/2)%2 == 1:
        D1 = 0
        D2 = 1
    else:
        D1 = D2 = 0
    return(D1,D2)
    
def Decode(im,x,y):
    total = 0
    R = im.getpixel((x, y))[0]
    G = im.getpixel((x, y))[1]
    B = im.getpixel((x, y))[2]
    if DeFunc(R)[0] == 1:
        total += 1
    if DeFunc(R)[1] == 1:
        total += 2
    if DeFunc(G)[0] == 1:
        total += 4
    if DeFunc(G)[1] == 1:
        total += 8
    if DeFunc(B)[0] == 1:
        total += 16
    if DeFunc(B)[1] == 1:
        total += 32
    return(total)

def Decoder():
    noms = False
    print('Type the name of the image you wish to decode, should be a .png file, extension included for you.')
    im, imgname = Opener(1)
    print('Decoding message from ',imgname,'...', sep='')
    width, height = im.size
    msr = ''
    die = False
    for y in range(height): # vertical coords to read
        if die == True:
            break
        if y == height-1:
            print('Image was never encoded.')
            noms = True
            break
        Y = 0
        for x in range(width): # horizontal coords to read
            charnum = Decode(im,x,y)
            X = 1
            if x == width-1:
                Y = 1
                X = -(height-1)
            elif charnum == 62:
                msr += ' <END>'
                die = True
                break
            charnxt = Decode(im,x+X,y+Y)
            for e in alpha.iteritems():
                if e[0] == charnum:
                    if 63 == charnxt:
                        msr += e[1][2]
                    else:
                        msr += e[1][0]
    nmsr = ''           # I spent so long working on fixing this bug 
    for a in msr:       # and this is what I came up with.
        if a == '`':    # I think.
            nmsr += ''  # I don't want to eff it up again it was a cyka to fix.
        else:           # So yeah,
            nmsr += a   # Basically,
    msr = nmsr          # I fixed a bug with dis.
    if noms == False:
        print("Done. Printing message...\n")
        print('<BEGIN> ',msr,'\n',sep='')
    again = raw_input('Encode or decode another image? (Yes or no)\n')
    if 'Y' in again.upper():
        ScribeStartUp()
################################################################################
def ScribeStartUp():
    print('Would you like to decode or encode an image?\n',
          'Press 1 to start the encoder.\n Press 2 to start the decoder.')
    EoD = raw_input('')
    if '1' in EoD:
        print('Booting Encoder...')
        Encoder()
    elif '2' in EoD:
        print('Booting Decoder...')
        Decoder()
    else:
        print('Please choose 1 or 2.')
        ScribeStartUp()
print('EnScribe - coded by Noah Boursier')
ScribeStartUp()