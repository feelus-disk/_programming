//(c) FeelUs
#ifndef END_HPP
#define END_HPP

#include <string.h>
#include <wchar.h>

namespace str
{

template<class T>
inline bool atend(const T & x)
{	return *x==0;	}

template<class T>
inline void putend(const T & x)
{	*x=0;	}

/*
каждый итератор можно
сравнивать с 0
присваивать ему 0
преобразовывать в bool
*/

/*
планируется добавить 
capacity - если имеют специальные теги
unused - для всех
*/

};//str
#endif//END_HPP
