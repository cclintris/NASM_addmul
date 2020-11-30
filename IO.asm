; IO.asm 
; functions that matters with input and output


; calculate string length
slen:
  push ebx
  mov ebx, eax
nextchar:
  cmp byte[eax], 0
  jz finished
  inc eax
  jmp nextchar
finished:
  sub eax, ebx
  pop ebx
  ret

;print string
sprint:
  push edx
  push ecx
  push ebx
  push eax
  call slen
  
  mov edx, eax
  pop eax

  mov ecx, eax
  mov ebx, 1
  mov eax, 4
  int 80h
  
  pop ebx
  pop ecx
  pop edx
  ret

; print string with LineFeed
sprintLF:
  call sprint
  push eax
  mov eax, 0Ah
  push eax
  mov eax, esp
  call sprint
  pop eax
  pop eax
  ret

; print LineFeed
printLF:
  push eax
  mov eax, 0Ah
  push eax
  mov edx, 1
  mov ecx, esp
  mov ebx, 1
  mov eax, 4
  int 80h
  pop eax
  pop eax
  ret

; safe quit
quit:
  mov ebx, 0
  mov eax, 1
  int 80h
  ret

; print space
printSpace:
  mov ebx, 1
  mov eax, 4
  mov ecx, space
  mov edx, 1
  int 80h
  ret 
