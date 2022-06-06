unit pl_cliente_email;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, pl_cliente_email_intf, IdPOP3, IdMessage, Dialogs;

type

  { TPLClienteEMail }

  TPLClienteEMail = class(TInterfacedObject, IPLClienteEMail)
  private
    FMessageCount: integer;
    FConnected: boolean;
    fIdMessage: TIdMessage;
    fIdPOP3: TIdPOP3;
  public

    constructor Create;
    destructor Destroy; override;
    class function New: IPLClienteEMail;

    function Host(pHost: string): IPLClienteEMail;
    function Port(pPort: integer): IPLClienteEMail;
    function Username(pUsername: string): IPLClienteEMail;
    function Password(pPassword: string): IPLClienteEMail;
    function Connect: IPLClienteEMail;
    function Disconnect: IPLClienteEMail;
    function GetMessageCount: integer;
    function Connected: boolean;
    function GetEmail(pValue: integer): TRecEmail;
    function DeleteEmail(pValue: integer): IPLClienteEMail;


  end;

implementation

{ TPLClienteEMail }

constructor TPLClienteEMail.Create;
begin
  fIdPOP3 := TIdPOP3.Create(nil);
  fIdMessage := TIdMessage.Create;
end;

destructor TPLClienteEMail.Destroy;
begin
  if fIdPOP3.Connected then
    fIdPOP3.Disconnect;
  fIdPOP3.Free;
  if Assigned(fIdMessage) then
    fIdMessage.Free;
  inherited Destroy;
end;

class function TPLClienteEMail.New: IPLClienteEMail;
begin
  Result := Self.Create;
end;

function TPLClienteEMail.Host(pHost: string): IPLClienteEMail;
begin
  Result := self;
  fIdPOP3.Host := pHost;
end;

function TPLClienteEMail.Port(pPort: integer): IPLClienteEMail;
begin
  Result := self;
  fIdPOP3.Port := pPort;

end;

function TPLClienteEMail.Username(pUsername: string): IPLClienteEMail;
begin
  Result := self;
  fIdPOP3.Username := pUsername;

end;

function TPLClienteEMail.Password(pPassword: string): IPLClienteEMail;
begin
  Result := self;
  fIdPOP3.Password := pPassword;
end;

function TPLClienteEMail.Connect: IPLClienteEMail;
begin
  Result := self;
  try
    fIdPOP3.Connect;
  except
    On  e: Exception do
    begin
      raise Exception.Create(
        'Não foi possível conectar no servidor de email.Mensagem: ' + e.message);
    end
  end;

end;

function TPLClienteEMail.Disconnect: IPLClienteEMail;
begin
  if fIdPOP3.Connected then;
  fIdPOP3.Disconnect;
end;

function TPLClienteEMail.GetMessageCount: integer;
begin
  Result := fIdPOP3.CheckMessages;
end;

function TPLClienteEMail.Connected: boolean;
begin
  Result := fIdPOP3.Connected;
end;

function TPLClienteEMail.GetEmail(pValue: integer): TRecEmail;
begin
  fIdPOP3.Retrieve(pValue, fIdMessage);
  Result.From := fIdMessage.From.Address;
  Result.Subject := fIdMessage.Subject;
  Result.Body := fIdMessage.Body.Text;
end;

function TPLClienteEMail.DeleteEmail(pValue: integer): IPLClienteEMail;
begin
  Result := self;
  fIdPOP3.Delete(pValue);
end;

end.
