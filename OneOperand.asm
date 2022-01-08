# all numbers in hex format
# we always start by reset signal
# this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
A0
#you should ignore empty lines

.ORG 2  #this is empty stack exception handler address
100

.ORG 4  #this is invalid address exception handler address
150

.ORG 6  #this is int 0
200

.ORG 8  #this is int 2
250

.ORG A0
NOT r0          
INT 0
and r0,r1,r2       