
; structure definition helper

macro struct name
{
   name@struct fix name
   struc name {
}

macro struct_helper name
{
   virtual at 0
   name name
   sizeof.#name = $ - name
   name equ sizeof.#name
   end virtual
}

ends fix } struct_helper name@struct
