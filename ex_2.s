# Liang Ji Zhu 100495723
# Javier Diez Arredondo 100495833
# Practice 1: Assembly Programming
# Exercise 2

# def power(x, n):
#     result = 1
#     while n > 0:
#         result *= x
#         n -= 1
#     return result


# def factorial(n):
#     result = 1
#     while n > 1:
#         result *= n
#         n -= 1
#     return result


# def sine_calculation(x):
#     sine = x
#     error = x
#     n = 1
#     while abs(error) > 0.001:
#         error = power(-1, n) * power(x, 2 * n + 1) / factorial(2 * n + 1)
#         sine += error
#         n += 1
#     return sine

.data
    # example:
    .align 2
	matrix_a: .float 1.0 2.0 1.57
			  		 2.0 0.0 3.14
               		 3.14 -1.0 1.0
	.align 3
    matrix_b: .float 0.0 0.0 0.0
    		    	 0.0 0.0 0.0
                     0.0 0.0 0.0
  	n: .word 3
    m: .word 3
.text
	main:
        jal ra sin_matrix
        
        # Exit
        li a7 10
        ecall
        
# i = 0
#     while i < N:
#         j = 0
#         while j < M:
#             B[i][j] = math.sin(A[i][j])
#             j += 1
#         i += 1
sin_matrix:
		# we push into the stack to use the fs registers adding -32 bits
		addi sp sp -32
        sw s0 0(sp)
		sw s1 4(sp)
		sw s2 8(sp)
		sw s3 12(sp)
		sw s4 16(sp)
        sw s5 20(sp)
		sw s6 24(sp)
        sw ra 28(sp)
        
        # load the adress of n (number of rows) to t0
        la t0 n
        # store its value to s5
        lw s5 0(t0)
        # load the adress of m (number of rows) to t1
        la t1 m
        # store its value to s6
        lw s6 0(t1)
        
		# initialize a segment of x*y bytes, and use x*i+j for arr[i][j]
		# a2 = N number of rows # a3 = M number of cols
        # t0 = i = 0
        li s0 0
        
        # t1 = j = 0
        li s1 0
        
        # t2 = element = 0
        li s2 0

        # t3 = 4
        li s3 4

        # if i > N -> end
        sin_matrix_row_while:
                bge s0 s5 sin_matrix_row_end
				
                # t1 = j = 0 # reset for new col
                li s1 0

                # if j > M -> end
                sin_matrix_col_while:
                        bge s1 s6 sin_matrix_col_end
                        
                        # B[2][2] -> init_address + (i * m + j) * 4 -> # 0 + (2 * 3 + 2) * 4
                        # mat[1][0] -> # 0 + (1 * 3 + 0) * 4
                        # 36 bits 3 * 3
                        
                        # t4 = i * m
                        mul s4, s0 s6
                        # t4 += j
                        add s4, s4 s1
                        # t4 *= 4
                        mul s4, s4 s3
                        
                        # load the adress of matrix_A at position s4 -> A[i][j]
                        flw fa0 matrix_a(s4)
                        
                        # run sine(A[i][j])
                        jal ra sin
                        
                        # store its value at B[i][j]
                        fsw fa0 matrix_b(s4)
                        
						# j += 1
                        addi s1 s1 1
                        
                        # loop
                        j sin_matrix_col_while
				
                # finish with the cols at cols so we go to the next row adding 1 to s0
                sin_matrix_col_end:
                		# i += 1
                        addi s0 s0 1
                        
                        # loop
                        j sin_matrix_row_while
                        
			# finish with all the rows so we go to main as we don't need to return anything, matrix_b has been updated
            sin_matrix_row_end:
            		# we pop out of the stack after using the fs registers adding 32 bits
            		lw s0 0(sp)
					lw s1 4(sp)
					lw s2 8(sp)
					lw s3 12(sp)
					lw s4 16(sp)					
                    lw s5 20(sp)
					lw s6 24(sp)
            		lw ra 28(sp)
                    addi sp sp 32
                    
					# go to main
                    jr ra



# def sine_calculation(x):
#     sine = x
#     error = x
#     n = 1
#     while abs(error) > 0.001:
#         error = power(-1, n) * power(x, 2 * n + 1) / factorial(2 * n + 1)
#         sine += error
#         n += 1
#     return sine
sin:
		# we push into the stack to use the fs registers adding -32 bits
		addi sp sp -32
		fsw fs0 0(sp)
		fsw fs1 4(sp)
		fsw fs2 8(sp)
		fsw fs3 12(sp)
		fsw fs4 16(sp)
		sw s0 20(sp)
		sw s1 24(sp)
		sw ra 28(sp)
        
        # fs0 = sine = x
		fmv.s fs0 fa0
        
        # fs1 = error = x
        fmv.s fs1 fa0

		# fs2 = x # for backup
        fmv.s fs2 fa0

        # s1 = 1 int -> float # fa1 = fa6 = n = 1
        li s1 1
        fcvt.s.w fa6 s1
        fmv.s fa1 fa6
        
        # fs3 = 0.001
        li s1 10
        fcvt.s.w ft0 s1
        fdiv.s fs3, fa1 ft0
        fdiv.s fs3, fs3 ft0
        fdiv.s fs3, fs3 ft0
        
        # fs1 = abs(error)
        fabs.s fs1 fs1
        
        # if 0.001 <= error -> s0 = 1
        flt.s s0 fs3 fs1
        
        # if s1 == 0 == s0 -> end
        sine_while:
        			beq s0 zero sine_end
                    # fa0 = x
                    fmv.s fa0 fs2
                    # fa0 = x # fa1 = n
                    # run function -> error = power(-1, n) * power(x, 2 * n + 1) / factorial(2 * n + 1)
                    jal ra sine_error
                    
                    # fs1 = error
                    fmv.s fs1 fa0
                    
                    # sine += error
                    fadd.s fs0, fs0 fs1
                    
                    # n += 1
                    fadd.s fa1, fa1 fa6
                    
					# fs4 = abs(error)
                    fabs.s fs4 fs1
					
                    # if 0.001 <= abs(error) -> s0 = 0
        			flt.s s0 fs3 fs4
					
                    # loop
                    j sine_while
		
        # return sine(x)
		sine_end:	
        			# copy its value to fa0
        			fmv.s fa0 fs0
                    
                    # we pop out of the stack after using the fs registers adding 32 bits
					flw fs0 0(sp)
					flw fs1 4(sp)
					flw fs2 8(sp)
					flw fs3 12(sp)
					flw fs4 16(sp)
					lw s0 20(sp)
					lw s1 24(sp)
					lw ra 28(sp)
					addi sp sp 32

                    # go to main
                    jr ra


# error = power(-1, n) * power(x, 2 * n + 1) / factorial(2 * n + 1)
sine_error:
		# we push into the stack to use the fs registers adding -40 bits
		addi sp sp -40
		fsw fs0 0(sp)
		fsw fs1 4(sp)
		fsw fs2 8(sp)
		fsw fs3 12(sp)
		fsw fs4 16(sp)
		fsw fs5 20(sp)
		fsw fs6 24(sp)
		fsw fs7 28(sp)
		sw s1 32(sp)
		sw ra 36(sp)
        
        # s1 = 1 int -> float # fs0 = n = 1
        li s1 1
        fcvt.s.w fs0 s1
		# fs0 -> -1
        fneg.s fs0 fs0
        
        # fs1 = x
        fmv.s fs1 fa0
        
        # fs2 = n
        fmv.s fs2 fa1
        
        # s1 = 2 int -> float # fs3 = 2
        li s1 2
        fcvt.s.w fs3 s1
        
        # s1 = 1 int -> float # fs4 = 2
        li s1 1
        fcvt.s.w fs4 s1
        
        # fs5 = 2 * n + 1
        fmadd.s fs5, fs3 fa1 fs4
        
        # fa2 = -1 # fa3 = n
        fmv.s fa2 fs0
        fmv.s fa3 fa1

        # run function power(x, n)
        jal ra power

        # fs6 = power(-1, n)
        fmv.s fs6 fa0
        
        # fs5 = 2 * n + 1
        fmv.s fa4 fs5

        # run function factorial(2 * n + 1)
        jal ra factorial
        
        # error = power(-1, n) / factorial(2 * n + 1)
        fdiv.s fs7, fs6 fa0
        
		# power(x, 2 * n + 1)
        # fs1 = x # fs5 = 2 * n + 1
        fmv.s fa2 fs1
        fmv.s fa3 fs5

        # run function power(x, n)
        jal ra power
        
        # error *= power(x, 2 * n + 1)
        fmul.s fs7, fs7 fa0
        
        # fa0 = error
        fmv.s fa0 fs7
        
        # we pop out of the stack after using the fs registers adding 40 bits
        flw fs0 0(sp)
        flw fs1 4(sp)
        flw fs2 8(sp)
        flw fs3 12(sp)
        flw fs4 16(sp)
        flw fs5 20(sp)
        flw fs6 24(sp)
        flw fs7 28(sp)
        lw s1 32(sp)
        lw ra 36(sp)
        addi sp sp 40
        
        # go to main
        jr ra




# def factorial(n):
#     result = 1
#     while n > 1:
#         result *= n
#         n -= 1
#     return result
factorial:
		# we push into the stack to use the fs registers adding -24 bits
		addi sp sp -24
		fsw fs0 0(sp)
		fsw fs1 4(sp)
		fsw fs2 8(sp)
		sw s0 12(sp)
		sw s1 16(sp)
		sw ra 20(sp)
        
        # s1 = 1 int -> float # fs0 = result = 1
        li s1 1
		fcvt.s.w fs0 s1

		# fs1 = n = fa4
        fmv.s fs1 fa4
        
        # s1 = 1 int -> float # fs2 = 1
        li s1 1
		fcvt.s.w fs2 s1
        
        # if 1 <= n -> s1 = 1 else s1 = 0
		fle.s s0 fs2 fs1
  		
        # if s1 == 0 -> end
        factorial_while:
        				beq s0 zero factorial_end
                        
                        # result *= n
                        fmul.s fs0, fs0 fs1
                        
                        # n -= 1
                        fsub.s fs1, fs1 fs2
                        
                        # if 1 <= n -> s1 = 0
                        fle.s s0 fs2 fs1
                        
                        # loop
                        j factorial_while
		
        # return result
        factorial_end:
        				# copy its value to fa0
        				fmv.s fa0 fs0
                        
                        # we pop out of the stack after using the fs registers adding 32 bits
        				flw fs0 0(sp)
        				flw fs1 4(sp)
        				flw fs2 8(sp)
        				lw s0 12(sp)
        				lw s1 16(sp)
        				lw ra 20(sp)
        				addi sp sp 24
        				
                        # go to main
                        jr ra


# def power(x, n):
#     result = 1
#     while n > 0:
#         result *= x
#         n -= 1
#     return result
power:
		# we push into the stack to use the fs registers adding -32 bits
		addi sp sp -32
		fsw fs0 0(sp)
		fsw fs1 4(sp)
		fsw fs2 8(sp)
		fsw fs3 12(sp)
		fsw fs4 16(sp)
		sw s0 20(sp)
		sw s1 24(sp)
		sw ra 28(sp)
        
        # s1 = 1 int -> float # fs0 = result = 1
        li s1 1
		fcvt.s.w fs0 s1
        
        # fs1 = x = fa2
        fmv.s fs1 fa2
        
        # fs2 = n = fa3
        fmv.s fs2 fa3
		
        # s1 = 0 int -> float # fs3 = 0
        li s1 0
        fcvt.s.w fs3 s1
        
        # s1 = 1 int -> float # fs4 = 1
        li s1 1
        fcvt.s.w fs4 s1
        
        # if n <= 0 -> s1 = 1 else s0 = 0
		fle.s s0 fs2 fs3
        
        # if s1 == 1 -> end
        power_while:
        			bne s0 zero power_end
                    
                    # result *= x
                    fmul.s fs0, fs0 fs1
                    
                    # n -= 1
                    fsub.s fs2, fs2 fs4
                    
                    # if n <= 0 -> s0 = 1
                    fle.s s0 fs2 fs3
                    
                    # loop
                    j power_while
                    
      	# return result
        power_end:
        			# copy its value to fa0
        			fmv.s fa0 fs0
                    
                    # we pop out of the stack after using the fs registers adding 32 bits
                    flw fs0 0(sp)
                    flw fs1 4(sp)
                    flw fs2 8(sp)
                    flw fs3 12(sp)
                    flw fs4 16(sp)
                    lw s0 20(sp)
                    lw s1 24(sp)
                    lw ra 28(sp)
                    addi sp sp 32
                    
                    # go to main
                    jr ra

        




        
        
        
        
        
        
