; mul.asm
; subroutine of MULTIPLY


; eax: tailAddr1, ebx: tailAddr2, ecx: len1, edx: len2
mul:
mulInit:
  mov esi, addRes    
  mov edi, addRes
  add edi, 255

; fill esi all 0, for convenient to print multiply result
fillZero:
  mov byte[esi], 48
  inc esi
  cmp edi, esi
  je initCtx
  jmp fillZero

initCtx:
  ; edi records times be added of second number
  mov edi, 0
startCal:
  cmp edi, 0
  je noShift
  cmp edi, edx
  je mulEnd

shift:
  push eax
  push esi
  call leftShift
  inc ecx
  pop esi
  pop eax
  sub eax, 1

noShift:
  ; esi stores times to be add
  push eax
  mov eax, 0
  mov al, byte[ebx]
  mov esi, eax
  sub esi, 48
  pop eax

  sub ebx, 1
addOnce:
  cmp esi, 0
  je next
  
  push eax
  push ebx
  push ecx
  push edx
  push esi
  push edi
  
  mov ebx, addRes
  add ebx, 254
  mov edx, 255  
  add eax, ecx
  sub eax, 1
  call add
  
  pop edi
  pop esi
  pop edx
  pop ecx
  pop ebx
  pop eax
  
  sub esi, 1
  jmp addOnce

next:
  inc edi
  jmp startCal

; find first nonzero byte
mulEnd:
  mov eax, addRes
  mov bl, 48
findFirstNonZeroByte:
  mov ebx, 0
  mov bl, byte[eax]
  cmp byte[eax], 48
  jne found
  push eax
  sub eax, 254
  cmp eax, addRes
  je  all
  pop eax
  inc eax
  jmp findFirstNonZeroByte

all:
  pop eax
  ret

found:
  ret
 
leftShift:
  push ecx
  mov esi, ecx
shiftOnce:
  cmp esi, 0
  je shiftEnd
  mov cl, byte[eax]
  sub eax, 1
  mov byte[eax], cl
  sub esi, 1
  add eax, 2
  jmp shiftOnce
shiftEnd:
  sub eax, 1
  mov byte[eax], 48
  pop ecx
  ret

