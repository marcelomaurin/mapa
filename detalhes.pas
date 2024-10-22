unit detalhes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmDetalhes }

  TfrmDetalhes = class(TForm)
    btFechar: TButton;
    edLatitude: TEdit;
    edLongitude: TEdit;
    lblatitude: TLabel;
    lbLongitude: TLabel;
    procedure btFecharClick(Sender: TObject);
    procedure edLongitudeChange(Sender: TObject);
  private

  public

  end;

var
  frmDetalhes: TfrmDetalhes;

implementation

{$R *.lfm}

{ TfrmDetalhes }

procedure TfrmDetalhes.edLongitudeChange(Sender: TObject);
begin

end;

procedure TfrmDetalhes.btFecharClick(Sender: TObject);
begin
  close;
end;

end.

