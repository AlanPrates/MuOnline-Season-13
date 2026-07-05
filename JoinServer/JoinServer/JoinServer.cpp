#include "stdafx.h"
#include "resource.h"
#include "JoinServer.h"
#include "AccountManager.h"
#include "AllowableIpList.h"
#include "MiniDump.h"
#include "QueryManager.h"
#include "ServerDisplayer.h"
#include "SocketManager.h"
#include "SocketManagerUdp.h"
#include "ThemidaSDK.h"
#include "Util.h"
#include "..\\..\\Util\\MD5.h"

HINSTANCE hInst;
TCHAR szTitle[MAX_LOADSTRING];
TCHAR szWindowClass[MAX_LOADSTRING];
HWND hWnd;
char CustomerName[32];
char CustomerHardwareId[36];
BOOL CaseSensitive;
BOOL MD5Encryption;
BOOL AutoRegistration;
int AutoRegistrationMinLength;
int APIENTRY WinMain(HINSTANCE hInstance,HINSTANCE hPrevInstance,LPSTR lpCmdLine,int nCmdShow) // OK
{
	VM_START

	CMiniDump::Start();

	FILE* log = 0;
	fopen_s(&log,"migrate_md5.log","w");
	if (log) {
		fprintf(log,"lpCmdLine=[%s]\n",lpCmdLine?lpCmdLine:"(null)");
		fprintf(log,"strstr=%p\n",strstr(lpCmdLine,"--migrate-md5"));
	}

	if (log && strstr(lpCmdLine, "--migrate-md5") != 0)
	{
		char odbc[32] = {0}, user[32] = {0}, pass[32] = {0};
		GetPrivateProfileString("JoinServerInfo","JoinServerODBC","",odbc,sizeof(odbc),".\\JoinServer.ini");
		GetPrivateProfileString("JoinServerInfo","JoinServerUSER","",user,sizeof(user),".\\JoinServer.ini");
		GetPrivateProfileString("JoinServerInfo","JoinServerPASS","",pass,sizeof(pass),".\\JoinServer.ini");

		fprintf(log,"=== Migrando senhas para MD5 ===\n\n");

		if (gQueryManager.Connect(odbc,user,pass) == 0) {
			fprintf(log,"Falha ao conectar ao banco de dados (DSN=%s)\n",odbc);
			fclose(log);
			return 1;
		}

		// Ensure memb__pwd column is large enough for 32-char MD5 hex
		gQueryManager.ExecQuery("ALTER TABLE MEMB_INFO ALTER COLUMN memb__pwd varchar(32) NOT NULL");
		gQueryManager.Close();

		// Step 1: fetch all accounts into memory
		struct AccountEntry { char id[11]; char pwd[33]; };
		AccountEntry entries[256];
		int total = 0;

		if (gQueryManager.ExecQuery("SELECT memb___id, memb__pwd FROM MEMB_INFO") == 0 || gQueryManager.Fetch() == SQL_NO_DATA) {
			fprintf(log,"Nenhuma conta encontrada.\n");
			gQueryManager.Close();
			gQueryManager.Disconnect();
			fclose(log);
			return 0;
		}

		do {
			gQueryManager.GetAsString("memb___id",entries[total].id,sizeof(entries[total].id));
			gQueryManager.GetAsString("memb__pwd",entries[total].pwd,sizeof(entries[total].pwd));
			total++;
		} while (gQueryManager.Fetch() == SQL_SUCCESS && total < 256);
		gQueryManager.Close();

		// Step 2: migrate each account
		MD5 md5;
		int migrated = 0;
		char query[256];

		for (int i = 0; i < total; i++) {
			int key = MakeAccountKey(entries[i].id);
			char hash[16] = {0};

			if (!md5.MD5_EncodeKeyVal(entries[i].pwd,hash,key)) {
				fprintf(log,"  SKIP %s (key=%d)\n",entries[i].id,key);
				continue;
			}

			char hex[33] = {0};
			for (int j = 0; j < 16; j++)
				sprintf_s(hex+j*2,3,"%02X",(unsigned char)hash[j]);

			sprintf_s(query,sizeof(query),"UPDATE MEMB_INFO SET memb__pwd='%s' WHERE memb___id='%s'",hex,entries[i].id);
			if (gQueryManager.ExecQuery(query) != 0) {
				fprintf(log,"  OK  %s (key=%d) pwd=%s -> %s\n",entries[i].id,key,entries[i].pwd,hex);
				migrated++;
			} else {
				fprintf(log,"  FAIL %s (key=%d, query=[%s])\n",entries[i].id,key,query);
			}
			gQueryManager.Close();
		}

		fprintf(log,"\n=== %d/%d contas migradas ===\n",migrated,total);
		gQueryManager.Disconnect();
		fclose(log);
		return 0;
	}
	if (log) { fprintf(log,"Nao e modo migrate, continuando...\n"); fclose(log); }

	LoadString(hInstance,IDS_APP_TITLE,szTitle,MAX_LOADSTRING);
	LoadString(hInstance,IDC_JOINSERVER,szWindowClass,MAX_LOADSTRING);

	MyRegisterClass(hInstance);

	if(InitInstance(hInstance,nCmdShow) == 0)
	{
		return 0;
	}

	GetPrivateProfileString("JoinServerInfo","CustomerName","",CustomerName,sizeof(CustomerName),".\\JoinServer.ini");

	GetPrivateProfileString("JoinServerInfo","CustomerHardwareId","",CustomerHardwareId,sizeof(CustomerHardwareId),".\\JoinServer.ini");

	char buff[256];

	wsprintf(buff,"[%s] JoinServer (QueueSize : %d) (AccountCount : %d/%d)",JOINSERVER_VERSION,0,0,0);

	SetWindowText(hWnd,buff);

	gServerDisplayer.Init(hWnd);

	WSADATA wsa;

	if(WSAStartup(MAKEWORD(2,2),&wsa) == 0)
	{
		char JoinServerODBC[32] = {0};

		char JoinServerUSER[32] = {0};

		char JoinServerPASS[32] = {0};

		GetPrivateProfileString("JoinServerInfo","JoinServerODBC","",JoinServerODBC,sizeof(JoinServerODBC),".\\JoinServer.ini");

		GetPrivateProfileString("JoinServerInfo","JoinServerUSER","",JoinServerUSER,sizeof(JoinServerUSER),".\\JoinServer.ini");

		GetPrivateProfileString("JoinServerInfo","JoinServerPASS","",JoinServerPASS,sizeof(JoinServerPASS),".\\JoinServer.ini");

		WORD JoinServerPort = GetPrivateProfileInt("JoinServerInfo","JoinServerPort",55970,".\\JoinServer.ini");

		char ConnectServerAddress[16] = {0};

		GetPrivateProfileString("JoinServerInfo","ConnectServerAddress","127.0.0.1",ConnectServerAddress,sizeof(ConnectServerAddress),".\\JoinServer.ini");

		WORD ConnectServerPort = GetPrivateProfileInt("JoinServerInfo","ConnectServerPort",55557,".\\JoinServer.ini");

		CaseSensitive = GetPrivateProfileInt("JoinServerInfo","CaseSensitive",0,".\\JoinServer.ini");

		MD5Encryption = GetPrivateProfileInt("JoinServerInfo","MD5Encryption",0,".\\JoinServer.ini");

		AutoRegistration = GetPrivateProfileInt("JoinServerInfo", "AutoRegistration", 0, ".\\JoinServer.ini");
		AutoRegistrationMinLength = GetPrivateProfileInt("JoinServerInfo", "AutoRegistrationMinLength", 0, ".\\JoinServer.ini");

		if(gQueryManager.Connect(JoinServerODBC,JoinServerUSER,JoinServerPASS) == 0)
		{
			LogAdd(LOG_RED,"Could not connect to database");
		}
		else
		{
			if(gSocketManager.Start(JoinServerPort) == 0)
			{
				gQueryManager.Disconnect();
			}
			else
			{
				if(gSocketManagerUdp.Connect(ConnectServerAddress,ConnectServerPort) == 0)
				{
					gSocketManager.Clean();

					gQueryManager.Disconnect();
				}
				else
				{
					gAllowableIpList.Load("AllowableIpList.txt");

					SetTimer(hWnd,TIMER_1000,1000,0);
				}
			}
		}
	}
	else
	{
		LogAdd(LOG_RED,"WSAStartup() failed with error: %d",WSAGetLastError());
	}

	gServerDisplayer.PaintAllInfo();

	SetTimer(hWnd,TIMER_2000,2000,0);

	HACCEL hAccelTable = LoadAccelerators(hInstance,(LPCTSTR)IDC_JOINSERVER);

	MSG msg;

	while(GetMessage(&msg,0,0,0) != 0)
	{
		if(TranslateAccelerator(msg.hwnd,hAccelTable,&msg) == 0)
		{
			TranslateMessage(&msg);
			DispatchMessageA(&msg);
		}
	}

	CMiniDump::Clean();

	VM_END

	return msg.wParam;
}

ATOM MyRegisterClass(HINSTANCE hInstance) // OK
{
	WNDCLASSEX wcex;

	wcex.cbSize = sizeof(WNDCLASSEX);

	wcex.style = CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc = (WNDPROC)WndProc;
	wcex.cbClsExtra = 0;
	wcex.cbWndExtra = 0;
	wcex.hInstance = hInstance;
	wcex.hIcon = LoadIcon(hInstance,(LPCTSTR)IDI_JOINSERVER);
	wcex.hCursor = LoadCursor(0,IDC_ARROW);
	wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
	wcex.lpszMenuName = (LPCSTR)IDC_JOINSERVER;
	wcex.lpszClassName = szWindowClass;
	wcex.hIconSm = LoadIcon(wcex.hInstance,(LPCTSTR)IDI_SMALL);

	return RegisterClassEx(&wcex);
}

BOOL InitInstance(HINSTANCE hInstance,int nCmdShow) // OK
{
	hInst = hInstance;

	hWnd = CreateWindow(szWindowClass,szTitle,WS_OVERLAPPEDWINDOW | WS_THICKFRAME,CW_USEDEFAULT,0,600,600,0,0,hInstance,0);

	if(hWnd == 0)
	{
		return 0;
	}

	ShowWindow(hWnd,nCmdShow);
	UpdateWindow(hWnd);
	return 1;
}

LRESULT CALLBACK WndProc(HWND hWnd,UINT message,WPARAM wParam,LPARAM lParam) // OK
{
	switch(message)
	{
		case WM_COMMAND:
			switch(LOWORD(wParam))
			{
				case IDM_ABOUT:
					DialogBox(hInst,(LPCTSTR)IDD_ABOUTBOX,hWnd,(DLGPROC)About);
					break;
				case IDM_EXIT:
					if(MessageBox(0,"Are you sure to terminate JoinServer?","Ask terminate server",MB_YESNO | MB_ICONQUESTION) == IDYES)
					{
						DestroyWindow(hWnd);
					}
					break;
				default:
					return DefWindowProc(hWnd,message,wParam,lParam);
			}
			break;
		case WM_TIMER:
			switch(wParam)
			{
				case TIMER_1000:
					JoinServerLiveProc();
					gAccountManager.DisconnectProc();
					break;
				case TIMER_2000:
					gServerDisplayer.Run();
					gAccountManager.GetAccountsToDisconnect();
					break;
				default:
					break;
			}
			break;
		case WM_DESTROY:
			PostQuitMessage(0);
			break;
		default:
			return DefWindowProc(hWnd,message,wParam,lParam);
	}

	return 0;
}

LRESULT CALLBACK About(HWND hDlg,UINT message,WPARAM wParam,LPARAM lParam) // OK
{
	switch(message)
	{
		case WM_INITDIALOG:
			return 1;
		case WM_COMMAND:
			if(LOWORD(wParam) == IDOK || LOWORD(wParam) == IDCANCEL)
			{
				EndDialog(hDlg,LOWORD(wParam));
				return 1;
			}
			break;
	}

	return 0;
}
