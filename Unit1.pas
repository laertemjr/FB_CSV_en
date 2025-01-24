unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB, StrUtils,
  Vcl.ComCtrls, ShellAPI, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.Phys.FB, FireDAC.Phys.FBDef;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    OpenDialog1: TOpenDialog;
    btnSelecBD: TButton;
    edtBD: TEdit;
    cbbTabela: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btnExport: TButton;
    Label5: TLabel;
    btnSelectCSV: TButton;
    edtCSV: TEdit;
    Label6: TLabel;
    ProgressBar1: TProgressBar;
    btnImport: TButton;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDTable1: TFDTable;
    Label7: TLabel;
    edtPort: TEdit;
    Label8: TLabel;
    Panel4: TPanel;
    procedure btnSelecBDClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnSelectCSVClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure cbbTabelaExit(Sender: TObject);
    procedure conectParams();
    procedure FormActivate(Sender: TObject);
    procedure clean();
    function FileIsEmpty(const FileName: String): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  caminho:string;

implementation

{$R *.dfm}

procedure TForm1.FormActivate(Sender: TObject);
begin
   btnExport.Enabled    := False;
   btnImport.Enabled    := False;
   btnSelectCSV.Enabled := False;
   cbbTabela.Enabled    := False;
   caminho := EmptyStr;
end;

procedure TForm1.btnSelecBDClick(Sender: TObject);
var s:string;
begin
   clean;
   OpenDialog1.Filter := 'Firebird databases (*.gdb, *.fdb)|*.GDB;*.FDB';
   OpenDialog1.FileName := EmptyStr;
   if caminho <> EmptyStr then
      OpenDialog1.InitialDir := caminho;

   if OpenDialog1.Execute then
   begin
      edtBD.Text := OpenDialog1.FileName;
      s := UpperCase(RightStr(edtBD.Text,3));
      if (s <> 'GDB') and (s <> 'FDB')then
      begin
        ShowMessage('It is not a Firebird database.');
        clean;
        Exit;
      end;

      // Guarda o caminho onde estão os bancos de dados
      caminho :=   ExtractFilePath(OpenDialog1.FileName);

      try
         FDConnection1.Connected := False;
         conectParams;
         // local do BD
         FDConnection1.Params.Add('Database=' + edtBD.Text);
         // Porta
         FDConnection1.Params.Add('Port=' + edtPort.Text);
         FDConnection1.Connected := True;
         edtPort.Enabled := False;
         FDConnection1.GetTableNames('', '', '', cbbTabela.Items);
         cbbTabela.ItemIndex := 0;
         cbbTabela.Enabled := True;
         if cbbTabela.Text = EmptyStr then
         begin
            ShowMessage('There are no tables to export/import.');
            clean;
         end
         else
            begin
               FDTable1.TableName := cbbTabela.Text;
               btnExport.Enabled    := True;
               btnSelectCSV.Enabled := True;
            end;
      except
         ShowMessage('Unable to connect to database.');
         clean;
      end;
   end
end;

procedure TForm1.btnExportClick(Sender: TObject);
var
   arqTXT:TextFile;
   i,c:Integer;
begin
   try
      FDTable1.Open;
      FDTable1.Last;
      FDTable1.First;
      if FDTable1.RecordCount = 0 then
      begin
         ShowMessage('There is no data to export: the table is empty.');
         FDTable1.Close;
         Exit;
      end;
   except
      ShowMessage('Table has incompatible fields type(s) with FireDAC standard.');
      FDTable1.Close;
      Exit;
   end;

   AssignFile(arqTXT, ExtractFilePath(Application.ExeName)+Trim(cbbTabela.Text)+'.txt');
   Rewrite(arqTXT);
   FDTable1.Last;
   FDTable1.First;
   ProgressBar1.Min := 0;
   ProgressBar1.Max := FDTable1.RecordCount -1;
   c := 0;

   while not FDTable1.EOF do
   begin
      for i:=0 to FDTable1.Fields.Count -1 do
         Write(arqTXT, FDTable1.Fields[i].AsString + ';');

      Writeln(arqTXT, '|'); { '|' : end of record (could be another character as long as it is of the "visible" type)
                              and different from the field delimiter ';'}
      ProgressBar1.Position := c;
      FDTable1.Next;
      Inc(c);
   end;

   CloseFile(arqTXT);
   ShowMessage(cbbTabela.Text+'.txt'+' successfully recorded on '+ExtractFilePath(Application.ExeName));
   // Open File Explorer in the folder where the .TXT file was saved.
   ShellExecute(Application.Handle, 'open', PChar(ExtractFilePath(Application.ExeName)),nil, nil, SW_SHOWDEFAULT);
   FDTable1.Close;
   ProgressBar1.Position := 0;
end;

procedure TForm1.btnSelectCSVClick(Sender: TObject);
var s:string;
begin
   OpenDialog1.Filter := 'Text Files (*.txt)|*.txt';
   OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName);
   OpenDialog1.FileName := EmptyStr;

   if OpenDialog1.Execute Then
   begin
      edtCSV.Text := OpenDialog1.FileName;
      s := UpperCase(RightStr(edtCSV.Text,3));

      if (s <> 'TXT') or FileIsEmpty(edtCSV.Text) then
      begin
         ShowMessage('It is not a valid text file.');
         edtCSV.Clear;
         btnImport.Enabled := False;
         Exit;
      end;
      btnImport.Enabled := True;
   end;
end;

procedure TForm1.btnImportClick(Sender: TObject);
var
   gravar, ler :TStrings;
   i,c,p:Integer;
   erro:Boolean;
   campoStr:string;
begin
   gravar := TStringList.Create;
   ler    := TStringList.Create;
   erro   := False;

   try
      try
         ler.LoadFromFile(edtCSV.Text);
         gravar.Delimiter := ';';
         gravar.StrictDelimiter := True;
         ProgressBar1.Min := 0;
         ProgressBar1.Max := ler.count-1;
         FDTable1.Open;

         for i := 0 to Pred(ler.count) do
         begin
            gravar.DelimitedText := ler.Strings[i];

            with FDTable1 do
            begin
               Append;

               for c := 0 to FDTable1.Fields.Count-1 do
                  Fields[c].AsString := gravar.Strings[c];

               ProgressBar1.Position := i;
               Post;
            end;
         end;

         FDTable1.Refresh;
         except
            erro := True;
      end;
   finally
      if erro then
        ShowMessage('Unable to import data.')
      else
        ShowMessage('Import successful.');

      ProgressBar1.Position := 0;
      FDTable1.Close;
      gravar.Free;
      ler.Free;
  end;
end;

procedure TForm1.conectParams;
begin
   FDConnection1.Params.Clear;
   // DriverName
   FDConnection1.DriverName := 'FB';
   // DriverID
   FDConnection1.Params.Add('DriverID=FB');
   // Usuário
   FDConnection1.Params.Add('User_Name=SYSDBA');
   // PassWord
   FDConnection1.Params.Add('Password=masterkey');
   // Protocolo
   FDConnection1.Params.Add('Protocol=TCPIP');
   // Servidor
   FDConnection1.Params.Add('Server=127.0.0.1');
   // CharacterSet
   FDConnection1.Params.Add('CharacterSet=WIN1252');
   // Login Prompt
   FDConnection1.LoginPrompt := False;
   // SQL Dialect
   //FDConnection1.Params.Add('SQLDialect=3');
end;

  procedure TForm1.cbbTabelaExit(Sender: TObject);
begin
  FDTable1.TableName := cbbTabela.Text;
end;

procedure TForm1.clean;
begin
   edtBD.Text := EmptyStr;
   cbbTabela.Clear;
   cbbTabela.Enabled := False;
   btnExport.Enabled    := False;
   btnSelectCSV.Enabled := False;
   edtCSV.Clear;
   btnImport.Enabled := False;
   edtPort.Enabled := True;
   edtPort.SetFocus;
   edtPort.SelStart := Length(edtPort.Text);
   ProgressBar1.Position := 0;
end;

function TForm1.FileIsEmpty(const FileName: String): Boolean;
var
   fad: TWin32FileAttributeData;
begin
   Result := GetFileAttributesEx(PChar(FileName), GetFileExInfoStandard, @fad) and
             (fad.nFileSizeLow = 0) and (fad.nFileSizeHigh = 0);
end;

end.
