# Changelog - MuOnline Season 13

## 2026-07-04

### Preparacao inicial do servidor e cliente
- Compiladas as principais aplicacoes do servidor e cliente:
  - `ConnectServer.exe`
  - `DataServer.exe`
  - `JoinServer.exe`
  - `GameServer.exe`
  - `GameServerCS.exe`
  - `main.dll`
- Instalados os executaveis compilados nas respectivas pastas de execucao em `MuServer`.
- Criado `MuServer/StartServer.bat` para facilitar a inicializacao dos servicos.
- Criado `README.md` com instrucoes de compilacao, configuracao, banco de dados, execucao e login no cliente.

### Configuracao de rede
- Configurado o IP local `192.168.1.3` nos arquivos principais do servidor e cliente:
  - `MuServer/ConnectServer/ServerList.dat`
  - `MuServer/Data/MapServerInfo.dat`
  - `MuServer/GameServer/Data/GameServerInfo - Common.dat`
  - `MuServer/GameServerCS/Data/GameServerInfo - Common.dat`
  - `MuServer/JoinServer/JoinServer.ini`
  - `Client/Config.ini`
  - `Main/Main/main.cpp`
- Corrigido `ServerList.dat` para usar o codigo correto do GameServer normal:
  - `40 "GameServer" "192.168.1.3" 55901 "SHOW"`
  - `19 "GameServerCS" "192.168.1.3" 55919 "HIDE"`
- Corrigido `MapServerInfo.dat` para mapear os servidores com os codigos esperados pelo cliente:
  - `40 0 1 S192.168.1.3 55901`
  - `19 0 1 S192.168.1.3 55919`

### Build fixes
- Corrigido build do `DataServer` adicionando `#include <algorithm>` em `DataServer/DataServer/stdafx.h`.
- Corrigida incompatibilidade antiga do Crypto++ com o toolset atual, substituindo uso quebrado de `stdext::make_unchecked_array_iterator` em:
  - `Util/cryptopp/zdeflate.cpp`
  - `Main/Util/cryptopp/zdeflate.cpp`
- Corrigido recurso ausente da source do `Main`:
  - Copiado `GameServer/GameServer/GameServer.ico` para `Main/Main/favicon.ico`.
  - Ajustado `Main/Main/Main.rc` para apontar para `favicon.ico`.

### Banco de dados
- Confirmado banco em `.\SQLEXPRESS`, database `MuOnline`.
- Confirmados arquivos fisicos do banco:
  - `C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\MuOnline.mdf`
  - `C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\MuOnline_log.ldf`
- Confirmado DSN/ODBC `MuOnline`.
- Restaurado/adicionado backup do banco em `MuServer/Database/MuOnline.bak`.

### Cliente
- Cliente completo mantido fora do repositorio Git por tamanho, via `.gitignore`:
  - `client-files/`
- Identificados arquivos usados pela tela de loading do cliente:
  - `client-files/Data/Logo/Loading01.OZJ`
  - `client-files/Data/Logo/Loading02.OZJ`
  - `client-files/Data/Logo/Loading03.OZJ`
  - `client-files/Data/Local/loading01.ozj`
  - `client-files/Data/Local/loading02.ozj`
  - `client-files/Data/Local/loading03.ozj`
  - `client-files/Data/Local/webzenlogo.ozj`
  - `client-files/Data/Logo/Webzenlogo.OZJ`

### Git
- Inicializado repositorio Git local na branch `main`.
- Criados commits iniciais de documentacao, sources, servidor, backup do banco e ferramentas.
- Configurado remoto:
  - `https://github.com/AlanPrates/MuOnline-Season-13.git`

### Corrigido
- Corrigido erro ao abrir o MU Item Shop pela tecla `X`.
  - O cliente tentava baixar `IBSCategory.txt` da versao `027.2024.001` e recebia `404`.
  - Foram adicionados os scripts do shop em `client-files/Data/InGameShopScript/027.2024.001`.
  - Foram adicionados os mesmos scripts em `Client/Data/InGameShopScript/027.2024.001`.
  - Foi adicionado o banner em `Client/Data/InGameShopBanner/001.2022.001/IBSBanner.txt`.

- Corrigido item sem modelo ao clicar na categoria `Scrolls` do shop.
  - Erro original: `ItemModelFile does not exist : [(14, 230) "Data\Item\" "MLhealingscroll.bmd"]`.
  - Foi criado `MLhealingscroll.bmd` em `client-files/Data/Item`.
  - Foi criado `MLhealingscroll.bmd` em `Client/Data/Item`.

- Corrigido crash do `GameServer.exe` ao abrir/usar a janela de eventos.
  - Erro original: `Run-Time Check Failure #2 - Stack around the variable 'pMsg' was corrupted`.
  - Em `GameServer/GameServer/MonsterSpawner.cpp`, trocadas copias inseguras com `strcpy` por copias limitadas com `strncpy`.
  - Protegidos nomes e mensagens de invasoes/eventos contra estouro de buffer.
  - Gerado novo `MuServer/GameServer/GameServer.exe` em Release.
  - Backup do executavel antigo criado em `MuServer/GameServer/GameServer.exe.bak_20260704_195859`.

- Corrigido log do comando `/pin`.
  - Em `GameServer/GameServer/CommandManager.cpp`, o log usava `%d` para imprimir o PIN como numero/ponteiro.
  - Alterado para `%s`, registrando o PIN como texto corretamente.

### Conta e banco de dados
- Conta migrada de `teste` para `alanj`.
- Senha alterada de `123456` para `1907201010`.
- PIN criado/definido como `7294186`.
- Referencias da conta foram migradas nas tabelas principais, incluindo personagens, warehouse, CashShop, logs e sistemas auxiliares.
- iCoin/WCoinC foi ajustado para `50000` conforme pedido.
- Estado atual confirmado no banco:
  - Conta: `alanj`
  - Senha: `1907201010`
  - PIN: `7294186`
  - WCoinC/iCoin atual: `47510`
  - WCoinP/Bonus atual: `25000`
  - GoblinPoint atual: `0`

### Build
- Recompilada `Util/cryptopp/Release/cryptlib.lib` para compatibilizar com o toolset usado pelo `GameServer`.
- Recompilado `GameServer/Release/GameServer.exe`.
- Instalado o novo executavel em `MuServer/GameServer/GameServer.exe`.

### Observacoes
- A tentativa de gerar `GameServerCS` compilou o executavel, mas falhou no passo final de manifesto (`mt.exe`, codigo 31). Por isso `MuServer/GameServerCS/GameServer.exe` nao foi substituido.
- `MuServer/StartUp/Configuration/Configuration.xml` esta com `GameServerCS` marcado como `Run="True"`, mas o caminho ainda aponta para uma pasta antiga de Season 4. Isso deve ser revisado antes de usar o CS.
