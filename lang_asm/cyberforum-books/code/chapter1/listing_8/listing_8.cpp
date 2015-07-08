
//программный модуль
#include <windows.h>

int DWndProc(HWND,UINT,WPARAM,LPARAM);

__stdcall WinMain(HINSTANCE hInstance,
    HINSTANCE hPrevInstance,
    LPSTR lpCmdLine,
    int nCmdShow
)
{
//создать немодальное диалоговое окно
DialogBoxParam(hInstance,"DIALOG",NULL,(DLGPROC)DWndProc,0);
//закрыть приложение
ExitProcess(0);
};
//функция обработки сообщений модального окна
int DWndProc(HWND hwndDlg,UINT uMsg, WPARAM wParam, LPARAM lParam)
	{
	switch(uMsg)
	{
//сообщение, приходящее при создании диалогового окна
	case WM_INITDIALOG:
		break;
//сообщение, приходящее при попытке закрыть окно
	case WM_CLOSE:
		EndDialog(hwndDlg,0);
		return TRUE;
//сообщение от элементов управления
	case WM_COMMAND:
		break;
	};
		return FALSE;
	};
