.section .rodata
fmt1: .string "%lld"
fmt2: .string "%lld "
fmt3: .string "\n"

.section .text
.globl main
main:
    addi sp, sp, -64
    sd ra, 56(sp)     
    sd s0, 48(sp)      
    sd s1, 40(sp)      
    sd s2, 32(sp)      
    lla a0, fmt1
    addi a1, sp, 0
    call scanf
    ld s0, 0(sp)       
    mul a0, s0, s0
    slli a0, a0, 3     
    call malloc
    mv s2, a0       
    mv s1, s2          
    mul t0, s0, s0     
    li t1, 0     
inputloop:
    beq t1, t0, rotate_prep
    lla a0, fmt1
    mv a1, s1
    call scanf      
    addi s1, s1, 8     
    addi t1, t1, 1
    j inputloop
rotate_prep:
    li t0, 0         
transpose_outer:
    bge t0, s0, reverse_prep
    mv t1, t0         
transpose_inner:
    bge t1, s0, transpose_next_row
    mul t2, t0, s0
    add t2, t2, t1
    slli t2, t2, 3
    add t2, s2, t2  
    mul t3, t1, s0
    add t3, t3, t0
    slli t3, t3, 3
    add t3, s2, t3
    ld t4, 0(t2)
    ld t5, 0(t3)
    sd t5, 0(t2)
    sd t4, 0(t3)
    addi t1, t1, 1
    j transpose_inner
transpose_next_row:
    addi t0, t0, 1
    j transpose_outer
reverse_prep:
    li t0, 0          
reverse_outer:
    bge t0, s0, print_prep
    li t1, 0          
    addi t2, s0, -1    
reverse_inner:
    bge t1, t2, reverse_next_row
    mul t3, t0, s0
    add t3, t3, t1
    slli t3, t3, 3
    add t3, s2, t3  
    mul t4, t0, s0
    add t4, t4, t2
    slli t4, t4, 3
    add t4, s2, t4   
    ld t5, 0(t3)
    ld t6, 0(t4)
    sd t6, 0(t3)
    sd t5, 0(t4)
    addi t1, t1, 1    
    addi t2, t2, -1   
    j reverse_inner
reverse_next_row:
    addi t0, t0, 1
    j reverse_outer
print_prep:
    li t0, 0      
print_outer:
    bge t0, s0, exit
    li t1, 0     
print_inner:
    bge t1, s0, print_newline
    mul t2, t0, s0
    add t2, t2, t1
    slli t2, t2, 3
    add t2, s2, t2
    ld a1, 0(t2)
    lla a0, fmt2    
    call printf 
    addi t1, t1, 1
    j print_inner
print_newline:
    lla a0, fmt3      
    call printf
    addi t0, t0, 1
    j print_outer
exit:
    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    addi sp, sp, 64
    li a0, 0
    ret
    
