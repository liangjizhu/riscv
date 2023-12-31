# Carlos III University of Madrid
# Computer Structure
# Practice 1: Assembly Programming
# Exercise 1

# functions implemented in Python ->
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


# def cosine_calculation(x):
#     cosine = 1
#     error = 1
#     n = 1
#     while abs(error) > 0.001:
#         error = power(-1, n) * power(x, 2 * n) / factorial(2 * n)
#         cosine += error
#         print(n, ":", error)
#         n += 1
#     return cosine


# def tangent_calculation(x):
#     return sine_calculation(x) / cosine_calculation(x)

# def e_calculation():
#     e = 1
#     error = 1
#     n = 1
#     while abs(error) > 0.001:
#         error = 1 / factorial(n)
#         e += error
#         n += 1
#     return e

.data
    sine_result: .string "Sine: "
    .align 2
    cosine_result: .string "Cosine: "
    .align 2
    tangent_result: .string "Tangent: "
    .align 2
    positive_inf: .string "+inf"
    .align 2
    negative_inf: .string "-inf"
    .align 2
    num_rad: .string "Your number in radiant: "
    .align 2
	e_result: .string "e: "

.text
	main:
		# print("Your number in radiant: ")
    	li a7 4
        la a0 num_rad
        ecall

        # read float input
        li a7 6
        ecall
        
        # print(z)
        li a7 2
        ecall
        
      	# print(\n)
		li a7 11
        li a0 10
        ecall
        
        # run tangent function
        jal ra tg
        
        # run e function
        jal ra e
        
        # Exit
        li a7 10
        ecall
        




# def tangent_calculation(x):
#     return sine_calculation(x) / cosine_calculation(x)
tg:
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
        
		# fs0 = x
		fmv.s fs0 fa0
        
        # sine_calculation(x)
        jal ra sin
        
        # fs1 = sine
        fmv.s fs1 fa0
        
		# fs2 = 0.001
        li s0 10
        fcvt.s.w ft0 s0
        li s1 1
        fcvt.s.w fs2 s1
        fdiv.s fs2, fs2 ft0
        fdiv.s fs2, fs2 ft0
        fdiv.s fs2, fs2 ft0
        
        # fs3 = 0
        li s1 0
        fcvt.s.w fs3 s1
        
        # fa0 = x
        fmv.s fa0 fs0
        
        # cosine_calculation(x)
        jal ra cos
        
        # fs4 = abs(cos(x))
        fabs.s fs4 fa0
        
        # if abs(cos(x)) <= 0.001 -> s0 = 1
        flt.s s0 fs4 fs2
        
        # special case # if s0 == 0 -> normal
        tangent_inf:
        			beq s0 zero tangent_normal
                    
                    # if sine < 0 -> s0 = 1
                    flt.s s0 fs0 fs3
                    
                    # if s0 == 0 -> negative_inf
                    tangent_negative_inf:
                    		beq s0 zero tangent_positive_inf
                            
                            # we tried to do it with fclass.s rd fs1
                            # but this doesn't recognize any register
                            # li t0 0
                            # fclass.s t0 fa0 t1
                            # it shows up Incorrect instruction syntax for 'fclass.s rd rs1 rd'
                            
                            # print("Tangent: ")
                            li a7 4
                            la a0 tangent_result
                            ecall
                            
                            # print(-inf)
                            li a7 4
                            la a0 negative_inf
							ecall                            
                            
                            # print(\n)
                            li a7 11
                            li a0 10
                            ecall
                            
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
                            
                    tangent_positive_inf:
                            # print("Tangent: ")
                            li a7 4
                            la a0 tangent_result
                            ecall
                            
                            # print(+inf)
                    		li a7 4
                            la a0 positive_inf
							ecall
                               
                            # print(\n)
                            li a7 11
                            li a0 10
                            ecall
                            
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
        
        tangent_normal:
                    # sin(x) / cos(x)
                    fdiv.s fs2, fs1 fa0

                    # copy its value to fa0
                    fmv.s fa0 fs2
					
                    # print("Tangent: ")
                    li a7 4
                    la a0 tangent_result
                    ecall
                    
                    # print(tangent(x))
                    li a7 2
                    ecall
                    
                    # print(\n)
					li a7 11
                    li a0 10
                    ecall

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


# def e_calculation():
#     e = 1
#     error = 1
#     n = 1
#     while abs(error) > 0.001:
#         error = 1 / factorial(n)
#         e += error
#         n += 1
#     return e
e:
		# we push into the stack to use the fs registers adding -28 bits
		addi sp sp -28
		fsw fs0 0(sp)
		fsw fs1 4(sp)
		fsw fs2 8(sp)
		fsw fs3 12(sp)
        sw s0 16(sp)
		sw s1 20(sp)
		sw ra 24(sp)
        
		# s1 = 1 int -> float # fs0 = e = 1
		li s1 1
        fcvt.s.w fs0 s1
		
        # fs1 = error = 1
        fcvt.s.w fs1 s1
        
		# fa1 = fa6 = n = 1
        fcvt.s.w fa6 s1
        fmv.s fa1 fa6
        
        # fs2 = 0.001
        li s1 10
        fcvt.s.w ft0 s1
        fdiv.s fs2, fa1 ft0
        fdiv.s fs2, fs2 ft0
        fdiv.s fs2, fs2 ft0
        
        # if 0.001 <= error -> s0 = 1
        flt.s s0 fs2 fs1
        
        # if s1 == 0 == s0 -> end
        e_while:
        		beq s0 zero e_end
                # fa1 = n
                # run function -> error = 1 / factorial(n)
                jal ra e_error
                
                # fs1 = error
                fmv.s fs1 fa0

                # e += error
                fadd.s fs0, fs0 fs1

                # n += 1
                fadd.s fa1, fa1 fa6

                # fs3 = abs(error)
                fabs.s fs3 fs1

                # if 0.001 <= abs(error) -> s0 = 0
                flt.s s0 fs2 fs3

                # loop
                j e_while
                
        # return e()
		e_end:	
        			# copy its value to fa0
        			fmv.s fa0 fs0
                    # print("e: ")
                    li a7 4
                    la a0 e_result
                    ecall

                    # print(e(x))
                    li a7 2
                    ecall
        			        
                    # print(\n)
                    li a7 11
                    li a0 10
                    ecall
                    
                    # we pop out of the stack after using the fs registers adding 28 bits
                    flw fs0 0(sp)
					flw fs1 4(sp)
					flw fs2 8(sp)
					flw fs3 12(sp)
					lw s0 16(sp)
					lw s1 20(sp)
					lw ra 24(sp)
					addi sp sp 28
                    
                    # go to main
                    jr ra
        
        
# error = 1 / factorial(n)
e_error:
		# we push into the stack to use the fs registers adding -16 bits
        addi sp sp -16
		fsw fs0 0(sp)
		fsw fs1 4(sp)
        sw s1 8(sp)
        sw ra 12(sp)
        
		# s1 = 1 int -> float # fs0 = n = 1
        li s1 1
        fcvt.s.w fs0 s1
        
        # fa4 = n
        fmv.s fa4 fa1
        
        # run function factorial(n)
        jal ra factorial
        
        # fs1 = 1 / factorial(n)
        fdiv.s fs1, fs0 fa0
        
        # copy its value to fa0
        fmv.s fa0 fs1
        
        # we pop out of the stack after using the fs registers adding 16 bits
        flw fs0 0(sp)
        flw fs1 4(sp)
        lw s1 8(sp)
        lw ra 12(sp)
        addi sp sp 16
        
        # go to main
        jr ra


# def cosine_calculation(x):
#     cosine = 1
#     error = 1
#     n = 1
#     while abs(error) > 0.001:
#         error = power(-1, n) * power(x, 2 * n) / factorial(2 * n)
#         cosine += error
#         print(n, ":", error)
#         n += 1
#     return cosine
cos:
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
        
		# s1 = 1 int -> float # fs0 = cosine = 1
		li s1 1
        fcvt.s.w fs0 s1
        
		# fs1 = error = 1
        fcvt.s.w fs1 s1
        
        # fa1 = fa6 = n = 1
        fcvt.s.w fa6 s1
        fmv.s fa1 fa6
		
        # fs2 = x
        fmv.s fs2 fa0
        
        # fs3 = 0.001
        li s1 10
        fcvt.s.w ft0 s1
        fdiv.s fs3, fa1 ft0
        fdiv.s fs3, fs3 ft0
        fdiv.s fs3, fs3 ft0
        
		# if 0.001 <= error -> s0 = 1
        flt.s s0 fs3 fs1
        
		# if s0 == 0 -> end
        cosine_while:
        			beq s0 zero cosine_end
                    # fa0 = x
                    fmv.s fa0 fs2
                    # fa0 = x # fa1 = n
                    # run function -> error = power(-1, n) * power(x, 2 * n) / factorial(2 * n)
                    jal ra cosine_error
                    
                    # fs1 = error
                    fmv.s fs1 fa0
                    
                    # cosine += error
                    fadd.s fs0, fs0 fs1
                    
                    # n += 1
                    fadd.s fa1, fa1 fa6
                    
					# fs4 = abs(error)
                    fabs.s fs4 fs1
					
                    # if 0.001 <= abs(error) -> s0 = 0
        			flt.s s0 fs3 fs4
					
                    # loop
                    j cosine_while
        
        # return cosine(x)
		cosine_end:	
        			# copy its value to fa0
        			fmv.s fa0 fs0
                    
                    # print("Cosine: ")
                    li a7 4
                    la a0 cosine_result
                    ecall

                    # print(cosine(x))
                    li a7 2
                    ecall

                    # print(\n)
                    li a7 11
                    li a0 10
                    ecall
                    
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
                    
# error = power(-1, n) * power(x, 2 * n) / factorial(2 * n)
cosine_error:
		# we push into the stack to use the fs registers adding -40 bits
		addi sp sp -36
		fsw fs0 0(sp)
		fsw fs1 4(sp)
		fsw fs2 8(sp)
		fsw fs3 12(sp)
		fsw fs4 16(sp)
        fsw fs5 20(sp)
        fsw fs6 24(sp)
		sw s1 28(sp)
		sw ra 32(sp)
        
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
        
        # fs4 = 2 * n
        fmul.s fs4, fs3 fs2
        
        # fa2 = -1 # fa3 = n
        fmv.s fa2 fs0
        fmv.s fa3 fa1
        
        # run power(x, n)
        jal ra power
        
        # fs5 = power(-1, n)
        fmv.s fs5 fa0
        
        # fa4 = 2 * n
        fmv.s fa4 fs4
        
        # run function factorial(2 * n)
        jal ra factorial
        
        # error = power(-1, n) / factorial(2 * n)
        fdiv.s fs6, fs5 fa0
        
        # power(x, 2 * n + 1)
        # fa2 = x # fa3 = 2 * n
        fmv.s fa2 fs1
        fmv.s fa3 fs4
        
        # run function power(x, n)
        jal ra power
        
        # error *= power(x, 2 * n)
        fmul.s fs6, fs6 fa0
		
        # fa0 = error
        fmv.s fa0 fs6
        
        # we pop out of the stack after using the fs registers adding 40 bits
        flw fs0 0(sp)
        flw fs1 4(sp)
        flw fs2 8(sp)
        flw fs3 12(sp)
        flw fs4 16(sp)
        flw fs5 20(sp)
        flw fs6 24(sp)
        lw s1 28(sp)
        lw ra 32(sp)
        addi sp sp 36
        
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
					
                            
                    # print("Sine: ")
                    li a7 4
                    la a0 sine_result
                    ecall

                    # print(sine(x))
                    li a7 2
                    ecall
                            
                    # print(\n)
                    li a7 11
                    li a0 10
                    ecall
                    
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
