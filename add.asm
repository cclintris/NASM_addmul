; add.asm
; subroutine of ADD 

;eax: tailAddr1, ebx: tailAddr2, ecx: len1, edx: len2
add:
addInit:
  mov esi, 0 ;carry bit
  mov edi, addRes
  add edi, 254

addLoop:
  push eax
  push ebx
  push ecx
  push edx
  
  mov ecx, eax
  mov edx, ebx
  mov eax, 0
  mov al, byte[ecx]
  mov ebx, 0
  mov bl, byte[edx]
  sub eax, 48
  sub ebx, 48
  pop edx
  pop ecx  
  call bitAdd
  ;after bitAdd,  eax contains remainder, ebx contains quotient
  add eax, 48
  ;store result
  mov byte[edi], al
  ;clear space for next addition
  sub edi, 1
  ;keep track of carry bit
  mov esi, ebx
  pop ebx
  pop eax
  
  sub eax, 1
  sub ebx, 1
  sub ecx, 1
  sub edx, 1

  ; len(num1) <= len(num2)
  cmp ecx, 0
  jz end_num1
  ; len(num1) >= len(num2)
  cmp edx, 0
  jz end_num2
  
  jmp addLoop
  

;patch 0
end_num1:
  cmp edx, 0
  jz end

  push ebx
  push edx
  
  mov eax, 0
  mov edx, ebx
  mov ebx, 0
  mov bl, byte[edx]
  pop edx
  sub ebx, 48
  call bitAdd
  ; after bitAdd, eax contains remainder, ebx contains quotient
  add eax, 48
  ; store result
  mov byte[edi], al
  ; clear space for next addition
  sub edi, 1
  ; keep track of carry bit
  mov esi, ebx
  pop ebx
 
  sub ebx, 1
  sub edx, 1
  jmp end_num1

;patch 0
end_num2:
  cmp ecx, 0
  jz end
  
  mov ebx, 0
  push eax
  push ecx

  mov ecx, eax
  mov eax, 0
  mov al, byte[ecx]
  pop ecx
  sub eax, 48
  ; call bitAdd
  call bitAdd
  ; after bitAdd, eax contains remainder, ebx contains quotient
  add eax, 48
  ; store result
  mov byte[edi], al
  ; clear space for next addition
  sub edi, 1
  ; keep track of carry bit
  mov esi, ebx
  pop eax
  
  sub eax, 1
  sub ecx, 1
  jmp end_num2

;task done
end:
  cmp esi, 0
  je stop
  mov byte[edi], 49
  sub edi, 1

stop:
  ret

;addition of eax, ebx, esi(carry bit)
bitAdd:
  add eax, ebx
  add eax, esi
  push edx
  mov edx, 0
  mov ebx, 10
  div ebx
  mov ebx, eax ;store quotient in ebx 
  mov eax, edx ;store remainder in eax
  pop edx
  ret

