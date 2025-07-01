.data
fmtc: .asciz "%d"
fmta1: .asciz "%d\n"
fmta2: .asciz "(%d, %d)\n"
fmta3: .asciz "%d: (%d, %d)\n"
fmta4: .asciz "((%d, %d), (%d, %d))\n"
fmta5: .asciz "%d: ((%d, %d), (%d, %d))\n"
nr_op: .space 4
op_i: .long 0
op: .space 4
nr_files: .space 4
file_i: .long 0
id: .space 4
dim: .space 4
dimb: .space 4
linia_i: .long 0
verif_i: .long 0
secv: .long 0
st_i: .long 0
left: .long 0
right: .long 0
val: .long 0
start: .long 0
start_d: .long 0
lstart: .long 0
l_secv: .long 0
cnt_dfgmt: .long 0
cnt: .long 0
lastline: .long 0
vald: .long 0
secvd: .long 0
latmat: .long 1024
latmax: .long 1048576
lv: .long 1023

.bss
v: .space 4194304

.text

modlat:
    pushl %ebp
    movl %esp,%ebp

    movl 8(%esp),%eax
    movl latmat,%ebx
    xorl %edx,%edx
    divl %ebx
    movl %edx,%esi
    movl %eax,%edi
    popl %ebp
    ret

af_restransa:
    pushl %ebp
    movl %esp,%ebp

    movl v, %eax
    movl %eax, val
    movl $0,l_secv
    movl $0, start
    movl $1,%eax
    movl latmax,%ebx

    afisare_restransa:
        cmp %eax,%ebx
        jl dupa_restransa2

        movl val,%ecx
        movl v(,%eax,4), %edx
        cmp %ecx,%edx
        je inc_secv_r
        jmp contrar_r

        inc_secv_r:
            addl $1,l_secv
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

                    movl start,%ecx
                    addl l_secv,%ecx
                    pushl %ecx
                    call modlat
                    addl $4,%esp
                    movl %esi,start_d

                    pushl start
                    call modlat
                    addl $4,%esp
                    movl %esi,start
                    movl %edi,lstart
                   
                    pushl start_d
                    pushl lstart
                    pushl start
                    pushl lstart
                    pushl val
                    pushl $fmta5
                    call printf
                    addl $24,%esp

                    pushl $0
                    call fflush
                    addl $4,%esp

                    popl %ebx
                    popl %eax

                    dupa_scrie_r:
                        movl $0,l_secv
                        movl %eax,start
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
                        movl start,%ecx
                        addl l_secv,%ecx
                        pushl %ecx
                        pushl start
                        pushl val
                        pushl $fmta3
                        call printf
                        addl $16,%esp

                        pushl $0
                        call fflush
                        addl $4,%esp

    dupa_restransa:

    popl %ebp
    ret

afmat:
    pushl %ebp
    movl %esp,%ebp

    movl latmat,%eax
    mull %eax
    subl $1,%eax
    movl %eax,%ebx
    xorl %eax,%eax

    loop_af:
        cmp %eax,%ebx
        jl end_af
        movl v(,%eax,4), %ecx
        pushl %eax
        pushl %ebx

        pushl %ecx
        pushl $fmta1
        call printf
        addl $8,%esp

        pushl $0
        call fflush
        addl $4,%esp

        popl %ebx
        popl %eax

        incl %eax
        jmp loop_af
    end_af:
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

incape_i:
    pushl %ebp
    movl %esp,%ebp

    movl $0, verif_i
    movl linia_i,%eax
    movl latmat,%ecx
    mull %ecx
    movl %eax,%ebx
    addl lv,%ebx
    movl $0,st_i

    movl $0,secv
    parcurge:
        cmp %eax,%ebx
        jl parcurs

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
                movl %eax,st_i
            dupa_start:
            movl dimb,%ecx
            movl secv,%edx
            cmp %ecx,%edx
            je loc_liber
            incl %eax
            jmp parcurge

            loc_liber:
                movl $1,verif_i
                jmp parcurs
    parcurs:
    popl %ebp
    ret

.global main
main:
    movl latmat,%eax
    subl $1,%eax
    movl %eax,lv
    addl $1,%eax
    mull %eax
    movl %eax,latmax

    pushl $nr_op
    pushl $fmtc
    call scanf
    addl $8,%esp

    loop_op:
        addl $1,op_i
        movl op_i,%eax
        movl nr_op,%ebx
        cmp %eax,%ebx
        jl end_program

        pushl $op
        pushl $fmtc
        call scanf
        addl $8,%esp

        movl op,%eax
        movl $1,%ebx
        cmp %eax,%ebx
        je mat_add
        jmp verif2

        mat_add:
            pushl $nr_files
            pushl $fmtc
            call scanf
            addl $8,%esp
            movl $0,file_i

            loop_filei:
                addl $1,file_i
                movl file_i,%eax
                movl nr_files,%ebx
                cmp %eax,%ebx
                jl loop_op

                pushl $id
                pushl $fmtc
                call scanf
                addl $8,%esp

                pushl $dim
                pushl $fmtc
                call scanf
                addl $8,%esp

                movl $16,%eax
                movl dim,%ebx
                cmp %eax,%ebx
                jle doua_spatii

                xorl %edx,%edx
                movl dim,%eax
                movl $8,%edi
                divl %edi
                xorl %ebx,%ebx
                cmp %edx,%ebx
                je divizibil
                incl %eax
                movl %eax,dimb
                jmp dupa_calc

                divizibil:
                    movl %eax,dimb
                jmp dupa_calc
               
                doua_spatii:
                    movl $2,dimb
                dupa_calc:

                xorl %eax,%eax
                movl lv,%ebx

                loop_linii:
                    cmp %eax,%ebx
                    jl parcurs_linii

                    movl %eax,linia_i
                    pushl %eax
                    pushl %ebx
                    call incape_i
                    popl %ebx
                    popl %eax

                    movl verif_i,%ecx
                    movl $1,%edx
                    cmp %ecx,%edx
                    je real_matadd
                    incl %eax
                    jmp loop_linii

                    real_matadd:
                        pushl %eax
                        pushl %ebx

                        pushl st_i
                        movl st_i,%edi
                        addl dimb,%edi
                        subl $1,%edi
                        pushl %edi
                        pushl id
                        call add_val
                        addl $12,%esp

                        popl %ebx
                        popl %eax
                        pushl %eax
                        pushl %ebx
                       
                        movl st_i,%esi
                        addl dimb,%esi
                        subl $1,%esi

                        pushl %eax
                        pushl %ebx
                        xorl %edx,%edx
                        movl %esi,%eax
                        movl latmat,%ebx
                        divl %ebx
                        movl %edx,%esi

                        movl st_i,%eax
                        xorl %edx,%edx
                        movl latmat,%ebx
                        divl %ebx
                        movl %edx,st_i

                        popl %ebx
                        popl %eax

                        pushl %esi
                        pushl %eax
                        pushl st_i
                        pushl %eax
                        pushl id
                        pushl $fmta5
                        call printf
                        addl $24,%esp

                        pushl $0
                        call fflush
                        addl $4,%esp

                        popl %ebx
                        popl %eax

                        jmp loop_filei

                parcurs_linii:
                    movl verif_i,%ecx
                    xorl %edx,%edx
                    cmp %ecx,%edx
                    jne loop_filei

                    pushl $0
                    pushl $0
                    pushl $0
                    pushl $0
                    pushl id
                    pushl $fmta5
                    call printf
                    addl $24,%esp

                    pushl $0
                    call fflush
                    addl $4,%esp

                jmp loop_filei

        verif2:
        movl op,%eax
        movl $2,%ebx
        cmp %eax,%ebx
        je mat_get
        jmp verif3

        mat_get:
            pushl $id
            pushl $fmtc
            call scanf
            addl $8,%esp

            movl $-1,left
            movl $-1,right
            xorl %eax,%eax
            movl latmax,%ebx
            subl $1,%ebx

            loop_get:
                cmp %eax,%ebx
                jl dupa_loop_get

                movl v(,%eax,4),%ecx
                movl id,%edx
                cmp %ecx,%edx
                je gasit
                incl %eax
                jmp loop_get

                gasit:
                    movl left,%ecx
                    movl $-1,%edx
                    cmp %ecx,%edx
                    je init_get
                    jmp inc_get

                    init_get:
                        movl %eax,left
                        incl %eax
                        jmp loop_get
                    inc_get:
                        movl %eax,right
                        incl %eax
                        jmp loop_get
            dupa_loop_get:
            movl left,%ecx
            movl $-1,%edx
            cmp %ecx,%edx
            je nu_exista

            pushl left
            call modlat
            addl $4,%esp
            movl %esi,left
            pushl right
            call modlat
            addl $4,%esp
            movl %esi,right
           
            pushl right
            pushl %edi
            pushl left
            pushl %edi
            pushl $fmta4
            call printf
            addl $20,%esp

            pushl $0
            call fflush
            addl $4,%esp

            jmp loop_op

            nu_exista:
                pushl $0
                pushl $0
                pushl $0
                pushl $0
                pushl $fmta4
                call printf
                addl $20,%esp

                pushl $0
                call fflush
                addl $4,%esp
                jmp loop_op
        verif3:
        movl op,%eax
        movl $3,%ebx
        cmp %eax,%ebx
        je mat_del
        jmp verif4

        mat_del:
            pushl $id
            pushl $fmtc
            call scanf
            addl $8,%esp

            xorl %eax,%eax
            movl latmax,%ebx

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
            jmp loop_op

        verif4:
        movl op,%eax
        movl $4,%ebx
        cmp %eax,%ebx
        je defragmentare
        jmp verif5

        defragmentare:
            movl latmax,%eax
            subl $1,%eax
            movl v(,%eax,4), %ecx
            movl %ecx,val
            subl $1,%eax
            xorl %ebx,%ebx
            movl $1,secv
            movl $0,cnt_dfgmt

            stiva_dfgmt:
                cmp %eax,%ebx
                jg dupa_stiva_dfgmt

                movl v(,%eax,4), %ecx
                movl val,%edx
                cmp %ecx,%edx
                je egalitate
                jmp contrar

                egalitate:
                    addl $1,secv
                    decl %eax
                    jmp stiva_dfgmt
                contrar:
                    movl val,%ecx
                    xorl %edx,%edx
                    cmp %ecx,%edx
                    je dupa_pun

                    pushl secv
                    pushl val
                    addl $1,cnt_dfgmt

                    dupa_pun:
                    movl v(,%eax,4), %ecx
                    movl %ecx,val
                    movl $1,secv
                    decl %eax
                    jmp stiva_dfgmt
            dupa_stiva_dfgmt:

            movl val,%eax
            xorl %ebx,%ebx
            cmp %eax,%ebx
            jne pune_special
            jmp dupa_pune_special
            pune_special:
                pushl secv
                pushl val
                addl $1,cnt_dfgmt
            dupa_pune_special:

            xorl %eax,%eax
            movl latmax,%ebx
            subl $1,%ebx
            nuleaza:
                cmp %eax,%ebx
                jl continua
                xorl %esi,%esi
                movl %esi, v(,%eax,4)
                incl %eax
                jmp nuleaza
            continua:

            movl $0,lastline
            movl $0,cnt

            mod_dfgmt:
                addl $1,cnt
                movl cnt,%eax
                movl cnt_dfgmt,%ebx
                cmp %eax,%ebx
                jl end_dfgmt

                popl %eax
                popl %ebx
                movl %eax,vald
                movl %ebx,secvd

                movl lastline,%eax
                movl lv,%ebx

                loop_cautare:
                    cmp %eax,%ebx
                    jl mod_dfgmt

                    movl %eax,linia_i
                    movl secvd,%edi
                    movl %edi,dimb
                    pushl %eax
                    pushl %ebx
                    call incape_i
                    popl %ebx
                    popl %eax

                    movl verif_i,%ecx
                    movl $1,%edx
                    cmp %ecx,%edx
                    je pune_dfgmt
                    incl %eax
                    jmp loop_cautare
                    pune_dfgmt:
                        movl %eax,lastline

                        movl st_i,%ecx
                        movl %ecx,%edx
                        addl secvd,%edx
                        decl %edx

                        scrie_dfgmt:
                            cmp %ecx,%edx
                            jl modificat

                            movl vald,%edi
                            movl %edi, v(,%ecx,4)
                            incl %ecx
                            jmp scrie_dfgmt
                       
                        modificat:            
                        jmp mod_dfgmt
            end_dfgmt:

            call af_restransa
            jmp loop_op

        verif5:

        jmp loop_op

    end_program:
    movl $1,%eax
    xorl %ebx,%ebx
    int $0x80
