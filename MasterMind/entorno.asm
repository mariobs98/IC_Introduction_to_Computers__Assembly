C_INICIO1 EQU 0
F_INICIO1 EQU 5
C_INICIO2 EQU 5
F_INICIO2 EQU 11
C_INICIO3 EQU 25
F_INICIO3 EQU 13
C_TITULO EQU 32
F_TITULO EQU 0
C_INSTRUCCIONES EQU 0
F_INSTRUCCIONES EQU 3
C_MENSAJES EQU 5
F_MENSAJES EQU 23     
C_MCODE EQU 46
F_MCODE EQU 3      
C_CODE EQU 54
F_CODE EQU 3   
C_MINTENTO EQU 42
F_MINTENTO EQU 5 
C_INTENTO EQU 54
F_INTENTO EQU 5 
C_ACIERTOS EQU 67
F_ACIERTOS EQU 5    

DEFINIR_Variables MACRO
    fila DB ?
    colum DB ?       
    caracter DB ?

    
    d_inicio1 DB "    *       *     *     ***** ***** ***** *****     *       *  * *    * * * * ",10,13
              DB "    * *   * *    * *    *       *   *     *   *     * *   * *  * * *  * *    *",10,13
              DB "    *   *   *   *****   *****   *   ****  * ***     *   *   *  * *  * * *    *",10,13
              DB "    *       *  *     *      *   *   *     *  *      *       *  * *   ** *    *",10,13
              DB "    *       * *       * *****   *   ***** *   *     *       *  * *    * * * *$"
    d_inicio2 DB "Indica cuantas piezas se utilizaran para formar la combinacion (3-6):$"
    d_inicio3 DB "Selecciona un numero de juego (0-4):$"     
    
    d_titulo DB "MASTER MIND$"
    
    d_Mcode DB   "CODIGO               ACIERTOS$"
    d_Mintento DB "Intento  :               X X X X X X $"
    
    
    d_Minstrucciones DB "           INSTRUCCIONES             *",10,13
                     DB " --------------------------------    *",10,13
                     DB "                                     *",10,13                 
                     DB "              COLORES                *",10,13
                     DB "      R - rojo      V - verde        *",10,13
                     DB "      A - amarillo  Z - azul         *",10,13
                     DB "      B - blanco    M - marron       *",10,13
                     DB "                                     *",10,13
                     DB "        SIMBOLOS DE ACIERTO          *",10,13
                     DB "     V azul: 1 color correcto        *",10,13        
                     DB "    V verde: 1 posicion correcta     *",10,13
                     DB "                                     *",10,13
                     DB "          TECLAS DE JUEGO            *",10,13
                     DB " I - introducir nueva combinacion    *",10,13
                     DB " S - resolver                        *",10,13
                     DB "                                     *",10,13
                     DB "          TECLAS DE ACCION           *",10,13
                     DB " N - comenzar un nuevo juego         *",10,13
                     DB " Esc - finalizar                     *",10,13
                     DB "                                     *$"      
                     
    msj_teclaAccion DB "Pulse una tecla de accion$"
    msj_superaIntentos DB "Ha superado el numero de intentos. Pulse una tecla de accion$"
    msj_gana DB "La combinacion es correcta. Pulse una tecla de accion$"                 
    
    npiezas DB ?    
    piezas_color DB 04h, 02h, 0Eh, 03h, 0Fh, 06h 
    piezas_letra DB 'R', 'V', 'A', 'Z', 'B', 'M'                 

    indJuego DB ?      

    juegos DB 'R', 'A', 'M', 'Z', 'B', 'V'  
           DB 'V', 'A', 'B', 'M', 'Z', 'R'
           DB 'B', 'Z', 'A', 'M', 'R', 'V'
           DB 'M', 'Z', 'A', 'R', 'V', 'B'
           DB 'Z', 'R', 'B', 'V', 'A', 'M'
        
    combinacion DB 6 DUP(?) 
    aciertosPos DB 0
    aciertosColor DB 0

    intento DB 0
    
    finJuego DB 0               

ENDM

DEFINIR_BorrarPantalla MACRO
  JMP skip_BorrarPantalla

  ;F: borra la pantalla completa
  BorrarPantalla PROC
    push ax
    push bx
    push cx
    push dx
    mov ah,6h
    mov al,0
    mov bh,7
    mov cx,0
    mov dh,24
    mov dl,79
    int 10h
    pop dx
    pop cx
    pop bx
    pop ax
    ret
  BorrarPantalla ENDP
  
  skip_BorrarPantalla:
ENDM


DEFINIR_ColocarCursor MACRO
  JMP skip_ColocarCursor

  ;F: coloca el cursor en una determinada posición de pantalla
  ;E: en las variables "fila" y "colum" debe indicarse la posición donde se colocará el cursor
  ColocarCursor PROC
    push ax
    push bx
    push dx
    mov ah,2
    mov bh,0
    mov dh, fila
    mov dl, colum
    int 10h
    pop dx
    pop bx
    pop ax
    ret
  ColocarCursor ENDP
  
  skip_ColocarCursor:
ENDM


DEFINIR_Imprimir MACRO
  JMP skip_Imprimir

  ;F: Imprime una cadena de texto en pantalla
  ;E: En el registro DX debe encotrarse almacenada la dirección de la cadena a imprimir
  Imprimir PROC
    push ax
    mov ah,09h
    int 21h
    pop ax
    ret
  Imprimir ENDP
  
  skip_Imprimir:
ENDM


DEFINIR_LeerTecla MACRO
  JMP skip_LeerTecla

  ;F: lee un carácter de teclado sin salida por pantalla
  ;S: devuelve el código del carácter en la variable "caracter"
  LeerTecla PROC
    push ax
    mov ah, 8
    int 21h
    mov caracter, al
    pop ax
    ret
  LeerTecla ENDP
  
  skip_LeerTecla:
ENDM


DEFINIR_ImprimeCaracterColor MACRO
  JMP skip_ImprimeCaracterColor

  ;F: Imprime un carácter con color de texto y fondo
  ;E: en el registro AL se indicará el carácter a imprimir
  ;E: en el registro BL se encontrará almacenado el código de color
  ImprimeCaracterColor PROC
    push ax
    push bx
    push cx
    mov ah, 9
    mov bh, 0
    mov cx, 1
    int 10h
    pop cx
    pop bx
    pop ax
    ret
  ImprimeCaracterColor ENDP
  
  skip_ImprimeCaracterColor:
ENDM
  

DEFINIR_DibujarIntentos MACRO
  JMP skip_DibujarIntentos

  ;F: Imprime en pantalla las líneas asociadas con los 9 intentos
  ;E: en la variable "npiezas" se encontrará almacenado el número de piezas de la combinación
  DibujarIntentos PROC
    push ax
    push bx
    push cx
    push dx
    
    mov bl, npiezas
    mov bh, 0
    shl bx, 1
    add bx, C_ACIERTOS
    sub bx, C_MINTENTO
    mov d_Mintento[bx], '$'
    mov cx, 1
    mov fila, F_MINTENTO
  bDibIntentos:
    mov colum, C_MINTENTO
    call ColocarCursor
    lea dx, d_Mintento
	
    mov al, cl
    add al, '0'
    mov d_Mintento[8], al 
    call Imprimir
    
    add fila, 2
    inc cx
    cmp cx, 10
    jl bDibIntentos

    mov d_Mintento[bx], 'X'
   
    pop dx
    pop cx
    pop bx
    pop ax
    ret
  DibujarIntentos ENDP
  
  skip_DibujarIntentos:
ENDM
  

DEFINIR_DibujarCodigo MACRO
  JMP skip_DibujarCodigo

  ;F: imprime la línea de título de los intentos
  ;E: en la variable "npiezas" se encontrará almacenado el número de piezas de la combinación
  DibujarCodigo PROC
    push bx
    push cx
    
    mov fila, F_MCODE
    mov colum, C_MCODE
    call ColocarCursor
    
    mov bx, C_CODE
    sub bx, C_MCODE
    mov cl, npiezas
    mov ch, 0
BDibujarCodigo:
    mov d_Mcode[bx], '*'
    add bx, 2
    loop BDibujarCodigo

    mov cl, npiezas
    mov ch, 0
BDibujarBlanco:
    cmp cx, 6
    je EtImpMCode
    mov d_Mcode[bx], ' '
    add bx, 2
    inc cx
    jmp BDibujarBlanco


EtImpMCode:
    lea dx, d_Mcode
    call Imprimir

    pop cx
    pop bx
    ret
  DibujarCodigo ENDP      
  
  skip_DibujarCodigo:
ENDM
  

DEFINIR_DibujarInstrucciones MACRO
  JMP skip_DibujarInstrucciones

  ;F: imprime las líneas de texto de las instrucciones del juego
  DibujarInstrucciones PROC
    push ax
    push bx   
    push dx

    mov fila, F_INSTRUCCIONES  
    mov colum, C_INSTRUCCIONES
    lea dx, d_Minstrucciones
    call ColocarCursor
    call Imprimir

    pop dx
    pop bx
    pop ax
    ret
  DibujarInstrucciones ENDP
  
  skip_DibujarInstrucciones:
ENDM
  

DEFINIR_DibujaEntorno MACRO
  JMP skip_DibujaEntorno

  ;F: dibuja el entorno del juego
  DibujaEntorno PROC        
    push dx
    mov fila, F_TITULO
    mov colum, C_TITULO
    call ColocarCursor
    lea dx, d_titulo
    call Imprimir
    call DibujarInstrucciones
    call DibujarCodigo
    call DibujarIntentos    
    pop dx
    ret
  DibujaEntorno ENDP
  
  skip_DibujaEntorno:
ENDM

DEFINIR_MuestraAciertos MACRO
  JMP skip_MuestraAciertos

  ;F: muestra los aciertos en la línea de intento correspondiente
  ;E: en la variable "intento" se encuentra el número de intento actual
  ;E: en la variable "aciertosPos" se encuentra el número de aciertos en posición
  ;E: en la variable "aciertosColor" se encuentra el número de aciertos en color
  MuestraAciertos PROC
    push ax
    push bx
    push cx
    push si
    mov si, 0
    mov fila, F_ACIERTOS  
    mov al, intento
    mov bl, 2
    mul bl
    add fila, al    
    mov colum, C_ACIERTOS
    mov al, 'V'
    mov bl, 2
    mov cl, aciertosPos
    mov ch, 0
BImpAciertosPos:
    call ColocarCursor
    cmp si, cx
    je ImpAciertosColor
    call ImprimeCaracterColor
    add colum, 2
    inc si
    jmp BImpAciertosPos 

ImpAciertosColor:
    mov si, 0    
    mov bl, 9
    mov cl, aciertosColor
    mov ch, 0
BImpAciertosColor:
    call ColocarCursor
    cmp si, cx
    je FinMuestraAciertos
    call ImprimeCaracterColor
    add colum, 2
    inc si
    jmp BImpAciertosColor
FinMuestraAciertos:   
    pop si
    pop cx
    pop bx
    pop ax
    ret
  MuestraAciertos ENDP

  skip_MuestraAciertos:
ENDM


DEFINIR_MuestraCombinacion MACRO
  JMP skip_MuestraCombinacion

  ;F: muestra la combinación correcta
  ;E: en "indJuego" está almacenado el índice del juego seleccionado por el usuario
  ;E: en "npiezas" se indica el número de piezas para el juego actual
  MuestraCombinacion PROC
    push ax
    push bx
    push cx
    push si
    push di
    mov fila, F_CODE
    mov colum, C_CODE
    mov cl, npiezas
    mov ch, 0       
    mov al, indJuego
    mov ah, 6
    mul ah
    mov si, ax
;    mov bh, 0
BMuestraCombinacion:
    call ColocarCursor
    mov al, juegos[si]
    mov di, 0
  BEncuentraColor:
    cmp al, piezas_letra[di]
    je ColorEncontrado
    inc di
    jmp BEncuentraColor
ColorEncontrado:
    mov bl, piezas_color[di]

    call ImprimeCaracterColor
    add colum, 2
    inc si
    loop BMuestraCombinacion  
    
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
  MuestraCombinacion ENDP
  
  skip_MuestraCombinacion:
ENDM
  

DEFINIR_MuestraGana MACRO
  JMP skip_MuestraGana

  ;F: muestra la combinación correcta y el mensaje que le indica al usuario que ha acertado la combinación
  MuestraGana PROC
    call MuestraCombinacion  
    mov fila, F_MENSAJES
    mov colum, C_MENSAJES
    call ColocarCursor
    lea dx, msj_gana
    call Imprimir
    ret
  MuestraGana ENDP  
  
  skip_MuestraGana:
ENDM

