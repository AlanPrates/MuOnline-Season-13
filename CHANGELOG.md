# Changelog - MuOnline Season 13

## 2026-07-05 (Account Management, Security Hardening, Build Tooling)

### Account Manager GUI (scripts/account-creator-gui.ps1)
- Pure PowerShell WPF (no XAML) with two modes: **Create Account** and **Edit Account**
- Create: login, password, PIN (7 digits, auto-generates if empty), character class, stats presets
- Edit: search account by login, load data, modify password/PIN/AccountLevel, view existing characters, add new character
- Dark theme with custom ComboBox template (dark dropdown popup)
- Fixed button click handler closure bug using `$this.Tag` pattern

### MD5 Hash Generator (Tools/md5hash/md5hash.cpp)
- Fixed double-processing of 64-byte blocks in MD5 transform
- Output changed from lowercase (`%02x`) to uppercase (`%02X`) — server's `ConvertStringToBinary` only handles uppercase hex
- Login verified working for account `alan00` / `1907201010`

### GameServer Security Hardening
- **Division by zero protection**: Added `SAFE_SERVERINFO_DIVISOR` macro across `CharacterCalcAttribute` (ObjectManager.cpp) — protects 100+ divisions for damage, speed, defense, elemental, attack/defense rates across all 8 classes
- Fixes character freeze on map enter caused by `AutoDt0-4 = 0` and missing `MasterSkillTree` entry
- **Buffer overflow fixes**: Replaced 16 `strcpy` with `strncpy` + `sizeof()-1` in 7 files:
  - DSProtocol.cpp (6), CastleSiege.cpp (2), CheatGuard.cpp (2), CustomMonster.cpp (2), ItemManager.cpp (1), MUFC.cpp (1), Oficina.cpp (2)
- Added `_CRT_SECURE_NO_WARNINGS` to stdafx.h

### WZ_CreateCharacter Understanding
- Return code `0x01` = SUCCESS (inverted in SP: `@Result=0x00` → output `0x01`)
- Direct INSERT workaround no longer needed; use SP properly

### ServerLock VIP Restriction
- `GameServerVIP/Data/GameServerInfo - Common.dat`: `ServerLock = 1` (was 0)
- Code at `JSProtocol.cpp:262`: `if(gServerInfo.m_ServerLock > lpMsg->AccountLevel)` blocks free accounts (AccountLevel=0) from VIP server
- Verified working

### Build & Config
- Fixed `GameServer.vcxproj`: OutDir paths (`..\..\..\` → `..\..\`), added Release_CS config parity
- Config templates: `JoinServer.ini.example`, `Common.ini.example`, `Configuration.xml.example`
- Build scripts: `build-all.ps1`, `health-check.ps1`, `sync-ip.ps1`
- BMD tools: encrypt/decrypt/patch serverlist
- Database backup: `muonline_clean.bak` (34 MB)
- Database schema: `muonline_complete.sql` (86 tables, 102 procs, 2 views, 2 functions)

## 2026-07-04 (Segurança e Organização)

### Limpeza de duplicatas
- Removidos do repositório 7 arquivos duplicados que não são compilados:
  - `GameServer/GameServer/DSProtocol - doublepacket.cpp`
  - `GameServer/GameServer/IllusionTemple - Copia.cpp` / `.h`
  - `GameServer/GameServer/SetItemOption - Copia.cpp` / `.h`
  - `MuServer/Data/Hack/SpeedFila - Copia.txt`
  - `MuServer/Data/Item/ItemDrop - Copia.txt`
- Todos confirmados como idênticos aos originais via SHA256 e git diff.

### Remoção de credenciais e caminhos locais do versionamento
- `MuServer/JoinServer/JoinServer.ini` removido do Git (continua no disco).
  - Criado `JoinServer.ini.example` como template sem credenciais.
- `MuServer/StartUp/Configuration/Configuration.xml` removido do Git.
  - Criado `Configuration.xml.example` como template.
  - Corrigido caminho do GameServerCS: apontava para `D:\Source S4K FULL\...` (Season 4 antigo).
  - Alterado para `..\GameServerCS\GameServer.exe` com `Run="False"`.
- `MuServer/Database/MuOnline.bak` (6 MB) removido do Git.
- Removidos `build-*.log` da raiz do repositório.
- `.gitignore` atualizado: ignora `JoinServer.ini`, `Configuration.xml`, `Configuration.xml.bak`, `MuServer/Database/*.bak` e `build-*.log`.

### Scripts
- Criado `scripts/health-check.ps1`: valida SQL Server, ODBC, portas, arquivos de config, coerência de IP e ServerCode.
- Criado `scripts/build-all.ps1`: compila toda a suíte (ConnectServer, DataServer, JoinServer, cryptopp, GameServer, GameServerCS, Main) e copia para `MuServer/`.

## 2026-07-04

## 2026-07-04 (Frente 1.3 - Auditoria de buffers)

### Correcao de strcpy inseguros em todo o GameServer
- Substituidas **16 ocorrencias** de `strcpy` por `strncpy` com `sizeof(dest)-1` em 7 arquivos:
  - `DSProtocol.cpp`: 6 (accountOld, accountNew, killer, victim [x2], author)
  - `CastleSiege.cpp`: 2 (SaveSiegeCharInfo, GetSiegeCharInfo)
  - `CheatGuard.cpp`: 2 (Account, HardDiskId)
  - `CustomMonster.cpp`: 2 (Rank, Name[i])
  - `ItemManager.cpp`: 1 (item_name local buffer)
  - `MUFC.cpp`: 1 (FighterName)
  - `Oficina.cpp`: 2 (description, itemName)
- Todas mantiveram as null-terminations explicitas ja existentes (`[...][N] = '\0'`).
- Adicionado `#define _CRT_SECURE_NO_WARNINGS` em `stdafx.h` para suprimir warnings C4996 do `strncpy`.
- **Zero `strcpy` restantes** em qualquer `.cpp` do GameServer.
- Build Debug e Release_CS verificados com 0 erros.

## 2026-07-04 (Frente 1.1 - Build GameServerCS)

### Correcao do build do GameServerCS
- **Problema original**: `mt.exe` codigo 31 no passo de manifesto (CHANGELOG.md:112).
- **Causas identificadas**:
  - `Release_CS` nao tinha `OutDir` definido, fazendo `mt.exe` resolver caminho errado.
  - `Release_CS` nao tinha `WholeProgramOptimization`, `SDLCheck=false`, `RuntimeLibrary=MultiThreadedDLL` — presentes em `Release`.
  - `cryptlib.lib` estava compilado com toolset antigo (`_MSC_VER=1600`, VS 2010), causando `LNK2038` no `Release_CS`.
- **Correcoes aplicadas** (em `GameServer/GameServer/GameServer.vcxproj`):
  - Adicionado `OutDir` = `..\..\MuServer\GameServerCS\` para `Release_CS`.
  - Adicionados `WholeProgramOptimization`, `SDLCheck=false`, `RuntimeLibrary=MultiThreadedDLL` no `Release_CS`.
  - Corrigido `OutDir` de `Debug` e `Debug_CS` — estavam com `..\..\..\` (3 niveis, resolvia para `D:\MuServer\`) em vez de `..\..\` (2 niveis, `D:\MuOnline Season 13\MuServer\`).
- **Cryptopp recompilado** (`Util/cryptopp/Release/cryptlib.lib`) com toolset v145 para compatibilidade.
- **Builds verificados**: `Debug_CS` e `Release_CS` compilam com 0 erros.
- **GameServerCS.exe** atualizado em `MuServer/GameServerCS/`.
- **Configuration.xml**: `GameServerCS` alterado de `Run="False"` para `Run="True"` e caminho corrigido para `..\GameServerCS\GameServer.exe`.

### Atualizacao dos scripts
- `scripts/build-all.ps1`: corrigido `OutDir` do GameServerCS de `D:\MuServer\GameServerCS` para `..\..\MuServer\GameServerCS` (consistente com o .vcxproj).

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
