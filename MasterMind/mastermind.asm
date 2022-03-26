include "entorno.asm"

data segment
  DEFINIR_Variables
           
  fil DB ?
  col DB ?
  letrasintr DB ?
  indicejuego DB ?
ends

stack segment
    
  DW 128 DUP(0)
  
ends

code segment

  DEFINIR_BorrarPantalla
  DEFINIR_ColocarCursor
  DEFINIR_Imprimir
  DEFINIR_LeerTecla
  DEFINIR_ImprimeCaracterColor
  DEFINIR_DibujarIntentos
  DEFINIR_DibujarCodigo
  DEFINIR_DibujarInstrucciones
  DEFINIR_DibujaEntorno    
  DEFINIR_MuestraAciertos
  DEFINIR_MuestraCombinacion
  DEFINIR_MuestraGana   

;Procedimiento para imprimir en pantalla todo el titulo principal y la eleccion de piezas y combinacion de juego
;a parte de imprimir dichos mensajes en pantalla,tambien modifican dichas variables para su uso en el juego    
  Inicio PROC
    push ax
    push bx
    push cx
    push dx
;Imprime mensajes de inicio 
    mov fila,F_INICIO1
    mov colum,C_INICIO1
    call ColocarCursor
    lea dx,d_inicio1
    call Imprimir
    
    mov fila,F_INICIO2
    mov colum,C_INICIO2
    call ColocarCursor
    lea dx,d_inicio2
    call Imprimir
    
    mov fila,F_INICIO3
    mov colum,C_INICIO3
    call ColocarCursor
    lea dx,d_inicio3
    call Imprimir 
    
;Coloca el cursor al final de la primera pregunta
    mov ah,2
    mov dh,11
    mov dl,74
    mov bh,0
    int 10h
;Pide numero de piezas con el que jugar 3-6
    Pide1:
    mov ah,8
    int 21h
    cmp al,'3'
    je tres
    cmp al,'4' 
    je cuatro
    cmp al,'5'
    je cinco
    cmp al,'6'
    je seis
    jne Pide1
    tres:mov npiezas,3       
      mov ah,02h
      mov dx,'3'
      int 21h
      jmp seguir
    cuatro:mov npiezas,4 
      jmp seguir
      mov ah,02h
      mov dx,'4'
      int 21h
      jmp seguir
    cinco:mov npiezas,5 
      mov ah,02h
      mov dx,'5'
      int 21h
      jmp seguir
    seis:mov npiezas,6
      mov ah,02h
      mov dx,'6'
      int 21h
    seguir:
;Coloca el cursor al final de la segunda pregunta
    mov ah,2
    mov dh,13
    mov dl,61
    mov bh,0
    int 10h
;Pide que combinacion usar en el juego
    Pide2:
    mov ah,8
    int 21h
    cmp al,'0'
    je cero
    cmp al,'1' 
    je uno
    cmp al,'2'
    je dos
    cmp al,'3'
    je tres2 
    cmp al,'4'
    je cuatro2
    jne Pide2
    cero:
      mov indJuego,0
      mov ah,02h
      mov dx,'0'
      int 21h 
      jmp seguir2
    uno:
      mov indJuego,1
      mov ah,02h
      mov dx,'1'
      int 21h 
      jmp seguir2
    dos:
      mov indJuego,2
      mov ah,02h
      mov dx,'2'
      int 21h 
      jmp seguir2
    tres2:
      mov indJuego,3
      mov ah,02h
      mov dx,'3'
      int 21h 
      jmp seguir2
    cuatro2:
      mov indJuego,4
      mov ah,02h
      mov dx,'4'
      int 21h
      
    seguir2:
      
    call BorrarPantalla
;Imprime en pantalla la segunda parte que seria el entorno de juego en el que vamos a jugar        
    mov fila,F_TITULO
    mov colum,C_TITULO
    call ColocarCursor
    lea dx,d_titulo
    call Imprimir
    call DibujaEntorno       
   
    pop dx
    pop cx
    pop bx
    pop ax
    ret              
  Inicio ENDP
;Procedimiento para las teclas de uso en el juego,I,S,N,ESC
;Se realizan las operaciones indicadas segun la tecla pulsada  
  TeclaAccion PROC
    push ax
    push dx
     
   Pide3:
    mov ah,8
    int 21h
    cmp al,'I'
    je Tecla_i  
    cmp al,'S'
    je Tecla_s
    cmp al,'N'
    je NuevoJuego
    cmp al,27
    je TerminarTodo
    jne Pide3
   
   Tecla_i:
    pop dx
    pop ax
   
    call Teclai  
    
   Tecla_s:
    call MuestraCombinacion     
    pop dx
    pop ax
    
    push dx 
    mov fila,F_MENSAJES
    mov colum,C_MENSAJES
    call ColocarCursor
    lea dx,msj_teclaAccion
    call Imprimir
    pop dx
   Pide5:
    mov ah,8
    int 21h  
    cmp al,'N'
    je NuevoJuego
    cmp al,27
    je TerminarTodo
    jne Pide5
   
   ganas:
    push dx 
    call MuestraGana
    pop dx
    Pide6:
    mov ah,8
    int 21h  
    cmp al,'N'
    je NuevoJuego
    cmp al,27
    je TerminarTodo
    jne Pide6
   
          
    ret                      
  TeclaAccion ENDP
;Coloca el cursor en el intento que estemos jugando y procede a ejecutar todo el codigo del juego
;si estamos en el ultimo intento nos dira que hemos alcanzado el limite maximo  
  Teclai PROC
    cmp intento,0
    je  intento0 
    cmp intento,1
    je  intento1
    cmp intento,2
    je  intento2
    cmp intento,3
    je  intento3
    cmp intento,4
    je  intento4
    cmp intento,5
    je  intento5
    cmp intento,6
    je  intento6
    cmp intento,7
    je  intento7
    cmp intento,8
    je  intento8
    cmp intento,9
    je  numeromaximo 
    
    intento0:
    mov fila,F_INTENTO
    mov colum,C_INTENTO
    call ColocarCursor
    jmp seg    
    intento1:
    mov fila,7
    mov colum,54
    call ColocarCursor
    jmp seg
    intento2:
    mov fila,9
    mov colum,54
    call ColocarCursor
    jmp seg
    intento3:
    mov fila,11
    mov colum,54
    call ColocarCursor
    jmp seg
    intento4:
    mov fila,13
    mov colum,54
    call ColocarCursor
    jmp seg
    intento5:
    mov fila,15
    mov colum,54
    call ColocarCursor
    jmp seg
    intento6: 
    mov fila,17
    mov colum,54
    call ColocarCursor
    jmp seg
    intento7: 
    mov fila,19
    mov colum,54
    call ColocarCursor
    jmp seg
    intento8: 
    mov fila,21
    mov colum,54
    call ColocarCursor
    jmp seg
    numeromaximo:
    mov fila,F_MENSAJES
    mov colum,C_MENSAJES
    call ColocarCursor
    lea dx,msj_superaIntentos
    call Imprimir
    jmp pide5
        
    seg:
    call Juego
    
    ret
  Teclai ENDP 
;Procedimiento princicpal donde se desarrolla el juego,va llamando a distintos procedimientos para su uso  
  Juego PROC
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    call IntroducirCombinacion 
     
   compruebacombinacion_:
    call CompruebaCombinacion
    call Compruebaposcolor
    SIGG:
    call Ponercomba0
    call Comprobarsigana
    call Teclaaccion
   
   
   
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
  Juego ENDP
;Introduces la combinacion guardandola en dicha variable
;tambien comprueba que no se puedan introducir teclas repetidas  
  IntroducirCombinacion PROC
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov ch,0
    mov cl,npiezas
    mov di,0
    mov letrasintr,0 
    mov bl,npiezas
   siguiente:
    cmp letrasintr,bl
    je compruebacombinacion_
    call ColocarCursor
   
   Pide4: 
    push cx
    mov si,0
    mov cl,6
    mov ch,0
    mov ah,8
    int 21h
    cmp al,'R'
    je compruebarepetidos  
    cmp al,'A'
    je compruebarepetidos
    cmp al,'B'
    je compruebarepetidos
    cmp al,'V'
    je compruebarepetidos  
    cmp al,'Z'
    je compruebarepetidos
    cmp al,'M'
    je compruebarepetidos
    jne Pide4    
    
   compruebarepetidos:
    push cx
    push si
    push di
    mov cl,6
    mov ch,0
    mov di,0
   
   seguir3:
   
    cmp combinacion[di],al
    je vuelveaintroducir
    jne repite   
   vuelveaintroducir:
    pop di
    pop si
    pop cx
    jmp Pide4
   repite:
    inc di
    loop seguir3    
    pop di
    pop si
    mov combinacion[di],al
      
   bucletecla:     
    cmp al,piezas_letra[si]
    je poner   
    jne repetir
       
   poner: 
    pop cx
    push bx
    mov al,piezas_letra[si]
    mov bl,piezas_color[si]
    Call ImprimeCaracterColor
    pop bx
    inc colum
    inc colum
    inc di
    inc letrasintr
    loop siguiente
    
   repetir:
    inc si
    loop bucletecla
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
  IntroducirCombinacion ENDP
;Selecciona que combinacion para jugar hemos escogido al principio para 
;proceder a hacer las comparaciones con las cadenas  
  CompruebaCombinacion PROC
    push ax

    mov ah,0
    mov al,6
    mul indJuego
    mov indicejuego,al      

    pop ax    
    ret
  CompruebaCombinacion ENDP
;Procedimiento que calcula los aciertos en color y los aciertos en color
;almacenandolo en sus variables correspondientes   
  Compruebaposcolor PROC 
    push ax
    push bx
    push cx
    push si
    push di
    xor bx,bx
    mov bl,indicejuego
    mov si,bx
    xor bx,bx    
    mov cl,npiezas
    mov ch,0
    mov di,0
    mov aciertosPos,0
   comprobarpos0:
    mov al,combinacion[di]
    cmp al,juegos[si]
    je aciertopos0
    jne fallopos0
     
   aciertopos0:
    inc di
    inc si
    inc aciertosPos
    loop comprobarpos0
    jmp sig0 
   fallopos0:
    inc di
    inc si
    loop comprobarpos0
 
   sig0:
    
    mov di,0
    xor bx,bx
    mov bl,indicejuego
    mov si,bx
    mov ch,0
    mov cl,npiezas
    
    mov aciertosColor,0
   comprobarcolor0:
    mov al,combinacion[di]
    cmp al,juegos[si] 
    je aciertocolor0
    jne fallocolor0
     
   aciertocolor0:
    inc di
    xor bx,bx
    mov bl,npiezas
    add bl,1
    mov cl,bl
    xor bx,bx
    mov bl,indicejuego
    mov si,bx
    inc aciertosColor        
    loop comprobarcolor0
    jmp fin
          
   fallocolor0:
    inc si
    loop comprobarcolor0
    push ax 
    mov ch,0
    mov cl,npiezas
    xor bx,bx
    mov bl,indicejuego
    mov si,bx
    mov ah,0
    mov al,npiezas
    cmp di,ax
    je fin
    jne J
    J:
    pop ax
    inc di
    jmp comprobarcolor0
    fin:       
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    jmp sigg
    ret
  Compruebaposcolor ENDP 
;Pone la cadena combinacion a 0 para volver a introducir valores en otro intento  
  Ponercomba0 PROC
    push cx
    push si    
    mov si,0
    mov ch,0
    mov cl,npiezas
    bucle_:
    mov combinacion[si],0
    inc si
    loop bucle_
    pop si
    pop cx
    ret
  Ponercomba0 ENDP
  
;Comrpueba si la combinacion introducida por el usuario coincide con la ganadora  
  Comprobarsigana PROC
    push ax
    push bx
    mov fila,F_ACIERTOS
    mov colum,C_ACIERTOS
    call ColocarCursor
    mov al,aciertosColor
    mov bl,aciertosPos     
    sub al,bl
    mov aciertosColor,al          
    call MuestraAciertos          
    cmp npiezas,bl
    je ganas
    inc intento
    pop bx
    pop ax    
    ret
  Comprobarsigana ENDP
          
  Nuevojuego:
    call BorrarPantalla
    
start:
    mov ax, data
    mov ds, ax
    nuevo: 
    mov finjuego,0
    mov intento,0       
    call Inicio
    call TeclaAccion 
    
    TerminarTodo:
    mov finjuego,1                  
    mov ax, 4C00h
    int 21h

ends

end start
