unit RiverRide;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.MPlayer,pngimage;

type
  TFormJogo = class(TForm)
    painelEsq: TPanel;
    painelDir: TPanel;
    nave: TImage;
    tempoTiro: TTimer;
    navio: TImage;
    helicoptero: TImage;
    ajato: TImage;
    tempoInimigo: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure atirar();
    procedure criarTiro();
    procedure tempoTiroTimer(Sender: TObject);
    procedure tempoInimigoTimer(Sender: TObject);
    procedure criarInimigo();
    function  VerificaColisao(O1, O2 : TControl):boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormJogo: TFormJogo;
  NumTiros: Integer;
  bateu : Boolean;

implementation

{$R *.dfm}

procedure TFormJogo.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  nave.Picture.LoadFromFile('D:\Documentos\Desktop\01 - Jogo\Rive Rider\img\eu.png');
  navio.Picture.LoadFromFile('D:\Documentos\Desktop\01 - Jogo\Rive Rider\img\inimigo\port.png');
  helicoptero.Picture.LoadFromFile('D:\Documentos\Desktop\01 - Jogo\Rive Rider\img\inimigo\helicoptero-militar.png');
  ajato.Picture.LoadFromFile('D:\Documentos\Desktop\01 - Jogo\Rive Rider\img\inimigo\plane2.png');


  navio.Visible := False;
  helicoptero.Visible := False;
  ajato.Visible := False;

  tempoInimigo.Enabled := True;
  bateu := True;
  NumTiros := 1;
  end;

procedure TFormJogo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
 var incremento : integer;
begin
  incremento := 7;

  case key of
    VK_LEFT  : if (nave.Left >= painelEsq.Width) then
                  nave.Left := nave.Left - incremento;
    VK_RIGHT : if (nave.Left <= 352) then
                  nave.Left := nave.Left + incremento;
    VK_UP    : nave.Top := nave.Top - incremento;
    VK_DOWN  : nave.Top := nave.Top + incremento;
    VK_SPACE:  atirar();
  end;
 end;

procedure TFormJogo.atirar();
var tiro: TPanel;
 begin
    criarTiro();
    tempoTiro.Enabled := True;
 end;

 procedure TFormJogo.criarTiro();
var tiro: TPanel;
 begin

    if (NumTiros < 20 ) then
    begin
      tiro := TPanel.Create(FormJogo);
      tiro.Parent := FormJogo;
      tiro.Left := nave.Left + 22;
      tiro.Top := nave.Top;
      tiro.Width := 5;
      tiro.Height := 5;
      tiro.Color := clYellow;
      tiro.ParentBackground := False;
      tiro.ParentColor := False;
      tiro.Caption := '';
      tiro.Tag := NumTiros;
      tiro.Visible := True;
    end;

 end;

procedure TFormJogo.tempoInimigoTimer(Sender: TObject);
var t : tpanel;
begin
  navio.Top :=  navio.Top +1;
  ajato.Top :=  ajato.Top +3;
  helicoptero.Top :=  helicoptero.Top +2;
  tempoInimigo.Interval := 4;

   if not(bateu) then
   begin
      t         := TPanel.Create(FormJogo);
      t.Parent  := FormJogo;
      t.Height  := 28;
      t.Width   := 28;
      t.ParentBackground := false;
      t.ParentColor := false;
      t.Color   := $008552E4;
      t.Caption := '';
      t.Top     := 40;
      t.Left    := Random(FormJogo.Width - 50);
      t.Tag     := 1;
      t.Visible := True;
   end;
   t.Top := t.Top +1;
end;

procedure TFormJogo.criarInimigo();
var inimigoNavio, inimigoHelicoptero, inimigoAjato : Integer;
begin
   inimigoNavio := random(painelDir.Left-painelEsq.Left);
   inimigoHelicoptero := random(painelDir.Left-painelEsq.Left);
   inimigoAjato := random(painelDir.Left-painelEsq.Left);

   navio.Left := inimigoNavio;
   navio.Top := 0;
   navio.Visible := True;

   ajato.Left := inimigoAjato;
   ajato.Top := 0;
   ajato.Visible := True;

   helicoptero.Left := inimigoHelicoptero;
   helicoptero.Top := 0;
   helicoptero.Visible := True;

   tempoInimigo.Enabled := True;

end;

procedure TFormJogo.tempoTiroTimer(Sender: TObject);
var i: Integer;
begin

    for i := 0 to FormJogo.ComponentCount-1 do
    begin
      if FormJogo.Components[i] is TPanel then
      begin
        if TPanel(FormJogo.Components[i]).Tag = NumTiros then
        begin
           TPanel(FormJogo.Components[i]).Top := TPanel(FormJogo.Components[i]).Top -3;
           tempoTiro.Interval := 1;

           if VerificaColisao(TPanel(FormJogo.Components[i]), navio) then
            begin

            end;
        end;
      end;
    end;


end;

function TFormJogo.VerificaColisao(O1, O2 : TControl): boolean;
var topo, baixo, esquerda, direita : boolean;
begin
    topo     := false;
    baixo    := false;
    esquerda := false;
    direita  := false;

    //label2.Caption := '';

    if (O1.Top >= O2.top ) and (O1.top  <= O2.top  + O2.Height) then
    begin
       topo := true;
       //label2.Caption := label2.Caption+ 'Topo, ';
    end;

    if (O1.left >= O2.left) and (O1.left <= O2.left + O2.Width ) then
    begin
      esquerda := true;
      //label2.Caption := label2.Caption+ ' Esquerda, ';
    end;

    if (O1.top + O1.Height >= O2.top ) and (O1.top + O1.Height  <= O2.top + O2.Height) then
    begin
      baixo := true;
      //label2.Caption := label2.Caption+ ' Baixo, ';
    end;

    if (O1.left + O1.Width >= O2.left ) and (O1.left + O1.Width  <= O2.left + O2.Width) then
    begin
      direita := true;
      //label2.Caption := label2.Caption+ ' Direita ';
    end;

    if (topo or baixo) and (esquerda or direita) then
       o2.Visible := false;

    VerificaColisao := (topo or baixo) and (esquerda or direita);

end;

 end.