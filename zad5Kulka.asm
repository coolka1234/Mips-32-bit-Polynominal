#Krzysztof Kulka#
.data
coefs:  .float 1.78 42 18 32.00001   # wspolczynniki wielomianu
degree: .word 3                     # stopien wielomianu
prompt: .asciiz "\nWprowadz liczbe x: \n"
x: .float 0
.text
.globl main
main:
loop_ask:
	#Zapytanie o x, najpierw string
    	li $v0, 4           # Najpierw syscall dla stringa
    	la $a0, prompt      # Wczytaj string
    	syscall
    	li $v0, 6           #Wczytaj do f0 x
    	syscall
	cvt.d.s $f0,$f0     # Przekonwertuj x do double
	la $a0,coefs        #ladujemy do obu rejestow odpowiadajych za argumenty, wektor w a0
	lw $a1,degree       # stopien w a1
	mov.d $f12, $f0     #rejsetr argumentu dla floatow
    	jal eval_poly
    	j loop_ask
eval_poly:
	#kopiowanie argumentow do rejestrow tymczasowych
	move $t2, $a0   # w t2 wskaznik na wektor
	move $t0, $a1   # t0 stopien naszego wielomianu
	mov.d $f6, $f12 # w f12 jest x
	li $t1, 1       #licznik petli=1
	l.s $f2,($t2)   #wynik wielomianu najpier rowny 1 coef
	cvt.d.s $f2,$f2 #konwersja 
	addi $t2, $t2,4 #petla ma wczytac poprawnie nastepny wspolczynnik
petlaLicz:
bgt $t1,$t0, finish
	mul.d $f2, $f2, $f6 #wynik razy x
	l.s $f4,($t2)       #wczytaj nastepny coeff
	cvt.d.s $f4,$f4     #prawidlowa konwersja
	addi $t2,$t2,4      #przesuwamy wektor ze wspolczynnikami
	add.d $f2, $f2, $f4 #dodaj wynik razy x + coeff nastepny
	addi $t1, $t1, 1    #i++
j petlaLicz
finish:
	#Wypisz wynik
        li $v0, 3                 # syscall dla double
        mov.d $f12, $f2           # przesun wynik do rejestru zwrotu typu float
        syscall                   # syscall
jr $ra	                          # skocz spowrotem
	#Zakoncz program
        li $v0, 10                # Koniec programu
        syscall
