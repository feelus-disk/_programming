clc
clear
eq=sym('m^4=4*(e_^2-p^2)*(m^2+p^2)')
m=sym('m1+m2')
e_=sym('e1+e2')
p=sym('p1+p2')

eq=eq/sym('p^2+m^2')
eq=eq/sym('4')
eq=eq+sym('p^2')


eq=subs(eq,sym('m'),m)
eq=subs(eq,sym('p'),p)
eq=subs(eq,sym('e_'),e_)

eq=expand(eq)
eq=subs(eq,sym('e1'),sym('sqrt(p1^2+m1^2)'))
eq=subs(eq,sym('e2'),sym('sqrt(p2^2+m2^2)'))

eq=eq-sym('m1^2+m2^2+p1^2+p2^2')
r=right(eq)