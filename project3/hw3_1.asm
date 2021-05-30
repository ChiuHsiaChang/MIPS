.data
	prompt  : .asciiz "Enter the number n : "
	pro   	: .asciiz "Enter the number r : "
	t   	: .asciiz " "
	pn 	: .asciiz "\nThe value of n is "
	pr 	: .asciiz "\nThe value of r is "
	pnCr	: .asciiz "\nThe value of nCr is "

.text
.globl main
main:
	move $fp , $sp
	subu $sp , $sp , 8
	
	la $a0 , prompt
	li $v0 , 4
	syscall
	
	li $v0 , 5
	syscall
	sw $v0 , 4($sp)

	la $a0 , pro
	li $v0 , 4
	syscall
	
	li $v0 , 5
	syscall
	sw $v0 , 0($sp)

	lw $a0 , 4($sp)
	lw $a1 , 0($sp)
	jal fact
	subu $sp , $sp , 4
	sw $v0 , 0($sp)

	la $a0 , pn
	li $v0 , 4
	syscall
	
	li $v0 , 1
	lw $a0 , 8($sp)
	syscall

	la $a0 , pr
	li $v0 , 4
	syscall
	
	li $v0 , 1
	lw $a0 , 4($sp)
	syscall

	la $a0 , pnCr
	li $v0 , 4
	syscall
	
	li $v0 , 1
	lw $a0 , 0($sp)
	syscall

	li $v0 , 10
	syscall

fact:
	beq $a0 , $a1 , factbase #if n==k,return 1
	beqz $a1 , factbase	#if k==0,return 1
	
	subu $sp , $sp , 12 #allocate stack for 3 items
	sw $ra , 8($sp) # save the return address
	sw $a0 , 4($sp) # save the argument n
	sw $a1 , 0($sp) # save the argument k
	
	 
	subu $a0 , $a0 , 1 # n=n-1
	jal fact #fun(n-1,k)
	
	subu $sp , $sp , 4 #adjust pointer
	sw $v0 , 0($sp) # save v0
	lw $a0 , 8($sp) # store n
	subu $a0 , $a0 , 1 #n--
	lw $a1 , 4($sp) # store k
	subu $a1 , $a1 , 1 #k--
	jal fact #fun(n-1,k-1) 
	
	lw $t3 , 0($sp)
	addu $v0 , $v0 , $t3 #return fun(n-1,k)+fun(n-1,k-1)
	lw $ra , 12($sp) #restore address
	addu $sp , $sp , 16 #adjust pointer
	jr $ra	#return to caller

factbase:
	li $v0 , 1
	jr $ra