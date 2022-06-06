unit pl_cliente_email_intf;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  TRecEmail = record
    From: string;
    Subject: string;
    Body: string;
  end;

  IPLClienteEMail = interface
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

end.;
