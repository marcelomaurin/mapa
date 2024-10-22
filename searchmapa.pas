unit SearchMapa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, jsonparser, fphttpclient, opensslsockets,
  fpjson, IdURI, IdHTTP,BufDataset, IdSSLOpenSSL,sslsockets,
  IdCookieManager, idcookie, httpprotocol,uriparser, httpdefs,
  funcoes, mvTypes, setmain;



type
  { TSearchMapa }
  TSearchMapa = class(TObject)
  private
    FURL: String;
    FToken: String;
    Fcookies: TStringList;
    lHTTP1: TFPHttpClient;
    FCount : integer;
    FKeyClimatempo : string;
    //Temperatura
    Ftemperature : string;
    Fsensation : string;
    //Humidade
    Fhumidity : string;
    Fcondition : String;
    //Chuva
    Fpressure : string;


  public

    Lista: array of TJSONData;
    function Search(endereco: string): boolean;
    function Previsao(cidadecodigo: string): boolean;
    function BuscaCodigoCidade(Cidade: string; UF : string = 'SP'): string;
    constructor Create();
    destructor Destroy(); override;
    property count : integer read fcount;
    property KeyClimatempo : string  read FKeyClimatempo write FKeyClimatempo;
    property temperatura : string read Ftemperature;
    property sensation : string read Fsensation;
    property humidity : string read Fhumidity;
    property condition : string read fcondition;
    property pressure : string read fpressure;
  end;

var
  FSearchMapa: TSearchMapa;

implementation

{ TSearchMapa }

constructor TSearchMapa.Create;
begin
  inherited Create;

  // Inicializa as variáveis
  //FURL := 'https://nominatim.openstreetmap.org';
  FURL := 'http://nominatim.openstreetmap.org';
  FToken := '';
  Fcookies := TStringList.Create;
  Fcount := 0;
  // Criar e configurar o TFPHttpClient
  lHTTP1 := TFPHttpClient.Create(nil);
  lHTTP1.AllowRedirect := True;
  lHTTP1.AddHeader('User-Agent', 'Mozilla/5.0 (compatible; fphttpclient)');
end;

destructor TSearchMapa.Destroy;
begin
  Fcookies.Free;
  lHTTP1.Free;
  inherited Destroy;
end;

function TSearchMapa.Search(endereco: string): boolean;
var
  lResponseData: RawByteString;
  jsonResponse: TJSONData;
  jsonArray: TJSONArray;
  i: Integer;
  lSearchURL: string;
  iduri : TIdURI;
  url : string;
begin
  Result := False;
  //url := 'https://nominatim.openstreetmap.org/search?q=' +  URLEncode(endereco) + '&format=json&limit=10';
  url := 'http://nominatim.openstreetmap.org/search?q=' +  URLEncode(endereco) + '&format=json&limit=10';
  iduri := TIdURI.Create(url);

  if endereco = '' then Exit; // Verifica se o endereço foi informado

  try
    // Monta a URL da busca
    lSearchURL := url;
    iduri.free;
    // Atribui os cookies se necessário
    lHTTP1.Cookies.Assign(Fcookies);

    // Faz a requisição
    lResponseData := lHTTP1.Get(lSearchURL);

    // Processa a resposta JSON
    jsonResponse := GetJSON(lResponseData);
    try
      if jsonResponse.JSONType = jtArray then
      begin
        jsonArray := TJSONArray(jsonResponse);
        SetLength(Lista, jsonArray.Count);
        FCount := jsonArray.Count;
        // Preenche a lista com os resultados do JSON
        for i := 0 to jsonArray.Count - 1 do
        begin
          Lista[i] := jsonArray.Items[i]; // Armazena o registro encontrado
        end;

        Result := True; // Busca realizada com sucesso
      end;
    finally
      //jsonResponse.Free;
    end;

  except
    on E: Exception do
    begin
      // Em caso de erro, pode-se manipular a exceção aqui
      Result := False;
    end;
  end;
end;

function TSearchMapa.Previsao(cidadecodigo: string): boolean;
var
  lResponseData: RawByteString;
  jsonResponse: TJSONData;
  lSearchURL: string;
  iduri: TIdURI;
  url: string;
begin
  Result := False;
  //--url := 'https://www.climatempo.com.br/json/myclimatempo/user/weatherNow?idlocale=3618';
  //url := 'https://www.climatempo.com.br/json/myclimatempo/user/weatherNow?idlocale='+cidadecodigo;
  url := 'http://www.climatempo.com.br/json/myclimatempo/user/weatherNow?idlocale='+cidadecodigo;
  iduri := TIdURI.Create(url);

  try
    // Monta a URL da busca
    lSearchURL := url;
    iduri.Free;

    // Atribui os cookies se necessário
    lHTTP1.Cookies.Assign(Fcookies);

    // Faz a requisição
    lResponseData := lHTTP1.Get(lSearchURL);

    // Processa a resposta JSON
    jsonResponse := GetJSON(lResponseData);
    try
      // Atualiza o caminho para acessar os valores corretos no JSON
      Ftemperature := jsonResponse.FindPath('data.getWeatherNow[0].data[0].weather.temperature').AsString;
      Fhumidity := jsonResponse.FindPath('data.getWeatherNow[0].data[0].weather.humidity').AsString;
      Fpressure := jsonResponse.FindPath('data.getWeatherNow[0].data[0].weather.pressure').AsString;
      Fcondition := jsonResponse.FindPath('data.getWeatherNow[0].data[0].weather.condition').AsString;

      Result := True; // Busca realizada com sucesso

    finally
      // Libera a memória do JSON
      jsonResponse.Free;
    end;

  except
    on E: Exception do
    begin
      // Em caso de erro, pode-se manipular a exceção aqui
      Result := False;
    end;
  end;
end;

function TSearchMapa.BuscaCodigoCidade(Cidade: string; UF : string = 'SP'): string;
var
  lResponseData: RawByteString;
  jsonResponse: TJSONData;
  lSearchURL: string;
  iduri: TIdURI;
  url: string;
  idcidade : string;
begin
  if (FSetMain.Climatempo='') then
  begin
     Result := FSetMain.CidadeCodigo; //Atribui o codigo de ribeirão preto
  end
  else
  begin
      idCidade := '';
      //url := 'https://www.climatempo.com.br/json/myclimatempo/user/weatherNow?idlocale=3618';
      url := 'http://apiadvisor.climatempo.com.br/api/v1/locale/city?name='+Cidade+'&state='+UF+'&token='+FSetMain.Climatempo;
      iduri := TIdURI.Create(url);

      try
        // Monta a URL da busca
        lSearchURL := url;
        iduri.Free;

        // Atribui os cookies se necessário
        lHTTP1.Cookies.Assign(Fcookies);

        // Faz a requisição
        lResponseData := lHTTP1.Get(lSearchURL);

        // Processa a resposta JSON
        jsonResponse := GetJSON(lResponseData);
        try
          // Atualiza o caminho para acessar os valores corretos no JSON
          idcidade := jsonResponse.FindPath('id').AsString;


          Result := idcidade; // Busca realizada com sucesso

        finally
          // Libera a memória do JSON
          jsonResponse.Free;
        end;

      except
        on E: Exception do
        begin
          // Em caso de erro, pode-se manipular a exceção aqui
          Result := idcidade;
        end;
      end;

  end;
end;


end.

