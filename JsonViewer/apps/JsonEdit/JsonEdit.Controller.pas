{ //************************************************************// }
{ //                                                            // }
{ //         C�digo gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/05/2017 14:20:45                                  // }
{ //************************************************************// }
/// <summary>
/// O controller possui as seguintes caracter�sticas:
/// - pode possuir 1 view associado  (GetView)
/// - pode receber 0 ou mais Model   (GetModel<Ixxx>)
/// - se auto registra no application controller
/// - pode localizar controller externos e instanci�-los
/// (resolveController<I..>)
/// </summary>
unit JsonEdit.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, JsonEdit.Controller.Interf,
  JsonEditView;

type
  TJsonEditController = class(TControllerFactory, IJsonEditController,
    IThisAs<TJsonEditController>)
  protected
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); override;
  public
    // inicializar os m�dulos personalizados em CreateModules
    Procedure CreateModules; virtual;
    Constructor Create; override;
    Destructor Destroy; override;
    /// New Cria nova inst�ncia para o Controller
    class function New(): IController; overload;
    class function New(const AView: IView; const AModel: IModel)
      : IController; overload;
    class function New(const AModel: IModel): IController; overload;
    function ThisAs: TJsonEditController;
    /// Init ap�s criado a inst�ncia � chamado para concluir init
    procedure init; override;
  end;

implementation

/// Creator para a classe Controller
Constructor TJsonEditController.Create;
begin
  inherited;
  /// Inicializar as Views...
  View(TJsonEditView.New(self));
  /// Inicializar os modulos
  CreateModules; // < criar os modulos persolnizados
end;

/// Finaliza o controller
Destructor TJsonEditController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TJsonEditController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TJsonEditController.New(const AView: IView; const AModel: IModel)
  : IController;
var
  vm: IViewModel;
begin
  result := TJsonEditController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TJsonEditController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TJsonEditController.ThisAs: TJsonEditController;
begin
  result := self;
end;

/// Executar algum comando customizavel
Procedure TJsonEditController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TJsonEditController.init;
var
  ref: TJsonEditView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TJsonEditView, ref);
    supports(ref, IView, FView);
{$IFDEF FMX}
    if Application.MainForm = nil then
      Application.RealCreateForms;
{$ENDIF}
  end;
  AfterInit;
end;

/// Adicionar os modulos e MODELs personalizados
Procedure TJsonEditController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

/// Inicializa��o automatica do Controller ao iniciar o APP
// TJsonEditController.New(TJsonEditView.New,TJsonEditViewModel.New)).init();
/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TJsonEditController.ClassName, IJsonEditController,
  TJsonEditController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TJsonEditController.ClassName);

end.
