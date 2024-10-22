unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    BtnColorDinding: TButton;
    BtnColorAtap: TButton;
    BtnColorPintu: TButton;
    BtnColorJendela: TButton;
    BtnZoomIn: TButton;
    BtnZoomOut: TButton;
    BtnMoveLeft: TButton;
    BtnMoveRight: TButton;
    BtnStartAnimation: TButton;
    BtnPemandangan: TButton; // Tombol untuk menampilkan pemandangan
    ColorDialog1: TColorDialog;
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    procedure BtnColorAtapClick(Sender: TObject);
    procedure BtnColorDindingClick(Sender: TObject);
    procedure BtnColorJendelaClick(Sender: TObject);
    procedure BtnColorPintuClick(Sender: TObject);
    procedure BtnMoveLeftClick(Sender: TObject);
    procedure BtnMoveRightClick(Sender: TObject);
    procedure BtnZoomInClick(Sender: TObject);
    procedure BtnZoomOutClick(Sender: TObject);
    procedure BtnStartAnimationClick(Sender: TObject);
    procedure BtnPemandanganClick(Sender: TObject); // Prosedur untuk menggambar pemandangan
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    DindingColor, AtapColor, PintuColor, JendelaColor: TColor;
    ScaleFactor: Double;
    OffsetX, AnimDirection: Integer;
    ShowPemandangan: Boolean; // Menyimpan status apakah pemandangan ditampilkan
    procedure DrawHouse(ACanvas: TCanvas);
    procedure DrawPemandangan(ACanvas: TCanvas); // Prosedur untuk menggambar pemandangan
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  DindingColor := clWhite;
  AtapColor := clRed;
  PintuColor := RGBToColor(139, 69, 19);
  JendelaColor := clBlue;
  ScaleFactor := 1.0;
  OffsetX := 0;
  AnimDirection := 1;
  ShowPemandangan := False; // Awalnya pemandangan tidak ditampilkan
end;

procedure TForm1.DrawHouse(ACanvas: TCanvas);
var
  W, H, PintuW, PintuH, JendelaW, JendelaH: Integer;
begin
  W := Round(100 * ScaleFactor); // Lebar dinding
  H := Round(80 * ScaleFactor);  // Tinggi dinding

  // Ukuran pintu dan jendela juga mengikuti ScaleFactor
  PintuW := Round(40 * ScaleFactor);  // Lebar pintu
  PintuH := Round(40 * ScaleFactor);  // Tinggi pintu
  JendelaW := Round(20 * ScaleFactor); // Lebar jendela
  JendelaH := Round(20 * ScaleFactor); // Tinggi jendela

  // Gambar dinding
  ACanvas.Brush.Color := DindingColor;
  ACanvas.FillRect(OffsetX + 50, 150, OffsetX + 50 + W, 150 + H);

  // Gambar atap
  ACanvas.Brush.Color := AtapColor;
  ACanvas.Polygon([Point(OffsetX + 50, 150), Point(OffsetX + 50 + W, 150), Point(OffsetX + 50 + W div 2, 100)]);

  // Gambar pintu
  ACanvas.Brush.Color := PintuColor;
  ACanvas.FillRect(OffsetX + 50 + (W div 2) - (PintuW div 2), 150 + H - PintuH, OffsetX + 50 + (W div 2) + (PintuW div 2), 150 + H);

  // Gambar jendela kiri
  ACanvas.Brush.Color := JendelaColor;
  ACanvas.Ellipse(OffsetX + 50 + (W div 4) - (JendelaW div 2), 150 + (H div 4) - (JendelaH div 2),
                  OffsetX + 50 + (W div 4) + (JendelaW div 2), 150 + (H div 4) + (JendelaH div 2));

  // Gambar jendela kanan
  ACanvas.Ellipse(OffsetX + 50 + (3 * W div 4) - (JendelaW div 2), 150 + (H div 4) - (JendelaH div 2),
                  OffsetX + 50 + (3 * W div 4) + (JendelaW div 2), 150 + (H div 4) + (JendelaH div 2));

  // Gambar pemandangan jika ShowPemandangan = True
  if ShowPemandangan then
    DrawPemandangan(ACanvas);
end;

procedure TForm1.DrawPemandangan(ACanvas: TCanvas);
begin
  // Menggambar jalan di bagian bawah PaintBox
  ACanvas.Brush.Color := clGray;
  ACanvas.FillRect(0, 350, PaintBox1.Width, 400); // Jalan lebih jauh dari rumah

  // Menggambar pohon di sebelah kiri rumah, tidak mengganggu rumah
  ACanvas.Brush.Color := RGBToColor(139, 69, 19); // Warna batang pohon
  ACanvas.FillRect(OffsetX + 10, 250, OffsetX + 30, 350); // Batang pohon di kiri bawah
  ACanvas.Brush.Color := clGreen;
  ACanvas.Ellipse(OffsetX - 10, 200, OffsetX + 50, 260); // Daun pohon

  // Menggambar rumput di sekitar jalan
  ACanvas.Brush.Color := clLime;
  ACanvas.FillRect(0, 340, PaintBox1.Width, 350); // Rumput di atas jalan
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  DrawHouse(PaintBox1.Canvas);
end;

procedure TForm1.BtnColorDindingClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    DindingColor := ColorDialog1.Color;
    PaintBox1.Invalidate;
  end;
end;

procedure TForm1.BtnColorAtapClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    AtapColor := ColorDialog1.Color;
    PaintBox1.Invalidate;
  end;
end;

procedure TForm1.BtnColorPintuClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    PintuColor := ColorDialog1.Color;
    PaintBox1.Invalidate;
  end;
end;

procedure TForm1.BtnColorJendelaClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    JendelaColor := ColorDialog1.Color;
    PaintBox1.Invalidate;
  end;
end;

procedure TForm1.BtnZoomInClick(Sender: TObject);
begin
  ScaleFactor := ScaleFactor + 0.1;
  PaintBox1.Invalidate;
end;

procedure TForm1.BtnZoomOutClick(Sender: TObject);
begin
  ScaleFactor := ScaleFactor - 0.1;
  if ScaleFactor < 0.1 then ScaleFactor := 0.1;
  PaintBox1.Invalidate;
end;

procedure TForm1.BtnMoveLeftClick(Sender: TObject);
begin
  OffsetX := OffsetX - 10;
  PaintBox1.Invalidate;
end;

procedure TForm1.BtnMoveRightClick(Sender: TObject);
begin
  OffsetX := OffsetX + 10;
  PaintBox1.Invalidate;
end;

procedure TForm1.BtnStartAnimationClick(Sender: TObject);
begin
  Timer1.Enabled := not Timer1.Enabled; // Toggle timer
  if Timer1.Enabled then
    BtnStartAnimation.Caption := 'Stop Animation'
  else
    BtnStartAnimation.Caption := 'Start Animation';
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  // Menggerakkan rumah secara bergantian kiri dan kanan
  OffsetX := OffsetX + (5 * AnimDirection);
  if (OffsetX > 100) or (OffsetX < -100) then
    AnimDirection := -AnimDirection; // Balik arah jika mencapai batas
  PaintBox1.Invalidate;
end;

procedure TForm1.BtnPemandanganClick(Sender: TObject);
begin
  // Toggle status pemandangan
  ShowPemandangan := not ShowPemandangan;
  if ShowPemandangan then
    BtnPemandangan.Caption := 'Sembunyikan Pemandangan'
  else
    BtnPemandangan.Caption := 'Tampilkan Pemandangan';

  PaintBox1.Invalidate; // Refresh tampilan
end;

end.

