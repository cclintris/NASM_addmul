%include 'IO.asm'
%include 'add.asm'
%include 'mul.asm'

section .data
prompt db 'Input two numbers: ', 0h
space db ' '

section .bss
sinput resb 255
addRes resb 255

section .text
global _start

_start:
  ;print prompt message
  mov eax, prompt
  call sprintLF
  ;read two numbers into input(STDIN file)
  mov edx, 255
  mov ecx, sinput
  mov ebx, 0
  mov eax, 3
  int 80h
 
  mov eax, sinput
  mov ebx, eax ;store head address
  call slen; eax now contains length of input string in form [num1 num2]
  
  push eax
  mov eax, sinput

loop:
  inc eax
  cmp byte[eax], ' '
  jz end_loop
  jmp loop

end_loop:
  mov ebx, eax  
  pop eax
  push eax
  push ebx
  push ecx
  push edx
  push edi
  push esi
  jmp add_prepare

  ;sinput: string head, eax: string length; ebx: space addr
add_prepare:
  mov esi, eax
  mov eax, ebx
  sub eax, 1
  mov ebx, sinput
  add ebx, esi
  sub ebx, 2; 2 because of \n
  
  push eax
  sub eax, sinput
  inc eax
  mov ecx, eax
  pop eax

  mov edx, esi
  sub edx, ecx
  sub edx, 2
  call add

  ; print add result
  mov eax, addRes
  add eax, 254
  sub eax, edi
  mov edx, eax
  mov ecx, edi
  inc ecx
  mov ebx, 1
  mov eax, 4
  int 80h

  call printLF

  pop esi
  pop edi
  pop edx
  pop ecx
  pop ebx
  pop eax

; sinput: string head, eax: string length, ebx: space addr
mul_prepare:
  mov esi, eax
  mov eax, sinput
  mov edi, ebx
  mov ebx, sinput
  add ebx, esi
  sub ebx, 2
  mov ecx, edi
  sub ecx, sinput
  mov edx, ebx
  sub edx, edi

  call mul

  ; print mul result  
  mov ecx, eax
  mov ebx, 1
  mov eax, 4
  mov edx, addRes
  add edx, 255
  sub edx, ecx
  int 80h
  mov eax, 0
  mov ebx, 0
  mov ecx, 0
  mov edx, 0
  call printLF
  call quit
  ret
  ; main.asm END







