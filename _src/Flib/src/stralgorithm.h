//(c) FeelUs
//переделанный algorithm из MSVC2008
//_SEQURE_SCL - тупо удалял, я за его работу не отвечаю
//#include <algorithm>
#ifndef STR_ALGORITHM_HPP
#define STR_ALGORITHM_HPP

#include <string.h>
#include <wchar.h>
#include <iterator>
#include "str.h"

namespace str
{
//using namespace std;
#define PREFIX(name) str_##name

#ifdef _DEBUG_RANGE
#	ifndef _TMP_DEBUG_RANGE
#		define _TMP_DEBUG_RANGE(first,last)  _DEBUG_RANGE(first,last)
#		undef  _DEBUG_RANGE
#		define _DEBUG_RANGE(first,last) //last всегда игнорировать в этой библиотеке
#	else
#		error "change #define _TMP_DEBUG_RANGE to other name at here and at end of this file"
#	endif
#	ifndef _TMP_DEBUG_ORDER
#		define _TMP_DEBUG_ORDER(first,last)  _DEBUG_ORDER(first,last)
#		undef  _DEBUG_ORDER
#		define _DEBUG_ORDER(first,last) //last всегда игнорировать в этой библиотеке
#	else
#		error "change #define _TMP_DEBUG_ORDER to other name at here and at end of this file"
#	endif
#	ifndef _TMP_DEBUG_ORDER_PRED
#		define _TMP_DEBUG_ORDER_PRED(first,last,pred)  _DEBUG_ORDER_PRED(first,last,pred)
#		undef  _DEBUG_ORDER_PRED
#		define _DEBUG_ORDER_PRED(first,last,pred) //last всегда игнорировать в этой библиотеке
#	else
#		error "change #define _TMP_DEBUG_ORDER_PRED to other name at here and at end of this file"
#	endif
#else
#	ifndef _TMP_DEBUG_RANGE
#		define _DEBUG_RANGE(first,last) //last всегда игнорировать в этой библиотеке
#		define _TMP_DEBUG_RANGE(first,last)  _DEBUG_RANGE(first,last)
#	else
#		error "change #define _TMP_DEBUG_RANGE to other name at here and at end of this file"
#	endif
#	ifndef _TMP_DEBUG_ORDER
#		define _DEBUG_ORDER(first,last) //last всегда игнорировать в этой библиотеке
#		define _TMP_DEBUG_ORDER(first,last)  _DEBUG_ORDER(first,last)
#	else
#		error "change #define _TMP_DEBUG_ORDER to other name at here and at end of this file"
#	endif
#	ifndef _TMP_DEBUG_ORDER_PRED
#		define _DEBUG_ORDER_PRED(first,last,pred) //last всегда игнорировать в этой библиотеке
#		define _TMP_DEBUG_ORDER_PRED(first,last,pred)  _DEBUG_ORDER_PRED(first,last,pred)
#	else
#		error "change #define _TMP_DEBUG_ORDER_PRED to other name at here and at end of this file"
#	endif
#	define _DEBUG_POINTER(a)
#	define _CHECKED_BASE_TYPE(a) a
#	define _CHECKED_BASE(a) a
#	define _ASSIGN_FROM_BASE(a,b) a=b
#	define _Distance(a,b,d) (d=distance(a,b))
#	define _DEBUG_LT_PRED(pred, x, y)	(pred((x),(y)))
#	define _DEBUG_LT(x, y)	((x)<(y))

template<class It>
typename std::iterator_traits<It>::difference_type * 
	_Dist_type(const It i)
	{
		return (0);
	}
template<class _Iter> inline
	typename std::iterator_traits<_Iter>::iterator_category
	_Iter_cat(const _Iter&)
	{	// return category from iterator argument
		typename std::iterator_traits<_Iter>::iterator_category _Cat;
	return (_Cat);
	}
template<class _Iter> inline
	typename std::iterator_traits<_Iter>::value_type * 
	_Val_type(_Iter)
	{	// return value type from arbitrary argument
	return (0);
	}

#endif

/*
вообще фишка си в том, что 
не нужно создавать десяток маленьких функций, отличающихся друг от друга в мелочах (и еще путаться в их названиях)
а нужно просто писать код
	в с++11 этому еще способствует тип auto
поэтому имеет смысл использовать отсюда алгоритмы только те, которые имеют специализацию
или те, которые лень заново писать =)
*/
/*
данные алгоритмы не требуют от итераторов возможности
присваивания 0, сравнения с 0 и преобразования в буул

и в конце они не ставят putend(), не забывайте это делать сами
*/
/*
пишем алгоритмы так, как будто будем применять их к гиганским файлам
- у них форвард итератор
для рандом аццесс итератора - как будто он весь в оперативке
*/
/*
вот итераторы стараются сделать как можно более похожими на обычные указатели
так и есть для строк и векторов
для списков уже требуется не ++указателя, а присваиваие из определенного места
а для декуе вообще происходят проверки, не вышел ли итератор за пределы массива
	и если вышел, его кидает в другую сторону массива
	=> для быстрого доступа к указателям на границы массива, они должны храниться в самом итераторе
я вообще молчу про сеты и мепы
для итераторов по потокам - несколько раз загружать из памяти одни и теже блоки лениво,
	да и может вообще не быть такой возможности
	поэтому стараются читать как можно меньше, и по этому делают это за 1 проход

мои же потоки буферизуют это, полагаясь на самый левый итератор
мои итераторы работают также как в декуе:
	проверяют границы блока
	если вышел за пределы
		перекидываешься в другой блок
		при этом пересчитываются счетчики указателей на блоках
			при этом некоторые блоки может потребоваться загрузить, а некоторые - выгрузить

а вообще я это к алгоритму уник-копи
там для инпут-итераторов копируется значение
а для форвард и прочих - указатель
и если тип значения настолько же мал и прост как char
то даже для декуе он работает не самым эффективным образом!!!!!!!!!!!!
*/
/*
буфера хранят информацию блоками
в памяти всегда находятся блоки на которых присутствуют итераторы
+ N(=0) блоков слева и M(=1) блок справа, от текущих итераторов, 
	на которых итераторы уже побывали
и только они
размер блока по умолчанию 256..1024 элемента, а вообще он может меняться
*/
/*
буфера бывают двух типов:
рандом аццесс файлы
и форвард потоки (например по сети что-то передается)

и часто ты передаешь в функцию итератор, и больше не используешь его никогда
а функция может уйти итераторами далеко вперед
и буферу придется хранить все данные между
	забытым, но еще не уничтоженным деструктором итератором
	и местом, где работает функция
и еще при передаче в функцию может образоваться неконтролируемое количество временных итераторов
	!хотя в с++11 можно узнать: от временный или от обычный объект конструируется

в буферах в режиме файла это решено искусственно: большие промежутки выгружаются
а в буферах в режиме потоков это не решено!!!!!!!!!!!!!!!!!!!!!!

..........и есть выбор:
решить это хитро
	--только в с++11:
	отмечая итератор неиспользуемым, получаем
		0 итераторов указывает на буфер - если смотреть как на поток
		1 ит указывает - если смотреть как на файл
			и указывать он будет, пока не завершиться функция, и он не будет удален деструктором
		при удалении итераторов с буфера, файловые итераторы удаляются в последнюю очередь
			т.е. буфер будет жить до тех пор, пока с него не удалиться последний итератор
или не использовать алгоритмы для потоков потоков
*/
/*
у буферов сделать проверку на отсутствие итераторов
и удаление всех итераторов, кроме данных

доделать некоторые алгоритмы и доделать специализации

str_buffer
все поместить в namespace str
*/
//----------------------------------------------------------------
//спецализации не требуется
		// TEMPLATE FUNCTION for_each
template<class _InIt, class _Fn1> inline
	_Fn1 PREFIX(for_each)(_InIt _First, _Fn1 _Func)
	{	// perform function for each element
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Func);
	_CHECKED_BASE_TYPE(_InIt) _ChkFirst(_CHECKED_BASE(_First));
	for (; !atend(_ChkFirst); ++_ChkFirst)
		_Func(*_ChkFirst);
	return (_Func);
	}

//----------------------------------------------------------------
//неэффективные специализации
			// TEMPLATE FUNCTION find
			// if not find, return end iterator
template<class _InIt, class _Ty> inline
	_InIt _strFind(_InIt _First, const _Ty& _Val)
	{	// find first matching _Val
	_DEBUG_RANGE(_First, _Last);
	for (; !atend(_First); ++_First)
		if (*_First == _Val)
			break;
	return (_First);
	}

inline const char *_strFind(const char *_First, const char *_Last, int _Val)
	{	// find first char that matches _Val
	_DEBUG_RANGE(_First, _Last);
	_First = (const char *)::strchr(_First, _Val);
	return (_First == 0 ? end(_First) : _First);
	}

inline const signed char *_strFind(const signed char *_First, int _Val)
	{	// find first signed char that matches _Val
	_DEBUG_RANGE(_First, _Last);
	_First = (const signed char *)::strchr((const char *)_First, _Val);
	return (_First == 0 ? end(_First) : _First);
	}

inline const unsigned char *_strFind(const unsigned char *_First, int _Val)
	{	// find first unsigned char that matches _Val
	_DEBUG_RANGE(_First, _Last);
	_First = (const unsigned char *)::strchr((const char *)_First, _Val);
	return (_First == 0 ? end(_First) : _First);
	}

inline const wchar_t *_strFind(const wchar_t *_First, const wchar_t *_Last, int _Val)
	{	// find first char that matches _Val
	_DEBUG_RANGE(_First, _Last);
	_First = (const wchar_t *)::wcschr(_First, _Val);
	return (_First == 0 ? end(_First) : _First);
	}

template<class _InIt, class _Ty> inline
	_InIt PREFIX(find)(_InIt _First, const _Ty& _Val)
	{	// find first matching _Val
	_ASSIGN_FROM_BASE(_First,
		_strFind(_CHECKED_BASE(_First), _Val));
	return (_First);
	}

		// TEMPLATE FUNCTION find_if
template<class _InIt, class _Pr> inline
	_InIt _strFind_if(_InIt _First, _Pr _Pred)
	{	// find first satisfying _Pred
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Pred);
	for (; !atend(_First); ++_First)
		if (_Pred(*_First))
			break;
	return (_First);
	}

template<class _InIt, class _Pr> inline
	_InIt PREFIX(find_if)(_InIt _First, _Pr _Pred)
	{	// find first satisfying _Pred
	_ASSIGN_FROM_BASE(_First,
		_strFind_if(_CHECKED_BASE(_First), _Pred));
	return (_First);
	}

//----------------------------------------------------------------
//специализации отсутствуют
	// TEMPLATE FUNCTION count
template<class _InIt, class _Ty> inline
typename std::iterator_traits<_InIt>::difference_type
		_strCount(_InIt _First, const _Ty& _Val)
	{	// count elements that match _Val
	_DEBUG_RANGE(_First, _Last);
	typename std::iterator_traits<_InIt>::difference_type _Cnt = 0;

	for (; !atend(_First); ++_First)
		if (*_First == _Val)
			++_Cnt;
	return (_Cnt);
	}

template<class _InIt, class _Ty> inline
typename std::iterator_traits<_InIt>::difference_type
		PREFIX(count)(_InIt _First, const _Ty& _Val)
	{	// count elements that match _Val
	return _strCount(_CHECKED_BASE(_First), _Val);
	}

		// TEMPLATE FUNCTION count_if
template<class _InIt, class _Pr> inline
typename std::iterator_traits<_InIt>::difference_type
		_strCount_if(_InIt _First, _Pr _Pred)
	{	// count elements satisfying _Pred
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Pred);
	typename std::iterator_traits<_InIt>::difference_type _Count = 0;

	for (; !atend(_First); ++_First)
		if (_Pred(*_First))
			++_Count;
	return (_Count);
	}

template<class _InIt, class _Pr> inline
typename std::iterator_traits<_InIt>::difference_type
		PREFIX(count_if)(_InIt _First, _Pr _Pred)
	{	// count elements satisfying _Pred
	return _strCount_if(_CHECKED_BASE(_First), _Pred);
	}

//----------------------------------------------------------------
//!прикрутить strpbrk wcspbrk
		// TEMPLATE FUNCTION find_first_of
template<class _FwdIt1,	class _FwdIt2> inline
	_FwdIt1 _strFind_first_of(_FwdIt1 _First1, _FwdIt2 _First2)
	{	// look for one of [_First2, _Last2) that matches element
	_DEBUG_RANGE(_First1, _Last1);
	_DEBUG_RANGE(_First2, _Last2);
	for (; !atend(_First1); ++_First1)
		for (_FwdIt2 _Mid2 = _First2; !atend(_Mid2); ++_Mid2)
			if (*_First1 == *_Mid2)
				return (_First1);
	return (_First1);
	}

template<class _FwdIt1,	class _FwdIt2> inline
	_FwdIt1 PREFIX(find_first_of)(_FwdIt1 _First1, _FwdIt2 _First2)
	{	// look for one of [_First2, _Last2) that matches element
	_DEBUG_RANGE(_First1, _Last1);
	_DEBUG_RANGE(_First2, _Last2);
	_ASSIGN_FROM_BASE(_First1,
		_strFind_first_of(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2)));
	return _First1;
	}

		// TEMPLATE FUNCTION find_first_of WITH PRED
template<class _FwdIt1,	class _FwdIt2, class _Pr> inline
	_FwdIt1 _strFind_first_of(_FwdIt1 _First1, _FwdIt2 _First2, _Pr _Pred)
	{	// look for one of [_First2, _Last2) satisfying _Pred with element
	_DEBUG_POINTER(_Pred);
	for (; !atend(_First1); ++_First1)
		for (_FwdIt2 _Mid2 = _First2; !atend(_Mid2); ++_Mid2)
			if (_Pred(*_First1, *_Mid2))
				return (_First1);
	return (_First1);
	}

template<class _FwdIt1,	class _FwdIt2,	class _Pr> inline
	_FwdIt1 PREFIX(find_first_of)(_FwdIt1 _First1, _FwdIt2 _First2, _Pr _Pred)
	{	// look for one of [_First2, _Last2) satisfying _Pred with element
	_ASSIGN_FROM_BASE(_First1,
		_Find_first_of(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2), _Pred));
	return (_First1);
	}

//----------------------------------------------------------------
//специализации не требуется
//сильно упрощена проверка
		// TEMPLATE FUNCTION transform WITH UNARY OP
template<class _InIt, class _OutIt, class _Fn1> inline
	_OutIt _strTransform(_InIt _First, _OutIt _Dest, _Fn1 _Func)
	{	// transform [_First, _Last) with _Func
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Dest);
	_DEBUG_POINTER(_Func);
	for (; !atend(_First); ++_First, ++_Dest)
		*_Dest = _Func(*_First);
	return (_Dest);
	}

template<class _InIt, class _OutIt, class _Fn1> inline
	_OutIt PREFIX(transform)(_InIt _First, _OutIt _Dest, _Fn1 _Func)
	{
	return _strTransform(_CHECKED_BASE(_First), _Dest, _Func);
	}

		// TEMPLATE FUNCTION transform WITH BINARY OP
template<class _InIt1, class _InIt2, class _OutIt, class _Fn2> inline
	_OutIt _strTransform(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest, _Fn2 _Func)
	{	// transform [_First1, _Last1) and [_First2, _Last2) with _Func
	_DEBUG_RANGE(_First1, _Last1);
	_DEBUG_POINTER(_Dest);
	_DEBUG_POINTER(_Func);
	for (; !atend(_First1); ++_First1, ++_First2, ++_Dest)
		*_Dest = _Func(*_First1, *_First2);
	return (_Dest);
	}

template<class _InIt1, class _InIt2, class _OutIt, class _Fn2> inline
	_OutIt PREFIX(transform)(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest, _Fn2 _Func)
	{
	return _strTransform(_CHECKED_BASE(_First1), _First2, _Dest, _Func);
	}

//----------------------------------------------------------------
//специализации отсутствуют для _
//специализации не требуется для if
//сильно упрощены проверки для copy
		// TEMPLATE FUNCTION replace
template<class _FwdIt,	class _Ty> inline
	void _strReplace(_FwdIt _First, const _Ty& _Oldval, const _Ty& _Newval)
	{	// replace each matching _Oldval with _Newval
	_DEBUG_RANGE(_First, _Last);
	for (; !atend(_First); ++_First)
		if (*_First == _Oldval)
			*_First = _Newval;
	}

template<class _FwdIt,	class _Ty> inline
	void PREFIX(replace)(_FwdIt _First, const _Ty& _Oldval, const _Ty& _Newval)
	{	// replace each matching _Oldval with _Newval
	_strReplace(_CHECKED_BASE(_First), _Oldval, _Newval);
	}

		// TEMPLATE FUNCTION replace_if
template<class _FwdIt, class _Pr,	class _Ty> inline
	void _strReplace_if(_FwdIt _First, _Pr _Pred, const _Ty& _Val)
	{	// replace each satisfying _Pred with _Val
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Pred);
	for (; !atend(_First); ++_First)
		if (_Pred(*_First))
			*_First = _Val;
	}

template<class _FwdIt,	class _Pr,	class _Ty> inline
	void PREFIX(replace_if)(_FwdIt _First, _FwdIt _Last, _Pr _Pred, const _Ty& _Val)
	{	// replace each satisfying _Pred with _Val
	_strReplace_if(_CHECKED_BASE(_First), _Pred, _Val);
	}

		// TEMPLATE FUNCTION replace_copy
template<class _InIt, class _OutIt, class _Ty> inline
	_OutIt _strReplace_copy(_InIt _First, _OutIt _Dest,
		const _Ty& _Oldval, const _Ty& _Newval)
	{	// copy replacing each matching _Oldval with _Newval
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Dest);
	for (; !atend(_First); ++_First, ++_Dest)
		*_Dest = *_First == _Oldval ? _Newval : *_First;
	return (_Dest);
	}


template<class _InIt,	class _OutIt,	class _Ty> inline
	_OutIt PREFIX(replace_copy)(_InIt _First, _OutIt _Dest,
		const _Ty& _Oldval, const _Ty& _Newval)
	{	// copy replacing each matching _Oldval with _Newval
	return _strReplace_copy(_CHECKED_BASE(_First), _Dest, _Oldval, _Newval);
	}


		// TEMPLATE FUNCTION replace_copy_if
template<class _InIt, class _OutIt, class _Pr, class _Ty> inline
	_OutIt _strReplace_copy_if(_InIt _First, _OutIt _Dest,
		_Pr _Pred, const _Ty& _Val)
	{	// copy replacing each satisfying _Pred with _Val
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Dest);
	_DEBUG_POINTER(_Pred);
	for (; !atend(_First); ++_First, ++_Dest)
		*_Dest = _Pred(*_First) ? _Val : *_First;
	return (_Dest);
	}

template<class _InIt,	class _OutIt,	class _Pr,	class _Ty> inline
	_OutIt PREFIX(replace_copy_if)(_InIt _First, _OutIt _Dest,
		_Pr _Pred, const _Ty& _Val)
	{	// copy replacing each satisfying _Pred with _Val
	return _strReplace_copy_if(_CHECKED_BASE(_First), _Dest, _Pred, _Val);
	}

//----------------------------------------------------------------
//специализации отсутствуют
//проверка конца строки делается дваждаы за итерацию
		// TEMPLATE FUNCTION adjacent_find
template<class _FwdIt> inline
	_FwdIt _strAdjacent_find(_FwdIt _First)
	{	// find first matching successor
	_DEBUG_RANGE(_First, _Last);
	for (_FwdIt _Firstb; !atend(_Firstb = _First) && !atend(++_First); )
		if (*_Firstb == *_First)
			return (_Firstb);
	return (_First);
	}

template<class _FwdIt> inline
	_FwdIt PREFIX(adjacent_find)(_FwdIt _First)
	{	// find first matching successor
	_ASSIGN_FROM_BASE(_First,
		_strAdjacent_find(_CHECKED_BASE(_First)));
	return (_First);
	}

		// TEMPLATE FUNCTION adjacent_find WITH PRED
template<class _FwdIt,	class _Pr> inline
	_FwdIt _strAdjacent_find(_FwdIt _First, _Pr _Pred)
	{	// find first satisfying _Pred with successor
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Pred);
	for (_FwdIt _Firstb; !atend(_Firstb = _First) && !atend(++_First); )
		if (_Pred(*_Firstb, *_First))
			return (_Firstb);
	return (_First);
	}

template<class _FwdIt,	class _Pr> inline
	_FwdIt PREFIX(adjacent_find)(_FwdIt _First, _Pr _Pred)
	{	// find first satisfying _Pred with successor
	_ASSIGN_FROM_BASE(_First,
		_strAdjacent_find(_CHECKED_BASE(_First), _Pred));
	return (_First);
	}

//----------------------------------------------------------------
//специализации отсутствуют
//для рандом аццесс итератора - не разбирался, 
	//возможно это и эффективнее чем для форвард итератора
//для рандом аццесс итератора - вычисляет end
		// TEMPLATE FUNCTION search_n
template<class _FwdIt1,	class _Diff2,	class _Ty> inline
	_FwdIt1 _strSearch_n(_FwdIt1 _First1, _Diff2 _Count, const _Ty& _Val, 
		std::forward_iterator_tag)
	{	// find first _Count * _Val match, forward iterators
	_DEBUG_RANGE(_First1, _Last1);

	if (_Count <= 0)
		return (_First1);//если размер искомого <=1 то сразу найдено

	for (; !atend(_First1); ++_First1)
		if (*_First1 == _Val)
			{	// found start of possible match, check it out
			_FwdIt1 _Mid1  = _First1;

			for (_Diff2 _Count1 = _Count; ; )
				if (--_Count1 == 0)
					return (_First1);	// found rest of match, report it
				else if (atend(++_Mid1))
					return (_Mid1);	// short match at end
				else if (!(*_Mid1 == _Val))
					break;	// short match not at end

			_First1 = _Mid1;	// pick up just beyond failed match
			}
	return (_First1);
	}

template<class _FwdIt1,	class _Diff2,	class _Ty> inline
	_FwdIt1 _strSearch_n(_FwdIt1 _First1, _Diff2 _Count, const _Ty& _Val, 
		std::random_access_iterator_tag)
	{	// find first _Count * _Val match, random-access iterators
	_DEBUG_RANGE(_First1, _Last1);

	if (_Count <= 0)
		return (_First1);

	_FwdIt1 _Last1=end(_First1);

	_FwdIt1 _Oldfirst1 = _First1;
	for (; _Count <= _Last1 - _Oldfirst1; )
		{	// enough room, look for a match 
		if (*_First1 == _Val)
			{	// found part of possible match, check it out
			_Diff2 _Count1 = _Count;
			_FwdIt1 _Mid1  = _First1;

			for (; _Oldfirst1 != _First1 && _First1[-1] == _Val; --_First1)
				--_Count1;	// back up over any skipped prefix

			if (_Count1 <= _Last1 - _Mid1)
				for (; ; )	// enough left, test suffix
					if (--_Count1 == 0)
						return (_First1);	// found rest of match, report it
					else if (!(*++_Mid1 == _Val))
						break;	// short match not at end

			_Oldfirst1 = ++_Mid1;	// failed match, take small jump
			_First1 = _Oldfirst1;
			}
		else
			{	// no match, take big jump and back up as needed
			_Oldfirst1 = _First1 + 1;
			_First1 += _Count;
			}
		}
	return (_Last1);
	}

template<class _FwdIt1,	class _Diff2,	class _Ty> inline
	_FwdIt1 PREFIX(search_n)(_FwdIt1 _First1, _Diff2 _Count, const _Ty& _Val)
	{	// find first _Count * _Val match
	_ASSIGN_FROM_BASE(_First1,
		_strSearch_n(_CHECKED_BASE(_First1), _Count, _Val,
			_Iter_cat(_First1)));
	return _First1;
	}

		// TEMPLATE FUNCTION search_n WITH PRED
template<class _FwdIt1,	class _Diff2,	class _Ty,	class _Pr> inline
	_FwdIt1 _strSearch_n(_FwdIt1 _First1, _Diff2 _Count, const _Ty& _Val, _Pr _Pred,
		std::forward_iterator_tag)
	{	// find first _Count * _Val satisfying _Pred, forward iterators
	_DEBUG_RANGE(_First1, _Last1);
	_DEBUG_POINTER(_Pred);

	if (_Count <= 0)
		return (_First1);

	for (; !atend(_First1); ++_First1)
		if (_Pred(*_First1, _Val))
			{	// found start of possible match, check it out
			_FwdIt1 _Mid1  = _First1;

			for (_Diff2 _Count1 = _Count; ; )
				if (--_Count1 == 0)
					return (_First1);	// found rest of match, report it
				else if (atend(++_Mid1))
					return (_Mid1);	// short match at end
				else if (!_Pred(*_Mid1, _Val))
					break;	// short match not at end

			_First1 = _Mid1;	// pick up just beyond failed match
			}
	return (_First1);
	}

template<class _FwdIt1,	class _Diff2,	class _Ty,	class _Pr> inline
	_FwdIt1 _strSearch_n(_FwdIt1 _First1, _Diff2 _Count, const _Ty& _Val, _Pr _Pred,
		std::random_access_iterator_tag)
	{	// find first _Count * _Val satisfying _Pred, random-access iterators
	_DEBUG_RANGE(_First1, _Last1);
	_DEBUG_POINTER(_Pred);

	if (_Count <= 0)
		return (_First1);

	_FwdIt1 _Last1=end(_First1);

	_FwdIt1 _Oldfirst1 = _First1;
	for (; _Count <= _Last1 - _Oldfirst1; )
		{	// enough room, look for a match 
		if (_Pred(*_First1, _Val))
			{	// found part of possible match, check it out
			_Diff2 _Count1 = _Count;
			_FwdIt1 _Mid1  = _First1;

			for (; _Oldfirst1 != _First1 && _First1[-1] == _Val; --_First1)
				--_Count1;	// back up over any skipped prefix

			if (_Count1 <= _Last1 - _Mid1)
				for (; ; )	// enough left, test suffix
					if (--_Count1 == 0)
						return (_First1);	// found rest of match, report it
					else if (!_Pred(*++_Mid1, _Val))
						break;	// short match not at end

			_Oldfirst1 = ++_Mid1;	// failed match, take small jump
			_First1 = _Oldfirst1;
			}
		else
			{	// no match, take big jump and back up as needed
			_Oldfirst1 = _First1 + 1;
			_First1 += _Count;
			}
		}
	return (_Last1);
	}

template<class _FwdIt1,	class _Diff2,	class _Ty,	class _Pr> inline
	_FwdIt1 PREFIX(search_n)(_FwdIt1 _First1, _Diff2 _Count, const _Ty& _Val, _Pr _Pred)
	{	// find first _Count * _Val satisfying _Pred
	_ASSIGN_FROM_BASE(_First1,
		_Search_n(_CHECKED_BASE(_First1), _Count, _Val, _Pred,
			_Iter_cat(_First1)));
	return _First1;
	}

//----------------------------------------------------------------
//!прикрутить strstr и wcsstr
//переделан
		// TEMPLATE FUNCTION search
template<class _FwdIt1,	class _FwdIt2> inline
	_FwdIt1 _strSearch(_FwdIt1 _First1, _FwdIt2 _First2)
	{	// find first [_First2, _Last2) match
	_DEBUG_RANGE(_First1, _Last1);
	_DEBUG_RANGE(_First2, _Last2);

	for (; !atend(_First1); ++_First1)
		{	// room for match, try it
		_FwdIt1 _Mid1 = _First1;
		for (_FwdIt2 _Mid2 = _First2; ; ++_Mid1, ++_Mid2)
			if (atend(_Mid2))
				return (_First1);//нашли
			else if (atend(_Mid1))
				return (_Mid1);//не нашли
			else if (!(*_Mid1 == *_Mid2))
				break;//продолжаем пытаться
		}
	return (_First1);
	}

template<class _FwdIt1,	class _FwdIt2> inline
	_FwdIt1 PREFIX(search)(_FwdIt1 _First1, _FwdIt2 _First2)
	{	// find first [_First2, _Last2) match
	_ASSIGN_FROM_BASE(_First1,
		_strSearch(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2)));
	return _First1;
	}

		// TEMPLATE FUNCTION search WITH PRED
template<class _FwdIt1,	class _FwdIt2,	class _Pr> inline
	_FwdIt1 _strSearch(_FwdIt1 _First1, _FwdIt2 _First2, _Pr _Pred)
	{	// find first [_First2, _Last2) satisfying _Pred

	for (; !atend(_First1) ; ++_First1)
		{	// room for match, try it
		_FwdIt1 _Mid1 = _First1;
		for (_FwdIt2 _Mid2 = _First2; ; ++_Mid1, ++_Mid2)
			if (atend(_Mid2))
				return (_First1);//нашли
			else if (atend(_Mid1))
				return (_Mid1);//не нашли
			else if (!_Pred(*_Mid1, *_Mid2))
				break;
		}
	return (_First1);
	}

template<class _FwdIt1,	class _FwdIt2,	class _Pr> inline
	_FwdIt1 PREFIX(search)(_FwdIt1 _First1, _FwdIt2 _First2, _Pr _Pred)
	{	// find first [_First2, _Last2) satisfying _Pred
	_ASSIGN_FROM_BASE(_First1,
		_strSearch(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2), _Pred));
	return _First1;
	}

//----------------------------------------------------------------
//специализации отсутствуют
//сильно переделан
		// TEMPLATE FUNCTION find_end
template<class _FwdIt1,	class _FwdIt2> inline
	_FwdIt1 _strFind_end(_FwdIt1 _First1, _FwdIt2 _First2)
	{	// find last [_First2, _Last2) match
	_DEBUG_RANGE(_First1, _Last1);
	_DEBUG_RANGE(_First2, _Last2);

	_FwdIt1 _Ans;
	bool hasanswer=false;

	for (; !atend(_First1); ++_First1)
		{	// room for match, try it
		_FwdIt1 _Mid1 = _First1;
		for (_FwdIt2 _Mid2 = _First2; ; ++_Mid1, ++_Mid2)
			if (atend(_Mid2))
				{	//нашли
				_Ans = _First1;
				hasanswer=true;
				break;
				}
			else if (atend(_Mid1))
				return hasanswer ? (_Ans) : (_Mid1);	//не нашли
			else if (!(*_Mid1 == *_Mid2))
				break;
		}
	return (_First1);
	}

template<class _FwdIt1,	class _FwdIt2> inline
	_FwdIt1 PREFIX(find_end)(_FwdIt1 _First1, _FwdIt2 _First2)
	{	// find last [_First2, _Last2) match
	_ASSIGN_FROM_BASE(_First1,
		_strFind_end(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2)));
	return _First1;
	}

		// TEMPLATE FUNCTION find_end WITH PRED
template<class _FwdIt1,	class _FwdIt2, class _Pr> inline
	_FwdIt1 _strFind_end(_FwdIt1 _First1, _FwdIt2 _First2, _Pr _Pred)
	{	// find last [_First2, _Last2) satisfying _Pred
	_DEBUG_RANGE(_First1, _Last1);
	_DEBUG_RANGE(_First2, _Last2);
	_DEBUG_POINTER(_Pred);

	_FwdIt1 _Ans;// = _Last1;
	bool hasanswer=false;

	for (; !atend(_First1); ++_First1)
		{	// room for match, try it
		_FwdIt1 _Mid1 = _First1;
		for (_FwdIt2 _Mid2 = _First2; ; ++_Mid1, ++_Mid2)
			if (atend(_Mid2))
				{	//нашли
				_Ans = _First1;
				hasanswer=true;
				break;
				}
			else if (atend(_Mid1))
				return hasanswer ? (_Ans) : (_Mid1);	//не нашли
			else if (!_Pred(*_Mid1, *_Mid2))
				break;
		}
	return (_First1);
	}

template<class _FwdIt1,
	class _FwdIt2,
	class _Pr> inline
	_FwdIt1 PREFIX(find_end)(_FwdIt1 _First1, _FwdIt2 _First2, _Pr _Pred)
	{	// find last [_First2, _Last2) satisfying _Pred
	_ASSIGN_FROM_BASE(_First1,
		_strFind_end(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2), _Pred));
	return _First1;
	}

//----------------------------------------------------------------
//специализации отсутствуют
//проверка сильно упрощена
		// TEMPLATE FUNCTION swap_ranges
template<class _FwdIt1, class _FwdIt2> inline
	_FwdIt2 _strSwap_ranges(_FwdIt1 _First1, _FwdIt2 _First2)
	{	// swap [_First1, _Last1) with [_First2, ...)
	_DEBUG_RANGE(_First1, _Last1);
	for (; !atend(_First1); ++_First1, ++_First2)
		std::iter_swap(_First1, _First2);
	return (_First2);
	}

template<class _FwdIt1, class _FwdIt2> inline
	_FwdIt2 PREFIX(swap_ranges)(_FwdIt1 _First1, _FwdIt2 _First2)
	{
		return _strSwap_ranges(_CHECKED_BASE(_First1), _First2);
	}

//----------------------------------------------------------------
//специализации отсутствуют
//проверка сильно упрощена
		// TEMPLATE FUNCTION remove_copy
template<class _InIt,	class _OutIt,	class _Ty> inline
	_OutIt _strRemove_copy(_InIt _First, _OutIt _Dest, const _Ty& _Val)
	{	// copy omitting each matching _Val
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Dest);
	for (; !atend(_First); ++_First)
		if (!(*_First == _Val))
			*_Dest++ = *_First;
	return (_Dest);
	}

template<class _InIt,	class _OutIt,	class _Ty> inline
	_OutIt PREFIX(remove_copy)(_InIt _First, _OutIt _Dest, const _Ty& _Val)
	{	// copy omitting each matching _Val
	return _strRemove_copy(_CHECKED_BASE(_First), _Dest, _Val);
	}

		// TEMPLATE FUNCTION remove_copy_if
template<class _InIt,	class _OutIt,	class _Pr> inline
	_OutIt _strRemove_copy_if(_InIt _First, _OutIt _Dest, _Pr _Pred)
	{	// copy omitting each element satisfying _Pred
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Dest);
	_DEBUG_POINTER(_Pred);
	for (; !atend(_First); ++_First)
		if (!_Pred(*_First))
			*_Dest++ = *_First;
	return (_Dest);
	}

template<class _InIt,	class _OutIt,	class _Pr> inline
	_OutIt PREFIX(remove_copy_if)(_InIt _First, _OutIt _Dest, _Pr _Pred)
	{	// copy omitting each element satisfying _Pred
	return _strRemove_copy_if(_CHECKED_BASE(_First), _Dest, _Pred);
	}


		// TEMPLATE FUNCTION remove
template<class _InIt,	class _OutIt,	class _Ty> inline
	_OutIt _str_unchecked_remove_copy(_InIt _First, _OutIt _Dest, const _Ty& _Val)
	{	// copy omitting each matching _Val
		return _strRemove_copy(_CHECKED_BASE(_First), _Dest, _Val);
	}

template<class _FwdIt,	class _Ty> inline
	_FwdIt PREFIX(remove)(_FwdIt _First, const _Ty& _Val)
	{	// remove each matching _Val
	_First = PREFIX(find)(_First, _Val);
	if (atend(_First))
		return (_First);	// empty sequence, all done
	else
		{	// nonempty sequence, worth doing
		_FwdIt _First1 = _First;
		return (_str_unchecked_remove_copy(++_First1, _First, _Val));
		}
	}

		// TEMPLATE FUNCTION remove_if
template<class _InIt,	class _OutIt,	class _Pr> inline
	_OutIt _str_unchecked_remove_copy_if(_InIt _First, _OutIt _Dest, _Pr _Pred)
	{	// copy omitting each element satisfying _Pred
		return _strRemove_copy_if(_CHECKED_BASE(_First), _Dest, _Pred);
	}

	template<class _FwdIt,	class _Pr> inline
	_FwdIt PREFIX(remove_if)(_FwdIt _First, _Pr _Pred)
	{	// remove each satisfying _Pred
	_First = PREFIX(find_if)(_First, _Pred);
	if (atend(_First))
		return (_First);	// empty sequence, all done
	else
		{	// nonempty sequence, worth doing
		_FwdIt _First1 = _First;
		return (_str_unchecked_remove_copy_if(++_First1, _First, _Pred));
		}
	}

//----------------------------------------------------------------
//специализации отсутствуют
//проверка сильно упрощена
//2 раза за итерацию проверяет конец
		// TEMPLATE FUNCTION unique
template<class _FwdIt> inline
	_FwdIt _strUnique(_FwdIt _First)
	{	// remove each matching previous
	_DEBUG_RANGE(_First, _Last);
	for (_FwdIt _Firstb; !atend(_Firstb = _First) && !atend(++_First); )
		if (*_Firstb == *_First)
			{	// copy down
			for (; !atend(++_First); )
				if (!(*_Firstb == *_First))
					*++_Firstb = *_First;
			return (++_Firstb);
			}
	return atend(_First) ? (_First) : (++_First);
	}

template<class _FwdIt> inline
	_FwdIt PREFIX(unique)(_FwdIt _First)
	{	// remove each matching previous
	_ASSIGN_FROM_BASE(_First,
		_strUnique(_CHECKED_BASE(_First)));
	return (_First);
	}

		// TEMPLATE FUNCTION unique WITH PRED
template<class _FwdIt,	class _Pr> inline
	_FwdIt _strUnique(_FwdIt _First, _Pr _Pred)
	{	// remove each satisfying _Pred with previous
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Pred);
	for (_FwdIt _Firstb; !atend(_Firstb = _First) && !atend(++_First); )
		if (_Pred(*_Firstb, *_First))
			{	// copy down
			for (; !atend(++_First); )
				if (!_Pred(*_Firstb, *_First))
					*++_Firstb = *_First;
			return (++_Firstb);
			}
	return atend(_First) ? (_First) : (++_First);
	}

template<class _FwdIt,	class _Pr> inline
	_FwdIt PREFIX(unique)(_FwdIt _First, _Pr _Pred)
	{	// remove each satisfying _Pred with previous
	_ASSIGN_FROM_BASE(_First,
		_strUnique(_CHECKED_BASE(_First), _Pred));
	return (_First);
	}

		// TEMPLATE FUNCTION unique_copy
template<class _InIt,	class _OutIt,	
		class _Ty> inline
	_OutIt _strUnique_copy(_InIt _First, _OutIt _Dest, 
		_Ty *)
	{	// copy compressing pairs that match, input iterators
	_DEBUG_POINTER(_Dest);
	_Ty _Val = *_First;

	for (*_Dest++ = _Val; !atend(++_First); )
		if (!(_Val == *_First))
			_Val = *_First, *_Dest++ = _Val;
	return (_Dest);
	}

template<class _InIt,	class _OutIt> inline
	_OutIt _strUnique_copy(_InIt _First, _OutIt _Dest,	
		std::input_iterator_tag)
	{	// copy compressing pairs that match, input iterators
	return (_strUnique_copy(_First, _Dest, 
				_Val_type(_First)));
	}

template<class _FwdIt,	class _OutIt> inline
	_OutIt _strUnique_copy(_FwdIt _First, _OutIt _Dest,	
		std::forward_iterator_tag)
	{	// copy compressing pairs that match, forward iterators
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Dest);
	_FwdIt _Firstb = _First;
	for (*_Dest++ = *_Firstb; !atend(++_First); )
		if (!(*_Firstb == *_First))
			_Firstb = _First, *_Dest++ = *_Firstb;
	return (_Dest);
	}

template<class _BidIt,	class _OutIt> inline
	_OutIt _strUnique_copy(_BidIt _First, _OutIt _Dest,	
		std::bidirectional_iterator_tag)
	{	// copy compressing pairs that match, bidirectional iterators
	return (_strUnique_copy(_First, _Dest, 
				std::forward_iterator_tag()));
	}

template<class _RanIt,	class _OutIt> inline
	_OutIt _strUnique_copy(_RanIt _First, _OutIt _Dest, 
		std::random_access_iterator_tag)
	{	// copy compressing pairs that match, random-access iterators
	return (_strUnique_copy(_First, _Dest, 
				std::forward_iterator_tag()));
	}

template<class _InIt,	class _OutIt> inline
	_OutIt PREFIX(unique_copy)(_InIt _First, _OutIt _Dest)
	{	// copy compressing pairs that match
	return (atend(_First) ? _Dest :
		_strUnique_copy(_CHECKED_BASE(_First), _Dest, 
			_Iter_cat(_First)));
	}


		// TEMPLATE FUNCTION unique_copy WITH PRED
template<class _InIt,	class _OutIt,	class _Pr, 
		class _Ty> inline
	_OutIt _strUnique_copy(_InIt _First, _OutIt _Dest, _Pr _Pred, 
		_Ty *)
	{	// copy compressing pairs satisfying _Pred, input iterators
	_DEBUG_POINTER(_Dest);
	_DEBUG_POINTER(_Pred);
	_Ty _Val = *_First;

	for (*_Dest++ = _Val; !atend(++_First); )
		if (!_Pred(_Val, *_First))
			_Val = *_First, *_Dest++ = _Val;
	return (_Dest);
	}

template<class _InIt,	class _OutIt,	class _Pr> inline
	_OutIt _strUnique_copy(_InIt _First, _OutIt _Dest, _Pr _Pred,
		std::input_iterator_tag)
	{	// copy compressing pairs satisfying _Pred, input iterators
	return (_strUnique_copy(_First, _Dest, _Pred, _Val_type(_First)));
	}

template<class _FwdIt,	class _OutIt,	class _Pr> inline
	_OutIt _strUnique_copy(_FwdIt _First, _OutIt _Dest, _Pr _Pred,
		std::forward_iterator_tag)
	{	// copy compressing pairs satisfying _Pred, forward iterators
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Dest);
	_DEBUG_POINTER(_Pred);
	_FwdIt _Firstb = _First;

	for (*_Dest++ = *_Firstb; !atend(++_First); )
		if (!_Pred(*_Firstb, *_First))
			_Firstb = _First, *_Dest++ = *_Firstb;
	return (_Dest);
	}

template<class _BidIt,	class _OutIt,	class _Pr> inline
	_OutIt _strUnique_copy(_BidIt _First, _OutIt _Dest, _Pr _Pred,
		std::bidirectional_iterator_tag)
	{	// copy compressing pairs satisfying _Pred, bidirectional iterators
	return (_strUnique_copy(_First, _Dest, _Pred,
				std::forward_iterator_tag()));
	}

template<class _RanIt,	class _OutIt,	class _Pr> inline
	_OutIt _strUnique_copy(_RanIt _First, _OutIt _Dest, _Pr _Pred,
		std::random_access_iterator_tag)
	{	// copy compressing pairs satisfying _Pred, random-access iterators
	return (_strUnique_copy(_First, _Dest, _Pred,
				std::forward_iterator_tag()));
	}

template<class _InIt,	class _OutIt,	class _Pr> inline
	_OutIt PREFIX(unique_copy)(_InIt _First, _OutIt _Dest, _Pr _Pred)
	{	// copy compressing pairs satisfying _Pred
	return (atend(_First) ? _Dest
		: _strUnique_copy(_CHECKED_BASE(_First), _Dest, _Pred, 
				_Iter_cat(_First)));
	}

//----------------------------------------------------------------
//специализации отсутствуют
		// TEMPLATE FUNCTION max_element
template<class _FwdIt> inline
	_FwdIt _strMax_element(_FwdIt _First)
	{	// find largest element, using operator<
	_DEBUG_RANGE(_First, _Last);
	_FwdIt _Found = _First;
	if (!atend(_First))
		for (; !atend(++_First); )
			if (_DEBUG_LT(*_Found, *_First))
				_Found = _First;
	return (_Found);
	}

template<class _FwdIt> inline
	_FwdIt PREFIX(max_element)(_FwdIt _First)
	{	// find largest element, using operator<
	_ASSIGN_FROM_BASE(_First,
		_Max_element(_CHECKED_BASE(_First)));
	return (_First);
	}

		// TEMPLATE FUNCTION max_element WITH PRED
template<class _FwdIt,	class _Pr> inline
	_FwdIt _strMax_element(_FwdIt _First, _Pr _Pred)
	{	// find largest element, using _Pred
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Pred);
	_FwdIt _Found = _First;
	if (!atend(_First))
		for (; !atend(++_First); )
			if (_DEBUG_LT_PRED(_Pred, *_Found, *_First))
				_Found = _First;
	return (_Found);
	}

template<class _FwdIt,
	class _Pr> inline
	_FwdIt PREFIX(max_element)(_FwdIt _First, _Pr _Pred)
	{	// find largest element, using _Pred
	_ASSIGN_FROM_BASE(_First,
		_strMax_element(_CHECKED_BASE(_First), _Pred));
	return (_First);
	}

		// TEMPLATE FUNCTION min_element
template<class _FwdIt> inline
	_FwdIt _strMin_element(_FwdIt _First)
	{	// find smallest element, using operator<
	_DEBUG_RANGE(_First, _Last);
	_FwdIt _Found = _First;
	if (!atend(_First))
		for (; !atend(++_First); )
			if (_DEBUG_LT(*_First, *_Found))
				_Found = _First;
	return (_Found);
	}

template<class _FwdIt> inline
	_FwdIt PREFIX(min_element)(_FwdIt _First, _FwdIt _Last)
	{	// find smallest element, using operator<
	_ASSIGN_FROM_BASE(_First,
		_strMin_element(_CHECKED_BASE(_First)));
	return (_First);
	}

		// TEMPLATE FUNCTION min_element WITH PRED
template<class _FwdIt,	class _Pr> inline
	_FwdIt _strMin_element(_FwdIt _First, _Pr _Pred)
	{	// find smallest element, using _Pred
	_DEBUG_RANGE(_First, _Last);
	_DEBUG_POINTER(_Pred);
	_FwdIt _Found = _First;
	if (!atend(_First))
		for (; !atend(++_First); )
			if (_DEBUG_LT_PRED(_Pred, *_First, *_Found))
				_Found = _First;
	return (_Found);
	}

template<class _FwdIt,	class _Pr> inline
	_FwdIt PREFIX(min_element)(_FwdIt _First, _Pr _Pred)
	{	// find smallest element, using _Pred
	_ASSIGN_FROM_BASE(_First,
		_strMin_element(_CHECKED_BASE(_First), _Pred));
	return (_First);
	}

//----------------------------------------------------------------
//специализации отсутствуют
//проверка сильно упрощена
		// TEMPLATE FUNCTION merge
template<class _InIt1, class _InIt2, class _OutIt> inline
	_OutIt _strMerge(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest)
	{	// copy merging ranges, both using operator<
	_DEBUG_ORDER(_First1, _Last1);
	_DEBUG_ORDER(_First2, _Last2);
	_DEBUG_POINTER(_Dest);
	for (; !atend(_First1) && !atend(_First2) ; ++_Dest)
		if (_DEBUG_LT(*_First2, *_First1))
			*_Dest = *_First2, ++_First2;
		else
			*_Dest = *_First1, ++_First1;

	_Dest = PREFIX(copy)(_First1, _Dest);	// copy any tail
	return (PREFIX(copy)(_First2, _Dest));
	}

template<class _InIt1,	class _InIt2,	class _OutIt> inline
	_OutIt PREFIX(merge)(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest)
	{	// copy merging ranges, both using operator<
	return _strMerge(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2), _Dest);
	}

		// TEMPLATE FUNCTION merge WITH PRED
template<class _InIt1, class _InIt2, class _OutIt, class _Pr> inline
	_OutIt _strMerge(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest, _Pr _Pred)
	{	//  copy merging ranges, both using _Pred
	_DEBUG_ORDER_PRED(_First1, _Last1, _Pred);
	_DEBUG_ORDER_PRED(_First2, _Last2, _Pred);
	_DEBUG_POINTER(_Dest);
	for (; !atend(_First1) && !atend(_First2); ++_Dest)
		if (_DEBUG_LT_PRED(_Pred, *_First2, *_First1))
			*_Dest = *_First2, ++_First2;
		else
			*_Dest = *_First1, ++_First1;

	_Dest = PREFIX(copy)(_First1, _Dest);	// copy any tail
	return (PREFIX(copy)(_First2, _Dest));
	}

template<class _InIt1,	class _InIt2,	class _OutIt,	class _Pr> inline
	_OutIt PREFIX(merge)(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest, _Pr _Pred)
	{	//  copy merging ranges, both using _Pred
	return _strMerge(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2), _Dest, _Pred);
	}

//----------------------------------------------------------------
//специализации отсутствуют
//проверка сильно упрощена
		// TEMPLATE FUNCTION includes
template<class _InIt1,	class _InIt2> inline
	bool _strIncludes(_InIt1 _First1, _InIt2 _First2)
	{	// test if all [_First1, _Last1) in [_First2, _Last2), using operator<
	_DEBUG_ORDER(_First1, _Last1);
	_DEBUG_ORDER(_First2, _Last2);
	for (; !atend(_First1) && !atend(_First2); )
		if (_DEBUG_LT(*_First2, *_First1))
			return (false);
		else if (*_First1 < *_First2)
			++_First1;
		else
			++_First1, ++_First2;
	return atend(_First2);
	}

template<class _InIt1,	class _InIt2> inline
	bool PREFIX(includes)(_InIt1 _First1, _InIt2 _First2)
	{	// test if all [_First1, _Last1) in [_First2, _Last2), using operator<
	return _strIncludes(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2));
	}

		// TEMPLATE FUNCTION includes WITH PRED
template<class _InIt1,	class _InIt2,	class _Pr> inline
	bool _strIncludes(_InIt1 _First1, _InIt2 _First2, _Pr _Pred)
	{	// test if set [_First1, _Last1) in [_First2, _Last2), using _Pred
	_DEBUG_ORDER_PRED(_First1, _Last1, _Pred);
	_DEBUG_ORDER_PRED(_First2, _Last2, _Pred);
	for (; !atend(_First1) && !atend(_First2); )
		if (_DEBUG_LT_PRED(_Pred, *_First2, *_First1))
			return (false);
		else if (_Pred(*_First1, *_First2))
			++_First1;
		else
			++_First1, ++_First2;
	return atend(_First2);
	}

template<class _InIt1,	class _InIt2,	class _Pr> inline
	bool PREFIX(includes)(_InIt1 _First1, _InIt2 _First2, _Pr _Pred)
	{	// test if set [_First1, _Last1) in [_First2, _Last2), using _Pred
	return _strIncludes(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2), _Pred);
	}

		// TEMPLATE FUNCTION set_union
template<class _InIt1,	class _InIt2,	class _OutIt> inline
	_OutIt _strSet_union(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest)
	{	// OR sets [_First1, _Last1) and [_First2, _Last2), using operator<
	_DEBUG_ORDER(_First1, _Last1);
	_DEBUG_ORDER(_First2, _Last2);
	_DEBUG_POINTER(_Dest);
	for (; !atend(_First1) && !atend(_First2); )
		if (_DEBUG_LT(*_First1, *_First2))
			*_Dest++ = *_First1, ++_First1;
		else if (*_First2 < *_First1)
			*_Dest++ = *_First2, ++_First2;
		else
			*_Dest++ = *_First1, ++_First1, ++_First2;
	_Dest = PREFIX(copy)(_First1, _Dest);
	return (PREFIX(copy)(_First2, _Dest));
	}

template<class _InIt1,	class _InIt2,	class _OutIt> inline
	_OutIt set_union(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest)
	{	// OR sets [_First1, _Last1) and [_First2, _Last2), using operator<
	return _strSet_union(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2), _Dest);
	}

		// TEMPLATE FUNCTION set_union WITH PRED
template<class _InIt1,	class _InIt2,	class _OutIt,	class _Pr> inline
	_OutIt _strSet_union(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest, _Pr _Pred)
	{	// OR sets [_First1, _Last1) and [_First2, _Last2), using _Pred
	_DEBUG_ORDER_PRED(_First1, _Last1, _Pred);
	_DEBUG_ORDER_PRED(_First2, _Last2, _Pred);
	_DEBUG_POINTER(_Dest);
	for (; !atend(_First1) && !atend(_First2); )
		if (_DEBUG_LT_PRED(_Pred, *_First1, *_First2))
			*_Dest++ = *_First1, ++_First1;
		else if (_Pred(*_First2, *_First1))
			*_Dest++ = *_First2, ++_First2;
		else
			*_Dest++ = *_First1, ++_First1, ++_First2;
	_Dest = PREFIX(copy)(_First1, _Dest);
	return (PREFIX(copy)(_First2, _Dest));
	}

template<class _InIt1,	class _InIt2,	class _OutIt,	class _Pr> inline
	_OutIt PREFIX(set_union)(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest, _Pr _Pred)
	{	// OR sets [_First1, _Last1) and [_First2, _Last2), using _Pred
	return _strSet_union(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2), _Dest, _Pred);
	}

		// TEMPLATE FUNCTION set_intersection
template<class _InIt1,	class _InIt2,	class _OutIt> inline
	_OutIt _strSet_intersection(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest)
	{	// AND sets [_First1, _Last1) and [_First2, _Last2), using operator<
	_DEBUG_ORDER(_First1, _Last1);
	_DEBUG_ORDER(_First2, _Last2);
	_DEBUG_POINTER(_Dest);
	for (; !atend(_First1) && !atend(_First2); )
		if (_DEBUG_LT(*_First1, *_First2))
			++_First1;
		else if (*_First2 < *_First1)
			++_First2;
		else
			*_Dest++ = *_First1++, ++_First2;
	return (_Dest);
	}

template<class _InIt1,	class _InIt2,	class _OutIt> inline
	_OutIt PREFIX(set_intersection)(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest)
	{	// AND sets [_First1, _Last1) and [_First2, _Last2), using operator<
	return _strSet_intersection(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2), _Dest);
	}

		// TEMPLATE FUNCTION set_intersection WITH PRED
template<class _InIt1,	class _InIt2,	class _OutIt,	class _Pr> inline
	_OutIt _strSet_intersection(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest, 
		_Pr _Pred)
	{	// AND sets [_First1, _Last1) and [_First2, _Last2), using _Pred
	_DEBUG_ORDER_PRED(_First1, _Last1, _Pred);
	_DEBUG_ORDER_PRED(_First2, _Last2, _Pred);
	_DEBUG_POINTER(_Dest);
	for (; !atend(_First1) && !atend(_First2); )
		if (_DEBUG_LT_PRED(_Pred, *_First1, *_First2))
			++_First1;
		else if (_Pred(*_First2, *_First1))
			++_First2;
		else
			*_Dest++ = *_First1++, ++_First2;
	return (_Dest);
	}

template<class _InIt1,	class _InIt2,	class _OutIt,	class _Pr> inline
	_OutIt PREFIX(set_intersection)(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest, 
		_Pr _Pred)
	{	// AND sets [_First1, _Last1) and [_First2, _Last2), using _Pred
	return _strSet_intersection(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2), 
		_Dest, _Pred);
	}

		// TEMPLATE FUNCTION set_difference
template<class _InIt1,	class _InIt2,	class _OutIt> inline
	_OutIt _strSet_difference(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest)
	{	// take set [_First2, _Last2) from [_First1, _Last1), using operator<
	_DEBUG_ORDER(_First1, _Last1);
	_DEBUG_ORDER(_First2, _Last2);
	_DEBUG_POINTER(_Dest);
	for (; !atend(_First1) && !atend(_First2); )
		if (_DEBUG_LT(*_First1, *_First2))
			*_Dest++ = *_First1, ++_First1;
		else if (*_First2 < *_First1)
			++_First2;
		else
			++_First1, ++_First2;
	return (PREFIX(copy)(_First1, _Dest));
	}

template<class _InIt1,	class _InIt2,	class _OutIt> inline
	_OutIt PREFIX(set_difference)(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest)
	{	// take set [_First2, _Last2) from [_First1, _Last1), using operator<
	return _strSet_difference(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2), _Dest);
	}

		// TEMPLATE FUNCTION set_difference WITH PRED
template<class _InIt1,	class _InIt2,	class _OutIt,	class _Pr> inline
	_OutIt _strSet_difference(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest, _Pr _Pred)
	{	//  take set [_First2, _Last2) from [_First1, _Last1), using _Pred
	_DEBUG_ORDER_PRED(_First1, _Last1, _Pred);
	_DEBUG_ORDER_PRED(_First2, _Last2, _Pred);
	_DEBUG_POINTER(_Dest);
	for (; !atend(_First1) && !atend(_First2); )
		if (_DEBUG_LT_PRED(_Pred, *_First1, *_First2))
			*_Dest++ = *_First1, ++_First1;
		else if (_Pred(*_First2, *_First1))
			++_First2;
		else
			++_First1, ++_First2;
	return (PREFIX(copy)(_First1, _Dest));
	}

template<class _InIt1,	class _InIt2,	class _OutIt,	class _Pr> inline
	_OutIt PREFIX(set_difference)(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest,
		_Pr _Pred)
	{	//  take set [_First2, _Last2) from [_First1, _Last1), using _Pred
	return _strSet_difference(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2),
		_Dest, _Pred);
	}

		// TEMPLATE FUNCTION set_symmetric_difference
template<class _InIt1,	class _InIt2,	class _OutIt> inline
	_OutIt _strSet_symmetric_difference(_InIt1 _First1, _InIt2 _First2, _OutIt _Dest)
	{	// XOR sets [_First1, _Last1) and [_First2, _Last2), using operator<
	_DEBUG_ORDER(_First1, _Last1);
	_DEBUG_ORDER(_First2, _Last2);
	_DEBUG_POINTER(_Dest);
	for (; !atend(_First1) && !atend(_First2); )
		if (_DEBUG_LT(*_First1, *_First2))
			*_Dest++ = *_First1, ++_First1;
		else if (*_First2 < *_First1)
			*_Dest++ = *_First2, ++_First2;
		else
			++_First1, ++_First2;
	_Dest = PREFIX(copy)(_First1, _Dest);
	return (PREFIX(copy)(_First2, _Dest));
	}

template<class _InIt1,	class _InIt2,	class _OutIt> inline
	_OutIt PREFIX(set_symmetric_difference)(_InIt1 _First1, _InIt2 _First2,
		_OutIt _Dest)
	{	// XOR sets [_First1, _Last1) and [_First2, _Last2), using operator<
	return _strSet_symmetric_difference(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2),
		_Dest);
	}

		// TEMPLATE FUNCTION set_symmetric_difference WITH PRED
template<class _InIt1,	class _InIt2,	class _OutIt,	class _Pr> inline
	_OutIt _strSet_symmetric_difference(_InIt1 _First1, _InIt2 _First2,
		_OutIt _Dest, _Pr _Pred)
	{	// XOR sets [_First1, _Last1) and [_First2, _Last2), using _Pred
	_DEBUG_ORDER_PRED(_First1, _Last1, _Pred);
	_DEBUG_ORDER_PRED(_First2, _Last2, _Pred);
	_DEBUG_POINTER(_Dest);
	for (; !atend(_First1) && !atend(_First2); )
		if (_DEBUG_LT_PRED(_Pred, *_First1, *_First2))
			*_Dest++ = *_First1, ++_First1;
		else if (_Pred(*_First2, *_First1))
			*_Dest++ = *_First2, ++_First2;
		else
			++_First1, ++_First2;
	_Dest = PREFIX(copy)(_First1, _Dest);
	return (PREFIX(copy)(_First2, _Dest));
	}

template<class _InIt1,	class _InIt2,	class _OutIt,	class _Pr> inline
	_OutIt PREFIX(set_symmetric_difference)(_InIt1 _First1, _InIt2 _First2,
		_OutIt _Dest, _Pr _Pred)
	{	// XOR sets [_First1, _Last1) and [_First2, _Last2), using _Pred
	return _strSet_symmetric_difference(_CHECKED_BASE(_First1), _CHECKED_BASE(_First2),
		_Dest, _Pred);
	}

}//str

#ifdef _TMP_DEBUG_RANGE
#	undef _DEBUG_RANGE
#	define  _DEBUG_RANGE(first,last) _TMP_DEBUG_RANGE(first,last)
#	undef  _TMP_DEBUG_RANGE
#endif
#ifdef _TMP_DEBUG_ORDER
#	undef _DEBUG_ORDER
#	define  _DEBUG_ORDER(first,last) _TMP_DEBUG_ORDER(first,last)
#	undef  _TMP_DEBUG_ORDER
#endif
#ifdef _TMP_DEBUG_ORDER_PRED
#	undef _DEBUG_ORDER_PRED
#	define  _DEBUG_ORDER_PRED(first,last,pred) _TMP_DEBUG_ORDER_PRED(first,last,pred)
#	undef  _TMP_DEBUG_ORDER_PRED
#endif

#undef PREFIX

#endif//FCJALG_H
