unit MVCServerAdmin;

interface

uses
  System.Classes, System.SysUtils,
  System.Generics.Collections,
  MVCFramework, MVCFramework.Commons;

type

  [MVCPath('/OData/admin')]
  TODataUsers = class(TMVCController)
  public
    [MVCPath('/token/new')]
    [MVCHTTPMethod([httpGET])]
    procedure TokenNew;

    [MVCPath('/token/($token)/($name)/($secret)/($group)')]
    [MVCHTTPMethod([httpPUT])]
    procedure AddUser(const token: string; const name: String;
      const secret: string; const group: string);

    [MVCPath('/token/($token)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteUser(const token: string);

    [MVCPath('/token')]
    [MVCHTTPMethod([httpGET])]
    procedure ListUser(); overload;

    [MVCPath('/token/name/($name)')]
    [MVCHTTPMethod([httpGET])]
    procedure ListUser(const name: String); overload;

    [MVCPath('/token/($token)')]
    [MVCHTTPMethod([httpGET])]
    procedure ListUserByToken(const token: String); overload;

  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string;
      var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext;
      const AActionName: string); override;
  end;

implementation

uses
  System.Json,
  WS.Common, System.ThreadSafe,
  MVCFramework.Logger, OData.Packet.Encode;

type
  TTokenKey = string;

  TTokenAttrib = class(TObject)
  public
    name: string;
    secret: string;
    group: string;
    ipOrigin: string;
    constructor Create;virtual;
  end;

  TUsers = class(TThreadSafeDictionaryObject<TTokenAttrib>)
  private
    FFileName: string;
  public
    FError: string;
    procedure LoadFromFile(AFile: string);
    procedure SaveToFile(AFile: String = '');
  public
  end;

const
  TokenUserFileName = 'tokenUserList.json';

var
  LTokenUsers: TUsers;

procedure TODataUsers.TokenNew;
var
  s: string;
  r: IODataJsonPacket;
begin
  r := TODataJsonPacket.New(self.Context.Request.PathInfo, true);
  r.GenValue('token', TGuid.NewGuid.ToString());
  Render(r.AsJsonObject);
end;

procedure TODataUsers.AddUser(const token: string; const name: String;
  const secret: string; const group: string);
var
  obj: TTokenAttrib;
  r: IODataJsonPacket;
begin

  if LTokenUsers.ContainsKey(token) then
  begin
    obj := LTokenUsers.Items[token];
  end
  else
    obj := TTokenAttrib.create;
  obj.name := name;
  obj.secret := secret;
  obj.group := group;
  obj.ipOrigin := Context.Request.ClientIp;
  LTokenUsers.AddOrSetValue(token, obj);
  LTokenUsers.SaveToFile();

  r := TODataJsonPacket.New(self.Context.Request.PathInfo, true);
  r.GenValue('token', token);
  Render(r.AsJsonObject);

end;

procedure TODataUsers.DeleteUser(const token: string);
var
  r: IODataJsonPacket;
  key: string;
begin
  LTokenUsers.Remove(token);
  r := TODataJsonPacket.New(self.Context.Request.PathInfo, true);
  r.GenValue('token', token);
  Render(r.AsJsonObject);
end;

procedure TODataUsers.ListUser;
begin
  self.ListUser('');
end;

procedure TODataUsers.ListUser(const name: String);
var
  obj: TTokenAttrib;
  r: IODataJsonPacket;
  key: string;
  arr: TJsonArray;
  j: TJsonObject;
  i: integer;
  item: TPair<string, TTokenAttrib>;
begin
  arr := TJsonArray.create;
  LTokenUsers.LockList;
  try

    r := TODataJsonPacket.New(self.Context.Request.PathInfo, true);
    for item in LTokenUsers.ToArray do
    begin
      obj := item.Value;
      if (name > '') and (obj.name.Equals(name)) then
      begin
        j := TJsonObject.create;
        j.addPair('token', item.key);
        j.addPair('name', obj.name);
        j.addPair('group', obj.group);
        arr.addElement(j);
        break;
      end
      else
      begin
        j := TJsonObject.create;
        j.addPair('token', item.key);
        j.addPair('name', obj.name);
        j.addPair('group', obj.group);
        arr.addElement(j);
      end;
    end;

    r.values(arr);
    r.Ends;

    Render(arr);
  finally
    LTokenUsers.UnlockList;
  end;
end;

procedure TODataUsers.ListUserByToken(const token: String);
var
  obj: TTokenAttrib;
  r: IODataJsonPacket;
  key: string;
  arr: TJsonArray;
  j: TJsonObject;
  i: integer;
  item: TPair<string, TTokenAttrib>;
begin
  arr := TJsonArray.create;
  LTokenUsers.LockList;
  try

    r := TODataJsonPacket.New(self.Context.Request.PathInfo, true);
    obj := LTokenUsers.Items[token];
    if assigned(obj) then
    begin
      j := TJsonObject.create;
      j.addPair('token', item.key);
      j.addPair('name', obj.name);
      j.addPair('group', obj.group);
      arr.addElement(j);
      r.values(arr);
    end;
    r.Ends;

    Render(arr);
  finally
    LTokenUsers.UnlockList;
  end;
end;

procedure TODataUsers.OnAfterAction(Context: TWebContext;
  const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TODataUsers.OnBeforeAction(Context: TWebContext;
  const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

{ TUsers }

procedure TUsers.LoadFromFile(AFile: string);
var
  str: TStringList;
begin
  if fileExists(AFile) then
    try
      str := TStringList.create;
      try
        FError := '';
        str.DefaultEncoding := TEncoding.UTF8;
        str.LoadFromFile(AFile);
        FromJson(str.text);
      finally
        str.free;
      end;
    except
      on e: Exception do
        FError := e.message;
    end;
  FFileName := AFile;
end;

procedure TUsers.SaveToFile(AFile: String = '');
var
  str: TStringList;
begin
  try
    if AFile = '' then
      AFile := FFileName;
    if AFile = '' then
      AFile := TokenUserFileName;
    FError := '';
    str := TStringList.create;
    try
      str.DefaultEncoding := TEncoding.UTF8;
      str.text := toJson;
      str.SaveToFile(AFile);
    finally
      str.free;
    end;
  except
    on e: Exception do
      FError := e.message;
  end;
end;

{ TTokenAttrib }

constructor TTokenAttrib.Create;
begin
   inherited Create;
end;

initialization

LTokenUsers := TUsers.create([doOwnsValues]);
try
  LTokenUsers.LoadFromFile(ExtractFilePath(paramStr(0)) + TokenUserFileName);
except
end;
RegisterWSController(TODataUsers);

finalization

LTokenUsers.free;

end.
