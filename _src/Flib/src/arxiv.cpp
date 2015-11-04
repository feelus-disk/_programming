namespace testfunctor
{
	template<class init, class outit, class Tf>
	void getstrchr(init * pit, outit ps, Tf fun)
	{
		while(!atend(*pit) && !fun(**pit))
			*ps++=*(*pit)++;
		putend(ps);
	}
//#define getstrchr(pit,ps,fun)	getstrchr(pit,ps,fun<std::iterator_traits<typeid(ps)>::value_type>)
	/*
	template<template<class> class Talg, class init, class outit>
	void getstrchr(init * pit, outit ps)
	{	
		getstrchr(pit,ps,Talg<std::iterator_traits<init>::value_type>);	
	}
	*/


	bool isendl(char ch)
	{	return ch=='\n';	}

	template<class T>
	bool isendl(T ch);
	template<>
	bool isendl<char>(char ch)
	{	return isendl(ch);	}//важно, чтоб нешаблонный isendl был определен выше
	template<>
	bool isendl<wchar_t>(wchar_t ch)
	{	return ch==L'\n';	}
	
	void char_test()
	{
		char is[]="qwer\ntyui";
		char os[1000];
		char * it=is;
		getstrchr(&it,os,isendl<char>);
		//getstrchr<isendl>(&it,os);
		printf("IN:\n%s\nOUT:\n%s",is,os);
		getchar();
	}
	void wchar_test()
	{
		wchar_t is[]=L"qwer\ntyui";
		wchar_t os[1000];
		wchar_t * it=is;
		getstrchr(&it,os,isendl<wchar_t>);
		//printf("IN:\n%s\nOUT:\n%s",is,os);
		getchar();
	}

	template<int x, class T>
	T func(T y)
	{
		return x*y;
	}
	void test()
	{
		func<5>(7);
		char_test();
	}

}
void foo(int)
{
	printf("special int\n");
}
namespace nm
{
	template<class T>
	void foo(T)
	{
		printf("template T\n");
	}
	void g(int)
	{
		printf("g()\n");
	}
}



	const char * err=0;
	{
		char *x;
		char str[20]="qwe";
		x=str+2;
		if(atend(x))	err="atend error 1\n";
		x++;
		if(!atend(x))	err="atend error 2\n";
		x--;
		putend(x);
		if(!atend(x))	err="putend error 2\n";
		x=end(str);
		if(x-str!=2)	err="end error\n";
	}

	stream_ifw<char> mystr(stdin);
	//stream_ifw<char>::iterator it=mystr.buf_first();
	//it++;

