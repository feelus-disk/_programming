//(c) FeelUs
#ifndef MYSTREAM_H
#define MYSTREAM_H

/*
*/
//=============================================================================
/*
todo
проверить отличие перегрузки и специализации
полноценный stream_ifw без ускорений unused
чтоб stream_buffer использовал аллокатор
специализировать для него str.h
избрести(design) алгоритмы парсинга
потестировать на деле
-----------------------
изучить интерфейс стандартных потоков
изучить устройство потоков stlport
написать реализацию strin
-----------------------
написать остальные потоки
написать алгоритмы простого вывода
	и чтобы с stdio & stdout было все хорошо
	добавить capacity, unused, advance, distance
	перекодировку, многобайтовые строки
попробовать адаптировать обычные строки или написать свои
	написать для них все специализации
допилить вывод (всякие манипуляторы), локали не использовать
перекодировку, автоматически от локали...
а еще c++11...
а еще тестировать...
-----------------------
*/
//#include <deque>
#include <assert.h>
#include <stdio.h>
#include <memory>
#include <iterator>
#include <list>
using std::list;

namespace str
{
template<class T,
	class A>
class basic_stream_ifw;
	
		//forward defs
template<class T, class Alloc>
class _stream_ifw_const_iterator;
template<class T, class Alloc>
class _stream_ifw_iterator;

		//CLASS _stream_buffer
template <class T, class Alloc>
struct _stream_buffer
{
	T * begin, * end;
	int iterator_counter;
	int nomber;
	basic_stream_ifw<T,Alloc> * mybase;
	//можно добавить конструктор и деструктор, но всем(т.е. мне) похуй
	void alloc(int bs)
	{
		begin=Alloc().allocate(bs);
		end=begin+bs;
	}
	void dealloc()
	{
		Alloc().deallocate(begin);	
		begin=0;
	}
};
		
//--**-- CONTEINER stream_ifw --**--
template<class T, class Alloc = std::allocator<T> >
class basic_stream_ifw
{
	friend class _stream_ifw_iterator<T,Alloc>;
	friend class _stream_ifw_const_iterator<T,Alloc>;
		//TYPE DEFINES
public:
	typedef T									value_type;
	typedef typename Alloc::size_type			size_type;
	typedef typename Alloc::difference_type		difference_type;
	typedef typename Alloc::pointer				pointer;
	typedef typename Alloc::const_pointer		const_pointer;
	typedef typename Alloc::reference			reerence;
	typedef typename Alloc::const_reference		const_reerence;
	typedef _stream_ifw_iterator<T,Alloc>		iterator;
	typedef _stream_ifw_const_iterator<T,Alloc>	const_iterator;
private:
	typedef basic_stream_ifw<T,Alloc> my_t;
	typedef _stream_buffer<T,Alloc>	Buf;
		//DATA DEFINES
	size_type _buffer_size;//обязательно >0
	list<Buf> bufs;
	FILE * _file;
	bool _atend;//if true end is (--_buf.end())->end
		//CLOSED MEMBERS
	my_t & operator=(const my_t &);
	stream_ifw(const my_t &);
		//PRIVATE MEMBERS
	typename list<Buf>::iterator addbuf()
	//читает новый буфер, и настраивает его номер
	//если прочитано 0 - уничтожет этот буфер, возвращает bufs.end() //это означает конец файла
	//иначе возвращает ук-тель(итератор) на этот буфер
	{	bufs.push_back(Buf());
		typename list<Buf>::iterator pb=--bufs.end(), ppb=pb;
		pb->iterator_counter=0;
		pb->nomber = (pb==bufs.begin())? 0 : (--ppb)->nomber+1;
		pb->alloc(_buffer_size);
		int readed = fread(pb->begin,sizeof(T),_buffer_size,_file);
		if(readed!=_buffer_size)
		{//добрались до конца
			if(!feof(_file))	throw "some error in reading file";
			_atend=true;
			pb->end=pb->begin+readed;
			if(readed==0)
			{
				pb->dealloc();
				bufs.pop_front();
				pb=bufs.end();
			}
		}
		return pb;
	}
	void del_it_from_buf(typename list<Buf>::iterator itbuf)
	//если надо - удаляет буфер
	{
		if(--itbuf->iterator_counter==0 && itbuf==bufs.begin())
		{
			itbuf->dealloc();
			bufs.pop_front();
		}
	}
public:	//PUBLIC MEMBERS
	basic_stream_ifw(FILE * f)	
		:_file(f)
		,_buffer_size(Alloc().init_page_size()) 
		,_atend(false)
	{}
	//нет итераторов - нет буферов
	//=> перед концом области, где объявлены и контейнер и итераторы
	//все итераторы должны дойти до конца (контейнер и итераторы уничтожаются в произвольном порядке)
	//итерторы дошедшие до конца с потоком не связаны
	~stream_ifw()
	{
		assert(bufs.empty());
		//если потом начнут разрушаться итераторы - это пиздец
	}
	//пустых буферов не бывает
	iterator buf_first()
	{
		if(bufs.empty())//при самом старте
			addbuf();
		iterator it;
		if((it.itbuf=bufs.begin()) != bufs.end())
		{//вдруг при самом старте прочли 0 элементов или 
			it.pointer=it.itbuf->begin;
			it.endbuf=it.itbuf->end;
			++it.itbuf->iterator_counter;
		}
		return it;
	}
	iterator buf_last()
	{
		if(bufs.empty())//при самом старте
			addbuf();
		iterator it;
		if(bufs.begin() != (it.buf=bufs.end()))
		{//вдруг при самом старте прочли 0 элементов или 
			--it.buf;
			it.pointer=it.itbuf->end-1;
			it.endbuf=it.itbuf->end;
			++it.itbuf->iterator_counter;
		}
		return it;
	}
	int buffer_size()
	{	return _buffer_size;	}
	int buffer_size(int new_size)
	{	
		assert(new_size>0);
		int old_size=_buffer_size;
		_buffer_size=new_size;
		return old_size;
	}
	bool empty()
	{	return bufs.empty();	}
	bool atend()
	{	return _atend;	}
};

//--**-- ITERATOR _stream_ifw_const_iterator --**--
template<class T, class Alloc>
class _stream_ifw_const_iterator
	:public std::iterator<
		std::forward_iterator_tag,
		T,
		typename Alloc::difference_type,
		typename Alloc::pointer,
		typename Alloc::reference
	>
{
	friend class stream_ifw<T,Alloc>;
	friend class _stream_ifw_iterator<T,Alloc>;
		//private TYPEDEFS
	typedef _stream_buffer<T,Alloc>	Buf;
	typedef _stream_ifw_const_iterator<T,Alloc> my_t;
		//DATA
	T * pointer;//==0 <=> atend
	T * endbuf;//==0 <=> не связан ни с каким буфером
	typename list<Buf>::iterator itbuf;
public:
		//CONSTRUCTION, DESTRUCTION
	_stream_ifw_const_iterator()	:pointer(0),endbuf(0){}
	_stream_ifw_const_iterator(const my_t & r)
		:pointer(r.pointer)
		,endbuf(r.endbuf)
		,itbuf(r.itbuf)
	{
		itbuf->iterator_counter++;
	}
	my_t & operator=(const my_t & r)
	{//можно оптимизировать
		this->~_stream_ifw_const_iterator();
		pointer=r.pointer;
		endbuf=r.endbuf;
		itbuf=r.itbuf;
		itbuf->iterator_counter++;
		return * this;
	}
	~_stream_ifw_const_iterator()
	{
		itbuf->mybase->del_it_from_buf(itbuf);
		pointer=0;
		endbuf=0;
	}
		//ACCESS
	const T & operator*()const
	{	return *pointer;	}
	const T * operator->()const
	{	return pointer;	}
		//MOVING
	my_t & operator++()
	{	// ++myInstance. 
		if(++pointer ==endbuf)//конец внутри буфера
		{
			stream_ifw<T,Alloc> * mybase=itbuf->mybase;
			typename list<Buf>::iterator oldbuf=itbuf++;
			if(itbuf==mybase->bufs.end())
				if(mybase->atend)//конец буферов и конец файла
					this->~_stream_ifw_const_iterator();
				else if((itbuf=mybase->addbuf())==mybase->bufs.end())//конец буферов и оказался конец файла
					this->~_stream_ifw_const_iterator();
				else
					goto normal_next_buffer;
			else
			{
normal_next_buffer:
				itbuf->iterator_counter++;
				pointer=itbuf->begin;
				endbuf=itbuf->end;
			}
			mybase->del_it_from_buf(oldbuf);
		}
		return * this;   
	}
	my_t operator++(int)
	{	// myInstance++.
		my_t orig = *this;
		++(*this);
		return orig;
	}
		//ARITHMETIC
	bool operator==(const my_t & r)const
	{
		return itbuf==r.itbuf && pointer==r.pointer;
	}
	bool operator<(const my_t & r)const
	{
		assert(itbuf->mybase==r.itbuf->mybase);
		if(itbuf->nomber<r.itbuf->nomber)
			return true;
		else if(itbuf->nomber==r.itbuf->nomber)
			return pointer<r.pointer;
		else
			return false;
	}
};
//--**-- TEMPLATE CLASS _stream_ifw_iterator --**--
template<class T, class Alloc>
class _stream_ifw_iterator
	:public std::iterator<
		std::forward_iterator_tag,
		T,
		typename Alloc::difference_type,
		typename Alloc::pointer,
		typename Alloc::reference
	>
{
	friend class stream_ifw<T,Alloc>;
	friend class _stream_ifw_const_iterator<T,Alloc>;
		//private TYPEDEFS
	typedef _stream_buffer<T,Alloc>	Buf;
	typedef _stream_ifw_iterator<T,Alloc> my_t;
//далее копия с const_iterator'а, с удаленными const в разделе ACCESS и CONSTRUCTION и во всех вызовах деструкторов 
		//DATA
	T * pointer;//==0 <=> atend
	T * endbuf;//==0 <=> не связан ни с каким буфером
	typename list<Buf>::iterator itbuf;
public:
		//CONSTRUCTION, DESTRUCTION
	_stream_ifw_iterator()	:pointer(0),endbuf(0){}
	_stream_ifw_iterator(const my_t & r)
		:pointer(r.pointer)
		,endbuf(r.endbuf)
		,itbuf(r.itbuf)
	{
		itbuf->iterator_counter++;
	}
	my_t & operator=(const my_t & r)
	{//можно оптимизировать
		this->~_stream_ifw_iterator();
		pointer=r.pointer;
		endbuf=r.endbuf;
		itbuf=r.itbuf;
		itbuf->iterator_counter++;
		return * this;
	}
	~_stream_ifw_iterator()
	{
		itbuf->mybase->del_it_from_buf(itbuf);
		pointer=0;
		endbuf=0;
	}
		//ACCESS
	T & operator*()
	{	return *pointer;	}
	T * operator->()
	{	return pointer;	}
		//MOVING
	my_t & operator++()
	{	// ++myInstance. 
		if(++pointer ==endbuf)//конец внутри буфера
		{
			stream_ifw<T,Alloc> * mybase=itbuf->mybase;
			typename list<Buf>::iterator oldbuf=itbuf++;
			if(itbuf==mybase->bufs.end())
				if(mybase->_atend)//конец буферов и конец файла
					this->~_stream_ifw_iterator();
				else if((itbuf=mybase->addbuf())==mybase->bufs.end())//конец буферов и оказался конец файла
					this->~_stream_ifw_iterator();
				else
					goto normal_next_buffer;
			else
			{
normal_next_buffer:
				itbuf->iterator_counter++;
				pointer=itbuf->begin;
				endbuf=itbuf->end;
			}
			mybase->del_it_from_buf(oldbuf);
		}
		return * this;   
	}
	my_t operator++(int)
	{	// myInstance++.
		my_t orig = *this;
		++(*this);
		return orig;
	}
		//ARITHMETIC
	bool operator==(const my_t & r)const
	{
		return itbuf==r.itbuf && pointer==r.pointer;
	}
	bool operator<(const my_t & r)const
	{
		assert(itbuf->mybase==r.itbuf->mybase);
		if(itbuf->nomber<r.itbuf->nomber)
			return true;
		else if(itbuf->nomber==r.itbuf->nomber)
			return pointer<r.pointer;
		else
			return false;
	}
};

template<class T, class Alloc>
bool atend/*<typename stream_ifw<T,Alloc>::iterator>*/
		(const typename stream_ifw<T,Alloc>::iterator & it)
{	return it.pointer==0;	}
template<class T, class Alloc>
bool atend/*<typename stream_ifw<T,Alloc>::const_iterator>*/
		(const typename stream_ifw<T,Alloc>::const_iterator & it)
{	return it.pointer==0;	}
/*
		// TEMPLATE CLASS _stream_ifw_iterator
template<class T, class Alloc>
class _stream_ifw_iterator
	:public _stream_ifw_const_iterator<T,Alloc>
{
public:
	_stream_ifw_iterator()	{}
	_stream_ifw_iterator(const my_t & r)
		:_stream_ifw_const_iterator(r){}
	//my_t & operator=(const my_t & r)
	//const my_t & operator=(const my_t & r)const
	const T & operator*()const
	{	return *pointer;	}
	const T * operator->()const
	{	return pointer;	}
};
*/

}//namespace str
#endif //MYSTREAM_H
