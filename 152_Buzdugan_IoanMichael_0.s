.data
n: .space 4
fmt1: .asciz "%d"
fmt2: .asciz "%d\n"
fmt3: .asciz "(%d, %d)\n"
fmt4: .asciz "%d: (%d, %d)\n"
nr_op: .long 0
op: .space 4
add_verif: .long 1
get_verif: .long 2
del_verif: .long 3
dfgmt_verif: .long 4
nr_files: .space 4
i: .long 0
id: .space 4
dim: .space 4
sp_st: .space 4
byte_size: .long 8
len_v: .long 1023
st: .long 0
secv: .long 0
ok_get: .long 0
val: .long 0
l: .long 0
cnt_dfgmt: .long 0
v: .space 4096
.text

af_restransa:
    pushl %ebp
    movl %esp,%ebp

    movl v, %eax
    movl %eax, val
    movl $0,l
    movl $0, st
    movl $1,%eax
    movl len_v,%ebx

    afisare_restransa:
        cmp %eax,%ebx
        jl dupa_restransa2

        movl val,%ecx
        movl v(,%eax,4), %edx
        cmp %ecx,%edx
        je inc_secv_r
        jmp contrar_r

        inc_secv_r:
            addl $1,l
            incl %eax
            jmp afisare_restransa

            contrar_r:
                movl val,%ecx
                xorl %edx,%edx
                cmp %ecx,%edx
                jne scrie_r
                jmp dupa_scrie_r

                scrie_r:
                    pushl %eax
                    pushl %ebx
                           
                    movl st,%ecx
                    addl l,%ecx
                    pushl %ecx
                    pushl st
                    pushl val
                    pushl $fmt4
                    call printf
                    addl $16,%esp

                    pushl $0
                    call fflush
                    addl $4,%esp

                    popl %ebx
                    popl %eax

                    dupa_scrie_r:
                        movl $0,l
                        movl %eax,st
                        movl v(,%eax,4),%edi
                        movl %edi, val
                        incl %eax
                        jmp afisare_restransa

                dupa_restransa2:
                    movl val,%eax
                    xorl %ebx,%ebx
                    cmp %eax,%ebx
                    jne special_afr
                    jmp dupa_restransa

                    special_afr:
                        movl st,%ecx
                        addl l,%ecx
                        pushl %ecx
                        pushl st
                        pushl val
                        pushl $fmt4
                        call printf
                        addl $16,%esp

                        pushl $0
                        call fflush
                        addl $4,%esp

    dupa_restransa:

    popl %ebp
    ret

add_val:
    pushl %ebp
    movl %esp,%ebp

    movl 16(%esp),%eax
    movl 12(%esp),%ebx
    movl 8(%esp),%ecx

    modificare:
        cmp %eax,%ebx
        jl final

        movl %ecx, v(,%eax,4)
        incl %eax
        jmp modificare

    final:
    popl %ebp
    ret

.global main
main:
    pushl $n
    pushl $fmt1
    call scanf
    addl $8,%esp

    xorl %eax,%eax
    movl len_v,%ebx
    nuleaza:
        cmp %eax,%ebx
        jl continua
        xorl %esi,%esi
        movl %esi, v(,%eax,4)
        incl %eax
        jmp nuleaza
    continua:

    loop_op:
        movl nr_op,%eax
        incl %eax
        movl %eax,nr_op
        movl n,%ebx

        cmp %eax,%ebx
        jl end_program

        pushl $op
        pushl $fmt1
        call scanf
        addl $8,%esp

        movl op,%eax
        movl add_verif,%ebx
        cmp %eax,%ebx
        je adauga
        jmp mai_departe

        adauga:
            pushl $nr_files
            pushl $fmt1
            call scanf
            addl $8,%esp

            movl $0,i

            loop_adauga:
                movl i,%eax
                incl %eax
                movl %eax,i
                movl nr_files,%ebx
                cmp %eax,%ebx
                jl loop_op

                pushl $id
                pushl $fmt1
                call scanf
                addl $8,%esp

                pushl $dim
                pushl $fmt1
                call scanf
                addl $8,%esp

                movl $16,%ebx
                movl dim,%eax
                cmp %ebx,%eax
                jl doua_spatii

                xorl %edx,%edx
                movl dim,%eax
                movl byte_size,%edi
                divl %edi
                xorl %ebx,%ebx
                cmp %edx,%ebx
                je divizibil
                incl %eax
                movl %eax,sp_st
                jmp mai_departe1

                divizibil:
                    movl %eax,sp_st
                jmp mai_departe1
               
                doua_spatii:
                    movl $2,sp_st

                mai_departe1:
               
                xorl %eax,%eax
                movl len_v,%ebx
                movl $0,secv
                parcurge:
                    cmp %eax,%ebx
                    jl dupa_parcurgere

                    movl v(,%eax,4), %ecx
                    xorl %edx,%edx
                    cmp %ecx,%edx
                    je in_secv
                    movl $0,secv
                    incl %eax
                    jmp parcurge

                    in_secv:
                        addl $1,secv
                        movl secv,%ecx
                        movl $1,%edx
                        cmp %ecx,%edx
                        je start_secv
                        jmp dupa_start

                        start_secv:
                            movl %eax,st

                        dupa_start:

                        movl sp_st,%ecx
                        movl secv,%edx
                        cmp %ecx,%edx
                        je adaugare_in_sine
                        incl %eax
                        jmp parcurge

                        adaugare_in_sine:
                            pushl %eax
                            pushl %ebx

                            pushl st
                            movl st,%edi
                            addl sp_st,%edi
                            subl $1,%edi
                            pushl %edi
                            pushl id
                            call add_val
                            addl $12,%esp

                            popl %ebx
                            popl %eax

                            pushl %eax
                            pushl %ebx

                            movl st,%edi
                            addl sp_st,%edi
                            subl $1,%edi
                            pushl %edi
                            pushl st
                            pushl id
                            pushl $fmt4
                            call printf
                            addl $16,%esp

                            pushl $0
                            call fflush
                            addl $4,%esp

                            popl %ebx
                            popl %eax

                            jmp loop_adauga
 
                    incl %eax
                    jmp parcurge

                dupa_parcurgere:

                nu_incape:
                    pushl $0
                    pushl $0
                    pushl id
                    pushl $fmt4
                    call printf
                    addl $16,%esp

                    pushl $0
                    call fflush
                    addl $4,%esp
                   
                jmp loop_adauga

        mai_departe:

        movl op,%eax
        movl get_verif,%ebx
        cmp %eax,%ebx
        je get
        jmp dupa_get

        get:
            pushl $id
            pushl $fmt1
            call scanf
            addl $8,%esp

            movl $0,ok_get
            movl $0,sp_st
            movl $-1,st

            xorl %eax,%eax
            movl len_v,%ebx

            get_loop:
                cmp %eax,%ebx
                jl dupa_loop_get

                movl id,%ecx
                movl v(,%eax,4), %edx
                cmp %ecx,%edx
                je gasit
                incl %eax
                jmp get_loop

                gasit:
                    movl $1,ok_get
                    addl $1,sp_st
                    movl st,%ecx
                    movl $-1,%edx
                    cmp %ecx,%edx
                    je start_get
                    jmp dupa_start_get

                    start_get:
                        movl %eax,st
                    dupa_start_get:
                    incl %eax
                    jmp get_loop

            dupa_loop_get:

            movl ok_get,%eax
            movl $1,%ebx
            cmp %eax,%ebx
            je afisare_get
            jmp get_zero

            afisare_get:

                movl st,%ecx
                addl sp_st,%ecx
                subl $1,%ecx
                pushl %ecx
                pushl st
                pushl $fmt3
                call printf
                addl $12,%esp

                pushl $0
                call fflush
                addl $4,%esp

                jmp dupa_get
               
            get_zero:
                pushl $0
                pushl $0
                pushl $fmt3
                call printf
                addl $12,%esp

                pushl $0
                call fflush
                addl $4,%esp
        dupa_get:

        movl op,%eax
        movl del_verif,%ebx
        cmp %eax,%ebx
        je delete
        jmp dupa_delete

        delete:

            pushl $id
            pushl $fmt1
            call scanf
            addl $8,%esp

            xorl %eax,%eax
            movl len_v,%ebx

            loop_del:
                cmp %eax,%ebx
                jl dupa_loop_del

                movl id,%ecx
                movl v(,%eax,4),%edx
                cmp %ecx,%edx
                je sterge
                incl %eax
                jmp loop_del

                sterge:
                    movl $0,v(,%eax,4)
                    incl %eax
                    jmp loop_del

            dupa_loop_del:
           
            call af_restransa

        dupa_delete:

        movl op,%eax
        movl dfgmt_verif,%ebx
        cmp %eax,%ebx
        je defragmentare
        jmp loop_op

        defragmentare:
           
            movl len_v,%ebx
            xorl %eax,%eax
            movl $0,cnt_dfgmt

            loop_dfgmt:
                cmp %eax,%ebx
                jl dupa_loop_dfgmt

                movl v(,%ebx,4),%ecx
                xorl %edx,%edx
                cmp %ecx,%edx
                jne pun_pe_stiva
                decl %ebx
                jmp loop_dfgmt

                pun_pe_stiva:
                    movl v(,%ebx,4), %edi
                    pushl %edi
                    addl $1,cnt_dfgmt
                    decl %ebx
                    jmp loop_dfgmt

            dupa_loop_dfgmt:

            xorl %eax,%eax
            movl len_v,%ebx
           
            nuleaza_dfgmt:
                cmp %eax,%ebx
                jl dfgmt_in_sine

                movl $0, v(,%eax,4)
                incl %eax
                jmp nuleaza_dfgmt

            dfgmt_in_sine:

                xorl %eax,%eax
                movl cnt_dfgmt,%ebx
                subl $1,%ebx

                loop_fa_dfgmt:
                    cmp %eax,%ebx
                    jl dupa_defragmentare2

                    popl %ecx
                    movl %ecx, v(,%eax,4)
                    incl %eax
                    jmp loop_fa_dfgmt

                dupa_defragmentare2:
                call af_restransa

        jmp loop_op

    end_program:

        movl $1,%eax
        xorl %ebx,%ebx
        int $0x80
