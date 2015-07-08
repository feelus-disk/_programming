//программный модуль
#include <windows.h>
MSG msg;

int DWndProc(HWND,UINT,WPARAM,LPARAM);

__stdcall WinMain(HINSTANCE hInstance,
    HINSTANCE hPrevInstance,
    LPSTR lpCmdLine,
    int nCmdShow
)
{
//не модальное диалоговое окно
	HWND hdlg=CreateDialog(hInstance,"DIALOG",NULL,(DLGPROC)DWndProc);
//цикл обработки сообщений
	while (GetMessage(&msg, NULL, 0, 0)) 
	{
		IsDialogMessage(hdlg,&msg);
	}

//закрыть приложение
	ExitProcess(0);
};
//функция немодального окна
int DWndProc(HWND hwndDlg,UINT uMsg, WPARAM wParam, LPARAM lParam)
	{
	switch(uMsg)
	{
//сообщение, приходящее при создании диалогового окна
	case WM_INITDIALOG:
		break;
//сообщение, приходящее при попытке закрыть окно
	case WM_DESTROY:
		PostQuitMessage(0);
		break;
	case WM_CLOSE:
		DestroyWindow(hwndDlg);
		return TRUE;
//сообщение от элементов управления
	case WM_COMMAND:
		break;
	};

		return FALSE;
	};
