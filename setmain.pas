//Objetivo construir os parametros de setup da classe principal
//Criado por Marcelo Maurin Martins
//Data:07/02/2021

unit setmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes, graphics;

const filename = 'farjud.cfg';


type
  { TfrmMenu }

  { TSetMain }

  TSetMain = class(TObject)

  private
        arquivo :Tstringlist;
        ckdevice : boolean;
        FPosX : integer;
        FPosY : integer;
        FFixar : boolean;
        FStay : boolean;
        FAtivaSom : boolean;
        FLastFiles : String;
        FPATH : string;
        FHeight : integer;
        FWidth : integer;
        FFONT : TFont;
        FCHATGPT : string;
        FDllPath : string;
        FDllMyPath : string;
        FDllPostPath : string;
        FURLServidor : String;  //URL Servidor de Dados

        FUsernameEmail: string; //Usuario de Email
        FPasswordEmail: string; //Senha do email
        FEmailEmail : string;   //Email do Email

        FRunScript : string;    //Script de Compilação
        FDebugScript : string;  //Script de Debug
        FCleanScript : string;  //Script de Limpeza
        FInstall : string;      //Script de Instalacao
        FCompile : string;      //Script de Compilação

        FHostnameMy : String;
        FBancoMy : String;
        FUsernameMy : String;
        FPasswordMy : String;

        FHostnamePost : String;
        FBancoPOST : String;
        FUsernamePost: String;
        FPasswordPost : String;
        FSchemaPost: String;
        FToolsFalar : Boolean;
        FLogin : string;
        FStringConexao : string;
        FClimaTempo: string;
        FCidadeCodigo : string;


        //filename : String;
        procedure SetDevice(const Value : Boolean);
        procedure SetPOSX(value : integer);
        procedure SetPOSY(value : integer);
        procedure SetFixar(value : boolean);
        procedure SetStay(value : boolean);
        procedure SetAtivaSom(value : boolean);
        procedure SetLastFiles(value : string);
        procedure SetFont(value : TFont);
        procedure SetCHATGPT(value : String);
        procedure SetDllPath( value : string);
        procedure SetDllMyPath( value : string);
        procedure SetDllPostPath( value : string);
        procedure SetToolsFalar(value : boolean);
        procedure Default();
  public
        constructor create();
        destructor Destroy();
        procedure SalvaContexto(flag : boolean);
        Procedure CarregaContexto();
        procedure IdentificaArquivo(flag : boolean);
        property device : boolean read ckdevice write SetDevice;
        property posx : integer read FPosX write SetPOSX;
        property posy : integer read FPosY write SetPOSY;
        property fixar : boolean read FFixar write SetFixar;
        property stay : boolean read FStay write SetStay;
        property AtivaSom : boolean read FAtivaSom write SetAtivaSom;
        property lastfiles: string read FLastFiles write SetLastFiles;
        property Height: integer read FHeight write FHeight;
        property Width : integer read FWidth write FWidth;
        property RunScript : string read FRunScript write FRunScript;
        property DebugScript : string read FDebugScript write FDebugScript;
        property CleanScript : string read FCleanScript write FCleanScript;
        property Install : string read FInstall write FInstall;
        property Compile : string read FCompile write FCompile;
        property Font : TFont read FFont write SetFont;
        property CHATGPT: String read FCHATGPT write SetCHATGPT;
        property DLLPath : String read FDllPath write SetDllPath;
        property DLLMyPath : String read FDllMyPath write SetDllMyPath;
        property DLLPostPath : String read FDllPostPath write SetDllPostPath;
        property UsernameEmail : String read FUsernameEmail write FUsernameEmail;
        property PasswordEmail : String read FPasswordEmail write FPasswordEmail;
        property EmailEmail : string read FEmailEmail write FEmailEmail;

        property HostnameMy: string read FHostnameMy write FHostnameMy;
        property BancoMy : String read FBancoMy write FBancoMy;
        property UsernameMy : String read FUsernameMy write FUsernameMy;
        property PasswordMy : String read FPasswordMy write FPasswordMy;
        property HostnamePost : String read FHostnamePost write FHostnamePost;
        property BancoPOST : String read FBancoPOST write FBancoPOST;
        property UsernamePost: String read FUsernamePOST write FUsernamePost;
        property PasswordPost : String read FPasswordPost write FPasswordPost;
        property SchemaPost: String read FSchemaPost write FSchemaPost;
        property ToolsFalar : Boolean read FToolsFalar write SetToolsFalar;
        property URLServidor : string read FURLServidor write FURLServidor;
        property Login : string read FLogin write Flogin;
        property StringConexao : string read FStringConexao write FStringConexao;
        property Climatempo: string read FClimaTempo write FClimaTempo;
        property CidadeCodigo : string read FCidadeCodigo write FCidadeCodigo;
  end;

  var
    FSetMain : TSetMain;


implementation

procedure TSetMain.SetDevice(const Value: Boolean);
begin
  ckdevice := Value;
end;


//Valores default do codigo
procedure TSetMain.Default();
begin
    ckdevice := false;
    fixar:=false;
    stay:=false;
    FPosX :=100;
    FPosY := 100;
    FFixar :=false;
    FStay := false;

    FDllPath:= ExtractFilePath(ApplicationName);
    FDllMyPath:= ExtractFilePath(ApplicationName);
    FDllPostPath:= ExtractFilePath(ApplicationName);
    //FLastFiles :="";
    //    FPATH : string;
    FHeight :=400;
    FWidth :=400;
    FURLServidor := 'http://192.168.7.157';   //Servidor de Banco de dados
    FRunScript := '';   //Script de Run
    FDebugScript :='';  //Script de Debug
    FCleanScript :='';  //Script de Limpeza
    FInstall :='';      //Script de Instalacao
    FCompile :='';      //Script de Compilacao
    if FFont = nil then
    begin
         FFONT := TFont.create();

    end;
    //Informações do email
    UsernameEmail := '';
    PasswordEmail:= '';
    FLogin := '';
    FStringConexao := 'DSN=PostgreSQL30;DATABASE=smsdb;SERVER=127.0.0.1;PORT=5432;UID=usuario;PWD=senha;SSLmode=disable;ReadOnly=0;Protocol=7.4;FakeOidIndex=0;ShowOidColumn=0;RowVersioning=0;ShowSystemTables=0;Fetch=100;UnknownSizes=0;MaxVarcharSize=255;MaxLongVarcharSize=8190;Debug=0;CommLog=0;UseDeclareFetch=0;TextAsLongVarchar=1;UnknownsAsLongVarchar=0;BoolsAsChar=1;Parse=0;ExtraSysTablePrefixes=;LFConversion=1;UpdatableCursors=1;TrueIsMinus1=0;BI=0;ByteaAsLongVarBinary=1;UseServerSidePrepare=1;LowerCaseIdentifier=0;D6=-101;OptionalErrors=0;FetchRefcursors=0;XaOpt=1';
    FClimaTempo:= '4b56eeaabdbbcbd432cc0f269ffc379c';
    FCidadeCodigo := '3618';

    FCHATGPT:=''; //CHATGPT TOKEN

    FToolsFalar := false;

end;

procedure TSetMain.SetPOSX(value: integer);
begin
    Fposx := value;
end;

procedure TSetMain.SetPOSY(value: integer);
begin
    FposY := value;
end;

procedure TSetMain.SetFixar(value: boolean);
begin
    FFixar := value;
end;

procedure TSetMain.SetStay(value: boolean);
begin
    FStay := value;
end;

procedure TSetMain.SetAtivaSom(value: boolean);
begin
  FAtivaSom:= value;
end;

procedure TSetMain.SetLastFiles(value: string);
begin
  FLastFiles:= value;
end;

procedure TSetMain.SetFont(value: TFont);
begin
  //StringToFont(value,FFONT);
  FFont := value;
end;

procedure TSetMain.SetCHATGPT(value: String);
begin
  FCHATGPT:= value;
end;

procedure TSetMain.SetDllPath(value: string);
begin
  FDllPath:= value;
end;

procedure TSetMain.SetDllMyPath(value: string);
begin
  FDllMyPath:= value;
end;

procedure TSetMain.SetDllPostPath(value: string);
begin
  FDllPostPath:= value;
end;

procedure TSetMain.SetToolsFalar(value: boolean);
begin
  FToolsFalar := value;
end;

procedure TSetMain.CarregaContexto();
var
  posicao: integer;
begin
    if  BuscaChave(arquivo,'DEVICE:',posicao) then
    begin
      ckdevice := (RetiraInfo(arquivo.Strings[posicao])='1');
    end;
    if  BuscaChave(arquivo,'POSX:',posicao) then
    begin
      FPOSX := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'POSY:',posicao) then
    begin
      FPOSY := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'FIXAR:',posicao) then
    begin
      FFixar := StrToBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'STAY:',posicao) then
    begin
      FStay := strtoBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'LASTFILES:',posicao) then
    begin
      FLastFiles := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'HEIGHT:',posicao) then
    begin
      FHEIGHT := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'WIDTH:',posicao) then
    begin
      FWidth := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'RUNSCRIPT:',posicao) then
    begin
      FRunScript := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'DEBUGSCRIPT:',posicao) then
    begin
      FDebugScript := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'CLEANSCRIPT:',posicao) then
    begin
      FCleanScript := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'INSTALLSCRIPT:',posicao) then
    begin
      FInstall := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'COMPILESCRIPT:',posicao) then
    begin
      FCompile := RetiraInfo(arquivo.Strings[posicao]);
    end;

    if  BuscaChave(arquivo,'FONT:',posicao) then
    begin
      StringToFont(RetiraInfo(arquivo.Strings[posicao]),FFONT);
    end;
    if  BuscaChave(arquivo,'CHATGPT:',posicao) then
    begin
      FCHATGPT := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'DLLPATH:',posicao) then
    begin
      FDLLPATH := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'DLLMYPATH:',posicao) then
    begin
      FDLLMyPATH := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'DLLPOSTPATH:',posicao) then
    begin
      FDLLPOSTPATH := RetiraInfo(arquivo.Strings[posicao]);
    end;

    if  BuscaChave(arquivo,'HOSTNAMEMY:',posicao) then
    begin
      FHostnameMy := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'BANCOMY:',posicao) then
    begin
      FBancoMy := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'USERNAMEMY:',posicao) then
    begin
      FUsernameMy := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'PASSWORDMY:',posicao) then
    begin
      FPasswordMy := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'HOSTNAMEPOST:',posicao) then
    begin
      FHostnamePost := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'BANCOPOST:',posicao) then
    begin
      FBancoPost := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'USERNAMEPOST:',posicao) then
    begin
      FUsernamePost := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'PASSWORDPOST:',posicao) then
    begin
      FPasswordPost := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'SCHEMAPOST:',posicao) then
    begin
      FSchemaPost := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'TOOLSFALAR:',posicao) then
    begin
      FTOOLSFALAR := iif(RetiraInfo(arquivo.Strings[posicao])='0',false,true);
    end;
    if  BuscaChave(arquivo,'URLSERVIDOR:',posicao) then
    begin
      FURLServidor := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'ATIVASOM:',posicao) then
    begin
      FATIVASOM := strtoBool(RetiraInfo(arquivo.Strings[posicao]));
    end;

    if  BuscaChave(arquivo,'USERNAMEEMAIL:',posicao) then
    begin
      FUsernameEmail := RetiraInfo(arquivo.Strings[posicao]);
    end;

    if  BuscaChave(arquivo,'PASSWORDEMAIL:',posicao) then
    begin
      FPASSWORDEmail := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'EMAILEMAIL:',posicao) then
    begin
      FEmailEmail := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'LOGIN:',posicao) then
    begin
      FLOGIN := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'STRINGCONEXAO:',posicao) then
    begin
      FSTRINGCONEXAO := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'CLIMATEMPO:',posicao) then
    begin
      FCLIMATEMPO := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'CIDADECODIGO:',posicao) then
    begin
      FCIDADECODIGO := RetiraInfo(arquivo.Strings[posicao]);
    end;

end;


procedure TSetMain.IdentificaArquivo(flag: boolean);
begin
  //filename := 'Work'+ FormatDateTime('ddmmyy',now())+'.cfg';
  {$ifdef Darwin}
    //Nao testado ainda
    Fpath :=GetAppConfigDir(false);
    if not(FileExists(FPATH)) then
    begin
      createdir(fpath);
    end;
  {$ENDIF}
  {$IFDEF LINUX}
      //Fpath :='/home/';
      //Fpath := GetUserDir()
      Fpath :=GetAppConfigDir(false);
      if not(FileExists(FPATH)) then
      begin
         createdir(fpath);
      end;
  {$ENDIF}
  {$IFDEF WINDOWS}
      Fpath :=GetAppConfigDir(false);
      if not(FileExists(FPATH)) then
      begin
         createdir(fpath);
      end;
  {$ENDIF}
  if (FileExists(fpath+filename)) then
  begin
    arquivo.LoadFromFile(fpath+filename);
    CarregaContexto();
  end
  else
  begin
    default();
    //SalvaContexto(false);
  end;

end;

//Metodo construtor
constructor TSetMain.create();
begin
    arquivo := TStringList.create();
    FFONT := TFont.create();
    IdentificaArquivo(true);
end;


procedure TSetMain.SalvaContexto(flag: boolean);
begin
  if (flag) then
  begin
    IdentificaArquivo(false);
  end;
  //filename := 'Work'+ FormatDateTime('ddmmyy',now())+'.cfg';
  arquivo.Clear;
  arquivo.Append('DEVICE:'+iif(ckdevice,'1','0'));
  arquivo.Append('POSX:'+inttostr(FPOSX));
  arquivo.Append('POSY:'+inttostr(FPOSY));
  arquivo.Append('FIXAR:'+booltostr(FFixar));
  arquivo.Append('STAY:'+booltostr(FStay));
  arquivo.Append('LASTFILES:'+FLastFiles);
  arquivo.Append('HEIGHT:'+inttostr(FHEIGHT));
  arquivo.Append('WIDTH:'+inttostr(FWIDTH));
  arquivo.Append('RUNSCRIPT:'+FRunScript);
  arquivo.Append('DEBUGSCRIPT:'+FDebugScript);
  arquivo.Append('CLEANSCRIPT:'+FCleanScript);
  arquivo.Append('INSTALLSCRIPT:'+FInstall);
  arquivo.Append('COMPILESCRIPT:'+FCompile);
  arquivo.Append('FONT:'+FontToString(FFONT));
  arquivo.Append('CHATGPT:'+FCHATGPT);
  arquivo.Append('DLLPATH:'+FDLLPATH);
  arquivo.Append('DLLMYPATH:'+FDLLMYPATH);
  arquivo.Append('DLLPOSTPATH:'+FDLLPOSTPATH);

  arquivo.Append('HOSTNAMEMY:'+FHostnameMy);
  arquivo.Append('BANCOMY:'+FBancoMy);
  arquivo.Append('USERNAMEMY:'+FUsernameMy);
  arquivo.Append('PASSWORDMY:'+FPasswordMy);

  arquivo.Append('HOSTNAMEPOST:'+FHostnamePOST);
  arquivo.Append('BANCOPOST:'+FBancoPOST);
  arquivo.Append('USERNAMEPOST:'+FUsernamePOST);
  arquivo.Append('PASSWORDPOST:'+FPasswordPOST);
  arquivo.Append('SCHEMAPOST:'+FSchemaPost);
  arquivo.Append('TOOLSFALAR:'+iif(FToolsFalar,'1','0'));
  arquivo.Append('URLSERVIDOR:'+FURLServidor);
  arquivo.Append('ATIVASOM:'+booltostr(FATIVASOM));

  arquivo.Append('USERNAMEEMAIL:'+FUsernameEmail);
  arquivo.Append('PASSWORDEMAIL:'+FPasswordEmail);
  arquivo.Append('EMAILEMAIL:'+FEMAILEmail);
  arquivo.Append('LOGIN:'+FLogin);
  arquivo.Append('STRINGCONEXAO:'+FSTRINGCONEXAO);
  arquivo.Append('CLIMATEMPO:'+FClimaTempo);
  arquivo.Append('CIDADECODIGO:'+FCIDADECODIGO);
  arquivo.SaveToFile(fpath+filename);
end;

destructor TSetMain.Destroy;
begin
  //SalvaContexto(false);
  arquivo.free;
  arquivo := nil;
  FFONT.free;
end;

end.




