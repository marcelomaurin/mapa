unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, mapa;

type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    btMapa: TButton;
    procedure btMapaClick(Sender: TObject);
  private

  public

  end;

var
  frmmain: Tfrmmain;

implementation

{$R *.lfm}

{ Tfrmmain }

procedure Tfrmmain.btMapaClick(Sender: TObject);
begin
  frmmapa := Tfrmmapa.Create(self);
  frmmapa.showmodal();
  frmmapa.close;
end;

end.

