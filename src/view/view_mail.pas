unit view_mail;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  ExtCtrls, DBCtrls, IdPOP3, IdMessage, pl_cliente_email_intf, pl_cliente_email,
  DB, BufDataset;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button2: TButton;
    DBGrid1: TDBGrid;
    DBMemo1: TDBMemo;
    Panel1: TPanel;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fTBlEmail : TBufDataset;
    fDtSrc : TDataSource;

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button2Click(Sender: TObject);
var
  LPLEmailCliente: IPLClienteEMail;
  i : Integer;
  Email : TRecEmail;
begin
  LPLEmailCliente := TPLClienteEMail.new;
  if LPLEmailCliente.Host('mail.semduotectecnologia.com.br').Username(
    'backup_bem_feito@semduotectecnologia.com.br').Password('sempre@a@melhor@senha@123').Port(
    110).Connect.Connected then
  begin
    For i := 2 To LPLEmailCliente.GetMessageCount do
    begin
      Email := LPLEmailCliente.GetEmail(i);
      fTBlEmail.Append;
      fTBlEmail.FieldByName('FROM').AsString:= Email.From;
      fTBlEmail.FieldByName('SUBJECT').AsString:= Email.Subject;
      fTBlEmail.FieldByName('BODY').AsString:= Email.Body;
      fTBlEmail.Post;
      LPLEmailCliente.DeleteEmail(i);
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.WindowState:= wsMaximized;

  fTBlEmail := TBufDataset.Create(Self);
  fTBlEmail.FieldDefs.Add('FROM',ftString, 100);
  fTBlEmail.FieldDefs.Add('SUBJECT',ftString, 100);
  fTBlEmail.FieldDefs.Add('BODY',ftMemo);
  fTBlEmail.CreateDataset;;
  fDtSrc := TDataSource.Create(Self);
  fDtSrc.DataSet := fTBlEmail;

  DBGrid1.DataSource := fDtSrc;
  DBGrid1.Columns.Add.FieldName:='FROM';
  DBGrid1.Columns.Add.FieldName:='SUBJECT';
  DBGrid1.Width:= Trunc(Screen.Width * 70 / 100);
  DBGrid1.Align:= alLeft;
  DBMemo1.Align:= alClient;

  DBMemo1.DataSource := fDtSrc;
  DBMemo1.DataField:= 'BODY';

end;

end.
