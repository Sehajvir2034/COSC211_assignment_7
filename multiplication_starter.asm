# (s1,s0): 64-bit product (s1: prodLeft, s0 prodRight)
# t0: 32-bit multiplier
# t1: 32-bit multiplicand

# Algorithm:
# Product(left_half) = 0, product(right_half) = multiplier
# for 32 iteration {	
# if (product[0] == 1)	//if(multiplier[0] == 1)
#   left-half of product += multiplicand
# shift-right product by 1
# }

# I am priniting the result just to make sure the algorithm is error free and produces correct output
.data
result: .asciiz "The result is: "
.text
main:	
  
  	#assume any values for multiplier and multiplicand
	addi $t0, $0, 2034	# multiplicand
	addi $t1, $0, 2426	# multiplier
	
	# set prodLeft, prodRight and another var for 64 bits space
	addi $s0, $0, 0		# prodLeft
	addi $s1, $0, 0		# prodRight		
	addi $s2, $0, 0		# 64 bits space for multiplicand
						

# Multiplication algorithm starts here

for_loop:	
		
		andi $t2, $t0, 1	# get the most significant bit (leftmost bit)
		
		beq $t2, $0, skip	# if multiplicand[0] = 0 skip 
		
		addu $s0, $s0, $t1	# left-half of product += multiplicand
		sltu $t2, $s0, $t1  	# if there is a carry on when we add to the product, store the carry on in t2 (0/1)
		
    		addu $s1, $s1, $t2  	# add the carry on to the the product 
    		addu $s1, $s1, $s2	# add the multiplicand to the product
   
skip:		
		srl $t2, $t1, 31	# copy the least-significant-bit (LSB) of $t1 to the MSB of $t2
		sll $t1, $t1, 1		# shift left the t1 by 1 bit
		sll $s2, $s2, 1		# shift left the s2 by 1 bit
		
		srl $t0, $t0 ,1 	# shift-right the right-half $t0 by 1 bit
		bne $t0, $0, for_loop 	# loop back to the for loop for another iteration (total 32 iterations)	   		  
		

print:
    		
    		li  $v0, 4           	# print_str system code
    		la  $a0, result      	# load adrs of result
    		syscall             	# system call to print

    		li  $v0, 1           	# print_int system code
    		addi $a0, $s1, 0     	# put result in $a0
    		syscall             	# system call to print
    		
    		li  $v0,1           	# print_int system code
    		addi $a0, $s0, 0     	# put result in $a0
    		syscall             	# system call to print
					
