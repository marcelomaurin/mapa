unit mapa;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus,
  mvTypes, ComCtrls, StdCtrls, Grids, mvMapViewer, mvGeoNames, mvDLEFpc,
  uPoweredby, owmurloptions, urloptionsedit, germap, mvGpsObj, mvDrawingEngine,
  ImgList, Buttons, PopupNotifier, searchmapa, funcoes;


type

  { Tfrmmapa }

  Tfrmmapa = class(TForm)
    btVisualizar: TButton;
    btIncluir: TButton;
    edAPIKEY: TEdit;
    edPesquisar: TEdit;
    imgMapa: TImageList;
    Label5: TLabel;
    lbVersao: TLabel;
    Label8: TLabel;
    MapView1: TMapView;
    eddetalhes: TMemo;
    MenuItem10: TMenuItem;
    miOcultar: TMenuItem;
    OWMForecastDailyOptions1: TOWMForecastDailyOptions;
    PageControl2: TPageControl;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    pnDetalhes: TPanel;
    pnPesquisa: TPanel;
    Pesquisar: TButton;
    edEndereco: TEdit;
    edZoom: TEdit;
    edLatitude: TEdit;
    edLongitude: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MenuItem9: TMenuItem;
    MVDEFPC1: TMVDEFPC;
    MVGeoNames1: TMVGeoNames;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    pmDetalhes: TPopupMenu;
    PageControl1: TPageControl;
    pnTop: TPanel;
    pnBotton: TPanel;
    pnClient: TPanel;
    Poweredby1: TPoweredby;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    tbDetalhes: TTabSheet;
    tvLocais: TTreeView;
    tsmapanormal: TTabSheet;
    tsMapa: TTabSheet;
    tsConfig: TTabSheet;
    procedure btIncluirClick(Sender: TObject);
    procedure btVisualizarClick(Sender: TObject);
    procedure edEnderecoKeyPress(Sender: TObject; var Key: char);
    procedure edPesquisarKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgMapaGetWidthForPPI(Sender: TCustomImageList; AImageWidth,
      APPI: Integer; var AResultWidth: Integer);
    procedure MapView1CenterMove(Sender: TObject);
    procedure MapView1Change(Sender: TObject);
    procedure MapView1DrawGpsPoint(Sender: TObject;
      ADrawer: TMvCustomDrawingEngine; APoint: TGpsPoint);
    procedure MapView1ZoomChange(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure miOcultarClick(Sender: TObject);
    procedure PesquisarClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure tvLocaisChange(Sender: TObject; Node: TTreeNode);
    procedure tvLocaisClick(Sender: TObject);
  private
    procedure AdicionarItensNoMapa; // Método para adicionar os itens do StringGrid ao mapa
  public
    procedure PesquisarEndereco(endereco : string);
    procedure CarregaLista();
  end;

var
  frmmapa: Tfrmmapa;

implementation

{$R *.lfm}

{ Tfrmmapa }

procedure Tfrmmapa.MenuItem5Click(Sender: TObject);
begin
  Close;
end;

procedure Tfrmmapa.miOcultarClick(Sender: TObject);
begin
  pnDetalhes.Visible:= false;
end;

procedure Tfrmmapa.PesquisarClick(Sender: TObject);
begin
  PesquisarEndereco(edEndereco.text);
end;

procedure Tfrmmapa.SpeedButton1Click(Sender: TObject);
begin
  FGERMAP.Zoom := FGERMAP.Zoom + 1;
end;

procedure Tfrmmapa.SpeedButton2Click(Sender: TObject);
begin
  FGERMAP.Zoom := FGERMAP.Zoom - 1;
end;

procedure Tfrmmapa.tvLocaisChange(Sender: TObject; Node: TTreeNode);
begin

end;

procedure Tfrmmapa.tvLocaisClick(Sender: TObject);
begin

end;

procedure Tfrmmapa.FormCreate(Sender: TObject);
begin
  FSearchMapa := TSearchMapa.create();
  CarregaLista();


end;

procedure Tfrmmapa.FormDestroy(Sender: TObject);
begin
  StringGrid1.SaveToCSVFile('arquiv.lst',',',false,false);
  FSearchMapa.free;
end;

procedure Tfrmmapa.imgMapaGetWidthForPPI(Sender: TCustomImageList; AImageWidth,
  APPI: Integer; var AResultWidth: Integer);
begin

end;

procedure Tfrmmapa.btVisualizarClick(Sender: TObject);
begin
  FGERMAP.CarregarMapaRegiao(StrToFloat(edLongitude.text), StrToFloat(edLatitude.text), StrToInt(edZoom.text));
end;

procedure Tfrmmapa.edEnderecoKeyPress(Sender: TObject; var Key: char);
begin
  if(key=#13) then
  begin
       PesquisarEndereco(edEndereco.text);
  end;
end;

procedure Tfrmmapa.edPesquisarKeyPress(Sender: TObject; var Key: char);
begin
  if(key=#13) then
  begin
       PesquisarEndereco(edPesquisar.text);
  end;
end;

procedure Tfrmmapa.btIncluirClick(Sender: TObject);
begin
  //StringGrid1.InsertRowWithValues(1,['11','12']);
  StringGrid1.InsertRowWithValues(1,[edEndereco.Text,floattostr(FSearchMapa.Lista[0].FindPath('lat').AsFloat),floattostr(FSearchMapa.Lista[0].FindPath('lon').AsFloat),edEndereco.Text,'','OUTROS','',datetostr(now)]);
  //StringGrid1.LoadFromCSVFile('arquivo.lst',',',false,0,false);
  StringGrid1.SaveToCSVFile('arquivo.lst',',',False,False);
  CarregaLista();
end;

procedure Tfrmmapa.AdicionarItensNoMapa;
var
  i: Integer;
  Unidade, Descricao: String;
  Latitude, Longitude: Double;
  MapItem: TGPSPointOfInterest;
  tipo : string;
begin
  // Percorrer todas as linhas do StringGrid1 (a partir da linha 1, ignorando o cabeçalho)
  for i := 1 to StringGrid1.RowCount - 1 do
  begin
    Unidade := StringGrid1.Cells[0, i]; // Coluna "Unidade"
    Latitude := StrToFloat(StringGrid1.Cells[1, i]); // Coluna "Latitude"
    Longitude := StrToFloat(StringGrid1.Cells[2, i]); // Coluna "Longitude"
    Descricao := StringGrid1.Cells[3, i]; // Coluna "Descrição"
    tipo := StringGrid1.Cells[5, i]; // Coluna "Descrição"

    // Adicionar o item ao mapa
    FGERMAP.ItemsAdd(Unidade,Latitude,Longitude,Descricao, tipo);
  end;
end;

procedure Tfrmmapa.PesquisarEndereco(endereco: string);
var
  info : string;
  posicao : TRealPoint;
  a : integer;
  CidadeCodigo : string;
begin

  MapView1.Active:= false;
  info :=LowerCase(tiraacento(LowerCase(endereco)));
  //FSearchMapa := TSearchMapa.create();
  FSearchMapa.Search(info);
  eddetalhes.Lines.Clear;
  if (FSearchMapa.count<>0) then
  begin
     for a := 0 to FSearchMapa.count-1 do
     begin
       if (a = 0) then
       begin
         posicao.Lat:=  FSearchMapa.Lista[a].FindPath('lat').AsFloat;
         posicao.Lon := FSearchMapa.Lista[a].FindPath('lon').Asfloat;


         MapView1.Center := posicao;
         MapView1.Zoom:=18;
         MapView1.Active:=true;

         eddetalhes.Lines.Append('Endereço mais provavel');
         eddetalhes.Lines.Append('=====================');
         eddetalhes.Lines.Append(FSearchMapa.Lista[a].FindPath('display_name').asstring);
         eddetalhes.Lines.Append(' ');
       end
       else
       begin
            eddetalhes.Lines.Append('Outros endereços');
            eddetalhes.Lines.Append('================');
            eddetalhes.Lines.append(FSearchMapa.Lista[a].FindPath('display_name').asstring);
            eddetalhes.Lines.Append(' ');
       end;
     end;
  end;
  //FSearchMapa.free;

end;

procedure Tfrmmapa.CarregaLista();
begin
  StringGrid1.LoadFromCSVFile('arquivo.lst',',',false,0,false);
  // Definir o ponto como separador decimal
  DecimalSeparator := '.';
  tvLocais.Items[0].DeleteChildren;

  // Criar o mapa e ativá-lo
  FGERMAP := TGerMap.Create(MapView1, tvLocais, pnDetalhes,edAPIKEY.text,  StrToFloat(edLongitude.text), StrToFloat(edLatitude.text));
  FGERMAP.CarregarMapaRegiao(StrToFloat(edLongitude.text), StrToFloat(edLatitude.text), StrToInt(edZoom.text));
  // Adicionar itens do StringGrid1 no mapa
  AdicionarItensNoMapa;
  tvLocais.FullExpand;

end;

procedure Tfrmmapa.MapView1CenterMove(Sender: TObject);
begin
  // Aqui você pode adicionar lógica quando o centro do mapa for movido, se necessário
end;

procedure Tfrmmapa.MapView1Change(Sender: TObject);
begin
  StatusBar1.Panels.Items[0].Text := MapView1.Engine.Center.Lat.ToString;
  StatusBar1.Panels.Items[1].Text := MapView1.Engine.Center.Lon.ToString;
  StatusBar1.Panels.Items[2].Text := MapView1.Engine.Height.ToString;
end;

procedure Tfrmmapa.MapView1DrawGpsPoint(Sender: TObject;
  ADrawer: TMvCustomDrawingEngine; APoint: TGpsPoint);
begin
  // Lógica para desenhar os pontos GPS, se necessário
  //StatusBar1.Panels.Items[3].Text := APoint.Name;
end;

procedure Tfrmmapa.MapView1ZoomChange(Sender: TObject);
begin
  // Lógica para lidar com a mudança de zoom, se necessário
end;

procedure Tfrmmapa.MenuItem10Click(Sender: TObject);
begin
  StringGrid1.InsertRowWithValues(1,['sem nome',MapView1.Engine.Center.Lat.ToString,MapView1.Engine.Center.Lon.ToString,'sem endereco']);
end;

end.

