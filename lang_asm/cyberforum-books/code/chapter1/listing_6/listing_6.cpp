#include <windows.h>

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

int APIENTRY WinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPSTR     lpCmdLine,
                     int       nCmdShow)
{
	char cname[]="Class";
	char title[]="Простое оконное приложение";
	MSG msg;

	//структура для регистрации класса окон
	WNDCLASS wc;
	wc.style		=0;
	wc.lpfnWndProc		=(WNDPROC)WndProc;
	wc.cbClsExtra		=0;
	wc.cbWndExtra		=0;
	wc.hInstance		=hInstance;
	wc.hIcon		=LoadIcon(hInstance, (LPCTSTR)IDI_APPLICATION);
	wc.hCursor		=LoadCursor(NULL, IDC_ARROW);
	wc.hbrBackground	=(HBRUSH)(COLOR_WINDOW+1);
	wc.lpszMenuName	=0;
	wc.lpszClassName	=cname;
	//регистрируем класс
	if(!RegisterClass(&wc)) return 0;
	//создать окно
	HWND  hWnd = CreateWindow(
		cname, //класс
		title, //заголовок
		WS_OVERLAPPEDWINDOW,  //стиль окна 
		0,   //координата X
		0,   //координата Y
		500, //ширина окна
		300, //высота окна 
		NULL, //дескриптор окна-родителя
		NULL, //дескриптор меню 
		hInstance,  //идентификатор приложения
		NULL);   //указатель на структуру, посылаемую 
				//по сообщению WM_CREATE
	//проверим, создалось ли окно
	if (!hWnd)    return 0;
	//показать окно
	ShowWindow(hWnd, nCmdShow);
	//обновить содержимое окна
	UpdateWindow(hWnd);

	//цикл обработки сообщений
	while (GetMessage(&msg, NULL, 0, 0)) 
	{
	//транслировать коды виртуальных клавиш в ASCII-коды
		TranslateMessage(&msg);
	//переправить сообщение процедуре окна
		DispatchMessage(&msg);
	}

	return 0;
};

//процедура окна
LRESULT CALLBACK WndProc(HWND hWnd, 
UINT message, 
WPARAM wParam, 
LPARAM lParam)
{
	switch(message)
	{
//сообщение при создании окна
	case WM_CREATE:
		break;
//сообщение при закрытии окна
	case WM_DESTROY:
//необходимо для  выхода из цикла обработки сообщений
		PostQuitMessage(0);
		break;
//сообщение приходящее при перерисовки окна
	case WM_PAINT:
		break;
//возврат не обработанных сообщений
		default:
	return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}
