unit GerMap;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, mvMapViewer, mvTypes, mvGpsObj, Graphics, Forms,
  ComCtrls,  owmurloptions, urloptionsedit, extCtrls;

type
  // Classe principal para gerenciar o mapa com objetos GPS

  { TGerMap }

  TGerMap = class
  private
    FMapView: TMapView;
    FLongitude: Double;
    FLatitude: Double;
    FItems: TGPSObjectList; // Lista de objetos GPS
    FTreeview : TTreeView;
    FKeyPass : String;
    FItemSel : TTreeNode;
    FZoom : integer;
    FpnDetalhes: TPanel;
    FOWMForecastDailyOptions1: TOWMForecastDailyOptions;
    procedure ConfigurarMapa;
    procedure SetZoom(AValue : integer);
  public
    constructor Create(AMapView: TMapView;ATVLOCAL: TTreeview; ApnDetalhes:TPanel; AKeypass: string; LLongitude, LLatitude: Double);
    destructor Destroy; override;
    procedure tvChange(Sender: TObject; Node: TTreeNode);
    procedure tvClick(Sender: TObject);
    procedure CarregarMapaRegiao(ALongitude, ALatitude: Double; AZoom: Integer);
    procedure ItemsClear;
    procedure ItemsAdd(Unidade: string; Latitude,Longitude: double ; Descricao: string; tipo : string);
    procedure ItemsRemove(AItem: TGPSPointOfInterest); // Remove objeto GPS do mapa
    property Items: TGPSObjectList read FItems;
    property Zoom : integer read FZoom write SetZoom;

  end;

var
  FGERMAP: TGerMap;

implementation

{ TGerMap }

constructor TGerMap.Create(AMapView: TMapView;ATVLOCAL: TTreeview; ApnDetalhes:TPanel; AKeypass: string; LLongitude, LLatitude: Double);
begin
  FMapView := AMapView;
  FKeyPass:= AKeypass;
  FTreeview := ATVLOCAL;
  FLongitude := LLongitude;
  FLatitude := LLatitude;
  FItems := TGPSObjectList.Create;
  FpnDetalhes:=ApnDetalhes;
  ConfigurarMapa;
  FMapView.Active := True;
  FTreeview.OnChange:= @tvChange;
  FTreeview.OnClick:= @tvClick;
  FOWMForecastDailyOptions1 := TOWMForecastDailyOptions.create(nil);
  FOWMForecastDailyOptions1.APIKey.Value:= FKeyPass;
end;

destructor TGerMap.Destroy;
begin
  ItemsClear; // Limpa os itens e objetos do mapa
  FItems.Free;
  inherited Destroy;
end;

procedure TGerMap.tvChange(Sender: TObject; Node: TTreeNode);
begin
  FItemSel := node;
end;

procedure TGerMap.tvClick(Sender: TObject);
var
  gpsPt: TGpsPointOfInterest;
begin
  if (FItemSel.Data <> nil) then
  begin
       gpsPt := TGpsPointOfInterest(FItemSel.Data);
       //procedure CarregarMapaRegiao(ALongitude, ALatitude: Double; AZoom: Integer);
       CarregarMapaRegiao( gpsPt.Lon,gpsPt.lat, FZoom);
       FpnDetalhes.Visible:= true;
  end;
end;

procedure TGerMap.ConfigurarMapa;
begin
  // Configurações iniciais do mapa
  // FMapView.MapProvider := mpGoogleMap; // Exemplo de provedor, comentado
  FZoom:= 5;
  FMapView.Zoom := FZoom; // Zoom padrão
end;

procedure TGerMap.SetZoom(AValue: integer);
begin
  FZoom:= AValue;
  FMapView.Zoom := AValue;
  FMapView.Invalidate; // Atualizar a visualização do mapa

end;

procedure TGerMap.CarregarMapaRegiao(ALongitude, ALatitude: Double; AZoom: Integer);
var
  NewCenter: TRealPoint;
begin
  // Definir o centro do mapa com as coordenadas fornecidas
  NewCenter.Lon := ALongitude;
  NewCenter.Lat := ALatitude;
  FMapView.Center := NewCenter;
  FZoom := AZoom;

  FMapView.Zoom := AZoom;
  FMapView.Invalidate; // Atualizar a visualização do mapa
end;

procedure TGerMap.ItemsClear;
begin
  // Limpar todos os objetos GPS do mapa
  FItems.Clear(0); // Limpa os itens com OwnerId 0 (ou todos)
  FMapView.GPSItems.Clear(0); // Limpar os objetos GPS do mapa
  FMapView.Invalidate; // Atualizar a visualização do mapa
  FTreeview.Items.Item[0].DeleteChildren;
end;

procedure TGerMap.ItemsAdd(Unidade: string; Latitude, Longitude: double;
  Descricao: string; tipo: string);
var
  gpsPt: TGpsPointOfInterest;
  realPoint: TRealPoint;
  TreeNode : TTreeNode;
begin
  // Inicializa o ponto real com as coordenadas fornecidas
  realPoint.Init(Longitude, Latitude);



  // Cria um ponto de interesse (POI) com base nas coordenadas fornecidas
  gpsPt := TGPSPointOfInterest.Create(realPoint.Lon, realPoint.Lat, NO_ELE, Now());

  // Define o nome do ponto de interesse como o nome da unidade
  gpsPt.Name := Unidade;

  TreeNode:=   FTreeview.Items.AddChild(FTreeview.Items.Item[0],Unidade);


  gpsPt.ImageIndex:=0;
  TreeNode.ImageIndex:=0;
  if (tipo = 'UBDS' ) then
  begin
       gpsPt.ImageIndex:=4;
       TreeNode.ImageIndex:=4;
  end;
  if (tipo = 'USF' ) then
  begin
       gpsPt.ImageIndex:=3;
       TreeNode.ImageIndex:=3;
  end;

  //gpsPt.ExtraData;
  gpsPt.Dispatch(Descricao);


  // Adiciona o POI à lista de objetos GPS e ao mapa
  //FItems.Add(gpsPt, 10);         // Adiciona à lista interna
  FMapView.GPSItems.Add(gpsPt,10); // Adiciona ao mapa
  TreeNode.Data:= Pointer(gpsPt);

  // Atualiza a visualização do mapa
  FMapView.Invalidate;
end;

procedure TGerMap.ItemsRemove(AItem: TGPSPointOfInterest);
begin
  // Remove o objeto GPS da lista e do mapa
  FItems.Delete(AItem); // Remove o item da lista de objetos GPS
  FMapView.GPSItems.Delete(AItem); // Remove o objeto GPS do mapa
  FMapView.Invalidate; // Atualizar a visualização do mapa
end;

end.

