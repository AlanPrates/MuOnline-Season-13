# MuOnline Season 13 - Build, Configuracao e Execucao

Este projeto contem as sources dos servidores, a `main.dll` do cliente e a pasta `MuServer` pronta para rodar em rede local.

Configuracao validada nesta maquina:

- IP do servidor: `192.168.1.3`
- SQL Server: `.\SQLEXPRESS`
- Banco: `MuOnline`
- ODBC/DSN: `MuOnline`
- ConnectServer TCP: `44405`
- ConnectServer UDP: `55557`
- DataServer: `55960`
- JoinServer: `55970`
- GameServer: `55901`
- GameServerCS: `55919`

## Estrutura

```txt
D:\MuOnline Season 13
|-- ConnectServer\        Source do ConnectServer
|-- DataServer\           Source do DataServer
|-- JoinServer\           Source do JoinServer
|-- GameServer\           Source do GameServer
|-- Main\                 Source da main.dll do cliente
|-- Util\                 Bibliotecas usadas pelo servidor
|-- Client\               Saida compilada do cliente
|-- MuServer\             Pasta de execucao do servidor
```

## Dependencias

Instale/tenha disponivel:

- Visual Studio com MSBuild e toolset C++ Win32.
- Toolset usado nesta maquina: `v145`.
- Windows SDK 10.
- SQL Server Express.
- ODBC SQL Server 32-bit configurado como `MuOnline`.

MSBuild usado:

```bat
C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe
```

## Banco de Dados

O banco usado pelo servidor e:

```txt
SQL Server: .\SQLEXPRESS
Database: MuOnline
```

Arquivos fisicos encontrados:

```txt
C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\MuOnline.mdf
C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\MuOnline_log.ldf
```

Para conferir se o banco esta online:

```bat
sqlcmd -S .\SQLEXPRESS -E -Q "SELECT name, state_desc FROM sys.databases ORDER BY name"
```

Para conferir os arquivos do banco:

```bat
sqlcmd -S .\SQLEXPRESS -E -Q "SELECT DB_NAME(database_id) AS dbname, physical_name FROM sys.master_files WHERE DB_NAME(database_id)='MuOnline'"
```

## ODBC

O `DataServer` e o `JoinServer` usam o DSN `MuOnline`.

Arquivos:

```txt
MuServer\DataServer\DataServer.ini
MuServer\JoinServer\JoinServer.ini
```

Configuracao atual:

```ini
[DataServerInfo]
DataServerODBC = MuOnline
DataServerPort = 55960
```

```ini
[JoinServerInfo]
JoinServerODBC = MuOnline
JoinServerUSER = sa
JoinServerPASS = PASS
JoinServerPort = 55970
ConnectServerAddress = 192.168.1.3
ConnectServerPort = 55557
CaseSensitive = 0
MD5Encryption = 0
AutoRegistration = 1
AutoRegistrationMinLength = 4
```

Importante: se o login SQL `sa` nao funcionar, configure o DSN para usar autenticacao integrada ou ajuste `JoinServerUSER` e `JoinServerPASS`.

## Compilacao

Abra PowerShell ou CMD na raiz:

```bat
cd /d "D:\MuOnline Season 13"
```

### 1. Compilar ConnectServer

```bat
"C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe" ConnectServer\ConnectServer.sln /m /t:Rebuild /p:Configuration=Release /p:Platform=Win32 /p:PlatformToolset=v145 /p:WindowsTargetPlatformVersion=10.0
```

Saida:

```txt
ConnectServer\Release\ConnectServer.exe
```

Copiar para:

```txt
MuServer\ConnectServer\ConnectServer.exe
```

### 2. Compilar DataServer

```bat
"C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe" DataServer\DataServer.sln /m /t:Rebuild /p:Configuration=Release /p:Platform=Win32 /p:PlatformToolset=v145 /p:WindowsTargetPlatformVersion=10.0
```

Saida:

```txt
DataServer\Release\DataServer.exe
```

Copiar para:

```txt
MuServer\DataServer\DataServer.exe
```

### 3. Compilar JoinServer

```bat
"C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe" JoinServer\JoinServer.sln /m /t:Rebuild /p:Configuration=Release /p:Platform=Win32 /p:PlatformToolset=v145 /p:WindowsTargetPlatformVersion=10.0
```

Saida:

```txt
JoinServer\Release\JoinServer.exe
```

Copiar para:

```txt
MuServer\JoinServer\JoinServer.exe
```

### 4. Compilar Crypto++ do servidor

O GameServer usa `Util\cryptopp`.

```bat
"C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe" Util\cryptopp\cryptlib.vcxproj /m /t:Rebuild /p:Configuration=Release /p:Platform=Win32 /p:PlatformToolset=v145 /p:WindowsTargetPlatformVersion=10.0
```

```bat
"C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe" Util\cryptopp\cryptlib.vcxproj /m /t:Rebuild /p:Configuration=Debug /p:Platform=Win32 /p:PlatformToolset=v145 /p:WindowsTargetPlatformVersion=10.0
```

### 5. Compilar GameServer normal

```bat
"C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe" GameServer\GameServer.sln /m /t:Build /p:Configuration=Debug /p:Platform=Win32 /p:PlatformToolset=v145 /p:WindowsTargetPlatformVersion=10.0
```

Saida gerada pelo projeto:

```txt
D:\MuServer\GameServer\GameServer.exe
```

Copiar para:

```txt
MuServer\GameServer\GameServer.exe
```

### 6. Compilar GameServerCS

```bat
"C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe" GameServer\GameServer.sln /m /t:Build /p:Configuration=Debug_CS /p:Platform=Win32 /p:PlatformToolset=v145 /p:WindowsTargetPlatformVersion=10.0
```

Saida gerada pelo projeto:

```txt
D:\MuServer\GameServerCS\GameServer.exe
```

Copiar para:

```txt
MuServer\GameServerCS\GameServer.exe
```

### 7. Compilar Crypto++ do cliente

```bat
"C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe" Main\Util\cryptopp\cryptlib.vcxproj /m /t:Rebuild /p:Configuration=Release /p:Platform=Win32 /p:PlatformToolset=v145 /p:WindowsTargetPlatformVersion=10.0
```

### 8. Compilar main.dll do cliente

```bat
"C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe" Main\Main.sln /m /t:Rebuild /p:Configuration=Release /p:Platform=Win32 /p:PlatformToolset=v145 /p:WindowsTargetPlatformVersion=10.0 "/p:OutDir=D:\MuOnline Season 13\Client\\"
```

Saida:

```txt
Client\main.dll
```

## Correcoes Necessarias Para Compilar no Toolset Atual

Estas alteracoes foram aplicadas para compilar com o toolset atual:

- `DataServer\DataServer\stdafx.h`
  - Adicionado `#include <algorithm>`.
- `Util\cryptopp\zdeflate.cpp`
  - Ajustado uso antigo de `stdext::make_unchecked_array_iterator`.
- `Main\Util\cryptopp\zdeflate.cpp`
  - Mesmo ajuste da Crypto++.
- `Main\Main\Main.rc`
  - Corrigido icone inexistente que apontava para `C:\Users\leofe\...`.
- `Main\Main\main.cpp`
  - IP padrao do cliente alterado para `192.168.1.3`.

## Configuracao de IP

IP atual:

```txt
192.168.1.3
```

Arquivos principais:

```txt
MuServer\ConnectServer\ServerList.dat
MuServer\Data\MapServerInfo.dat
MuServer\GameServer\Data\GameServerInfo - Common.dat
MuServer\GameServerCS\Data\GameServerInfo - Common.dat
MuServer\JoinServer\JoinServer.ini
Client\Config.ini
Main\Main\main.cpp
```

### ServerList.dat

```txt
//ServerCode ServerName ServerAddress ServerPort ServerType
40 "GameServer"   "192.168.1.3" 55901 "SHOW"
19 "GameServerCS" "192.168.1.3" 55919 "HIDE"
end
```

O servidor que aparece no cliente e o `SHOW`.

Importante: o `ServerCode` precisa bater com o `GameServerInfo - Common.dat`.

### MapServerInfo.dat

```txt
0
//ServerCode MapServerGroup InitSetVal IpAddress Port
40 0 1 S192.168.1.3 55901
19 0 1 S192.168.1.3 55919
end

1
//ServerCode NotMoveOption NextMap NextServerCode

end
```

Se aparecer erro dizendo que `This GameServerCode (...) doesn't Exist`, falta cadastrar esse `ServerCode` nesse arquivo.

### GameServer normal

Arquivo:

```txt
MuServer\GameServer\Data\GameServerInfo - Common.dat
```

Configuracao:

```ini
ServerName = GS_LEO
ServerCode = 40
ServerPort = 55901
DataServerAddress = 192.168.1.3
DataServerPort = 55960
JoinServerAddress = 192.168.1.3
JoinServerPort = 55970
ConnectServerAddress = 192.168.1.3
ConnectServerPort = 55557
```

### GameServerCS

Arquivo:

```txt
MuServer\GameServerCS\Data\GameServerInfo - Common.dat
```

Configuracao:

```ini
ServerName = GameServerCS
ServerCode = 19
ServerPort = 55919
DataServerAddress = 192.168.1.3
DataServerPort = 55960
JoinServerAddress = 192.168.1.3
JoinServerPort = 55970
ConnectServerAddress = 192.168.1.3
ConnectServerPort = 55557
```

### Cliente

Arquivo:

```txt
Client\Config.ini
```

Conteudo:

```ini
[LOGIN]
IpAddress = 192.168.1.3
IpAddressPort = 44405
```

## Como Rodar o Servidor

Use:

```txt
MuServer\StartServer.bat
```

Esse arquivo abre em ordem:

```txt
ConnectServer
DataServer
JoinServer
GameServer
GameServerCS
```

Se preferir abrir manualmente:

1. `MuServer\ConnectServer\ConnectServer.exe`
2. `MuServer\DataServer\DataServer.exe`
3. `MuServer\JoinServer\JoinServer.exe`
4. `MuServer\GameServer\GameServer.exe`
5. `MuServer\GameServerCS\GameServer.exe`

Sempre rode cada `.exe` dentro da propria pasta dele, porque os arquivos `.ini`, `Data` e `ServerList.dat` sao carregados por caminho relativo.

## Como Rodar o Cliente

Coloque ou mantenha estes arquivos na pasta do cliente:

```txt
Client\main.dll
Client\Config.ini
```

O executavel principal do cliente deve carregar essa `main.dll`. Com o servidor aberto:

1. Abra o cliente.
2. Aguarde a tela de login.
3. Clique na lista de servidores.
4. Deve aparecer `GameServer`.
5. Entre com uma conta existente.

Conta testada/configurada:

```txt
Usuario: teste
Senha: 123456
```

## Criar ou Resetar Conta

O `JoinServer.ini` esta com:

```ini
MD5Encryption = 0
AutoRegistration = 1
AutoRegistrationMinLength = 4
```

Isso permite registrar automaticamente conta nova pelo cliente, desde que a senha esteja em texto simples e as procedures do banco estejam funcionando.

Reset manual de senha:

```bat
sqlcmd -S .\SQLEXPRESS -E -d MuOnline -Q "UPDATE dbo.MEMB_INFO SET memb__pwd='123456' WHERE memb___id='teste'"
```

Listar contas sem mostrar senha:

```bat
sqlcmd -S .\SQLEXPRESS -E -d MuOnline -Q "SELECT memb___id AS Usuario, LEN(memb__pwd) AS TamanhoSenha, bloc_code AS Bloqueado FROM dbo.MEMB_INFO ORDER BY memb___id"
```

## Logs

Logs principais:

```txt
MuServer\ConnectServer\LOG\
MuServer\DataServer\LOG\
MuServer\JoinServer\LOG\
MuServer\JoinServer\LOG_ACCOUNT\
MuServer\GameServer\Logs\
MuServer\GameServerCS\Logs\
```

## Problemas Comuns

### Cliente abre, mas servidor nao aparece

Verifique:

- `MuServer\ConnectServer\ServerList.dat`
- `ServerCode` do `GameServerInfo - Common.dat`
- log do ConnectServer

O codigo do GS precisa bater:

```txt
ServerList.dat: 40
GameServerInfo - Common.dat: ServerCode = 40
```

Depois clique em `Reload` no ConnectServer ou reinicie ConnectServer e GameServer.

### Erro: This GameServerCode (...) doesn't Exist

Adicionar o codigo em:

```txt
MuServer\Data\MapServerInfo.dat
```

Exemplo:

```txt
40 0 1 S192.168.1.3 55901
19 0 1 S192.168.1.3 55919
```

### DataServer ou JoinServer nao conectam no banco

Verifique:

```bat
sqlcmd -S .\SQLEXPRESS -E -d MuOnline -Q "SELECT TOP 1 memb___id FROM dbo.MEMB_INFO"
```

Verifique tambem o DSN `MuOnline` no ODBC 32-bit:

```txt
C:\Windows\SysWOW64\odbcad32.exe
```

### Login falha mesmo com usuario correto

Verifique:

- `MD5Encryption = 0`
- senha em `MEMB_INFO.memb__pwd`
- `bloc_code = 0`
- logs em `JoinServer\LOG_ACCOUNT`

### ConnectServer mostra GameServer offline

Verifique se o GameServer esta conectando no ConnectServer UDP:

```ini
ConnectServerAddress = 192.168.1.3
ConnectServerPort = 55557
```

E se a porta UDP `55557` nao esta bloqueada no firewall.

## Portas Para Liberar no Firewall

```txt
44405 TCP - Cliente para ConnectServer
55557 UDP - Servidores para ConnectServer
55960 TCP - DataServer
55970 TCP - JoinServer
55901 TCP - GameServer
55919 TCP - GameServerCS
```

## Checklist Final

Antes de testar:

```txt
[ ] SQL Server .\SQLEXPRESS rodando
[ ] Banco MuOnline online
[ ] DSN ODBC MuOnline configurado
[ ] ConnectServer aberto
[ ] DataServer aberto e em ACTIVE MODE
[ ] JoinServer aberto e em ACTIVE MODE
[ ] GameServer aberto e em ACTIVE MODE
[ ] ConnectServer logou GameServer online (40)
[ ] Client\Config.ini aponta para 192.168.1.3:44405
[ ] Servidor aparece na lista do cliente
[ ] Login com teste / 123456
```

