unit uFormularioCRUD_Cadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.StdCtrls, SPEdit, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls,
  System.Actions, Vcl.ActnList, IWSystem;

type
  TDBGrid = class(Vcl.DBGrids.TDBGrid)
  protected
    procedure DrawCellBackground(const ARect: TRect; AColor: TColor;
      AState: TGridDrawState; ACol, ARow: Integer); override;
  end;
  TfrmCRUDCadastro = class(TForm)
    shpFundo: TShape;
    pnlFundo: TPanel;
    pnlTopo: TPanel;
    pnlSeparador: TPanel;
    imgFechar: TImage;
    pnl_Menu: TPanel;
    Panel1: TPanel;
    pnlMostrarMenu: TPanel;
    imgMenu: TImage;
    pnlSair: TPanel;
    pnlContabil: TPanel;
    imgAjuda: TImage;
    pnlAdministracao: TPanel;
    imgExcluir: TImage;
    pnlUtilitarios: TPanel;
    imgEditar: TImage;
    pnlEstoque: TPanel;
    imgDesfazer: TImage;
    pnlFinanceiro: TPanel;
    imgSalvar: TImage;
    pnlCadastros: TPanel;
    imgIncluir: TImage;
    imgTitulo: TImage;
    imgFecharMenu: TImage;
    lblTitulo: TLabel;
    lblInfo: TLabel;
    lblMenu: TLabel;
    lblPesquisa: TLabel;
    lblTexto: TLabel;
    cboPesquisa: TComboBox;
    edtTextoPesquisa: TSPEdit;
    imgPesquisa: TImage;
    pgcCRUD: TPageControl;
    tbsLista: TTabSheet;
    tbsCadastro: TTabSheet;
    grpCadastro: TGroupBox;
    grdLista: TDBGrid;
    actPadrao: TActionList;
    actSair: TAction;
    dtsMestre: TDataSource;
    actIncluir: TAction;
    actCarregarImagens: TAction;
    actEditar: TAction;
    actSalvar: TAction;
    actExcluir: TAction;
    actCancelar: TAction;
    actAnimaMenu: TAction;
    pnlNavegador: TPanel;
    imgPrimeiroRegistro: TImage;
    imgRegistroAnterior: TImage;
    imgProximoRegistro: TImage;
    imgUltimoRegistro: TImage;
    actPrimeiroRegistro: TAction;
    actRegistroAnterior: TAction;
    actProximoRegistro: TAction;
    actUltimoRegistro: TAction;
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actSairExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdListaDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure actIncluirExecute(Sender: TObject);
    procedure grdListaDblClick(Sender: TObject);
    procedure actCarregarImagensExecute(Sender: TObject);
    procedure actEditarExecute(Sender: TObject);
    procedure actSalvarExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actExcluirExecute(Sender: TObject);
    procedure actCancelarExecute(Sender: TObject);
    procedure actAnimaMenuExecute(Sender: TObject);
    procedure actPrimeiroRegistroExecute(Sender: TObject);
    procedure actRegistroAnteriorExecute(Sender: TObject);
    procedure actProximoRegistroExecute(Sender: TObject);
    procedure actUltimoRegistroExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
		iTabela:integer;
  end;

var
  frmCRUDCadastro: TfrmCRUDCadastro;

implementation

{$R *.dfm}

uses dataDBEXMaster, uMSGPadrao, uConstantes_Padrao, uFuncoes_BD, uFuncoes;

procedure TfrmCRUDCadastro.actAnimaMenuExecute(Sender: TObject);
begin

  if pnl_Menu.Width = 40 then
    pnl_Menu.Width := 233
  else
    pnl_Menu.Width := 40;

end;

procedure TfrmCRUDCadastro.actCancelarExecute(Sender: TObject);
begin

  try

    if InserindoEditando_2(dtsMestre.DataSet) then
    begin

      dtsMestre.DataSet.Cancel;
      HabilitaDesabilitaControles(grpCadastro, False);
      edtTextoPesquisa.Clear;
      edtTextoPesquisa.SetFocus;

    end;

  except
    on e: exception do
    begin

      Criar_TelaMSGPadrao(TIT_ERRO_GRAVE,
                          E.StackTrace,
                          dmDBEXMaster.sNomeUsuario + ', ' + e.message,
                          gsAppPath + ICONE_ERRO,
                          ord(btnOK));

    end;

  end;

end;

procedure TfrmCRUDCadastro.actCarregarImagensExecute(Sender: TObject);
begin

  CarregarImagem(imgTitulo,ord(btnTitulo));
  CarregarImagem(imgPesquisa,ord(btnPesquisar));
  CarregarImagem(imgFechar,ord(btnSair));
  CarregarImagem(imgMenu,ord(btnMenu));
  CarregarImagem(imgIncluir,ord(btnIncluir));
  CarregarImagem(imgSalvar,ord(btnSalvar));
  CarregarImagem(imgIncluir,ord(btnIncluir));
  CarregarImagem(imgDesfazer,ord(btnCancelar));
  CarregarImagem(imgEditar,ord(btnEditar));
  CarregarImagem(imgExcluir,ord(btnExcluir));
  CarregarImagem(imgAjuda,ord(btnAjuda));
  CarregarImagem(imgFecharMenu,ord(btnSair));

end;

procedure TfrmCRUDCadastro.actEditarExecute(Sender: TObject);
begin

  try

    if not InserindoEditando_2(dtsMestre.DataSet) then
    begin

      pgcCRUD.ActivePageIndex := 0;
      HabilitaDesabilitaControles(grpCadastro, True);
      dtsMestre.DataSet.Edit;

    end;

  except
    on e: exception do
    begin

      Criar_TelaMSGPadrao(TIT_ERRO_GRAVE,
                          E.StackTrace,
                          dmDBEXMaster.sNomeUsuario + ', ' + e.message,
                          gsAppPath + ICONE_ERRO,
                          ord(btnOK));

    end;

  end;


end;

procedure TfrmCRUDCadastro.actExcluirExecute(Sender: TObject);
begin

  try

    if not InserindoEditando_2(dtsMestre.DataSet) then
    begin

			if Criar_TelaMSGPadrao(TIT_ATENCAO,
														 TIT_MSG_CONFIRMACAO,
                          	 dmDBEXMaster.sNomeUsuario + ', ' + MSG_CONFIRMA_ACAO + '- EXCLUSÃO',
                          	 gsAppPath + ICONE_PERGUNTA,
                             ord(btnSimNao)) = mrOk then
			begin
 
        SPMANTABGENERICA_PRINCIPAL(0, iTabela, dtsMestre);
        HabilitaDesabilitaControles(grpCadastro, False);
        dtsMestre.DataSet.Delete;
        pgcCRUD.ActivePageIndex := 1;

      end;

    end;

  except
    on e: exception do
    begin

      Criar_TelaMSGPadrao(TIT_ERRO_GRAVE,
                          E.StackTrace,
                          dmDBEXMaster.sNomeUsuario + ', ' + e.message,
                          gsAppPath + ICONE_ERRO,
                          ord(btnOK));

    end;
  end;

end;

procedure TfrmCRUDCadastro.actIncluirExecute(Sender: TObject);
begin

  try

    if not InserindoEditando_2(dtsMestre.DataSet) then
    begin

      pgcCRUD.Pages[1].TabVisible   := true;
      pgcCRUD.ActivePageIndex       := 0;

      HabilitaDesabilitaControles(grpCadastro, True);
			SPMANTABGENERICA_PRINCIPAL(99, iTabela, dtsMestre);
      dtsMestre.DataSet.Append;

    end;

  except
    on e: exception do
    begin

      Criar_TelaMSGPadrao(TIT_ERRO_GRAVE,
                          E.StackTrace,
                          dmDBEXMaster.sNomeUsuario + ', ' + e.message,
                          gsAppPath + ICONE_ERRO,
                          ord(btnOK));

    end;

  end;

end;

procedure TfrmCRUDCadastro.actPrimeiroRegistroExecute(Sender: TObject);
begin

	try

	if not InserindoEditando_2(dtsMestre.DataSet) then
  	dtsMestre.DataSet.First;

  except

    on e: exception do
    begin

      Criar_TelaMSGPadrao(TIT_ERRO_GRAVE,
                          E.StackTrace,
                          dmDBEXMaster.sNomeUsuario + ', ' + e.message,
                          gsAppPath + ICONE_ERRO,
                          ord(btnOK));

    end;

  end;

end;

procedure TfrmCRUDCadastro.actProximoRegistroExecute(Sender: TObject);
begin
	try

		if not InserindoEditando_2(dtsMestre.DataSet) then
  		dtsMestre.DataSet.Next;

  except

    on e: exception do
    begin

      Criar_TelaMSGPadrao(TIT_ERRO_GRAVE,
                          E.StackTrace,
                          dmDBEXMaster.sNomeUsuario + ', ' + e.message,
                          gsAppPath + ICONE_ERRO,
                          ord(btnOK));

    end;

  end;

end;

procedure TfrmCRUDCadastro.actRegistroAnteriorExecute(Sender: TObject);
begin
	try

		if not InserindoEditando_2(dtsMestre.DataSet) then
  		dtsMestre.DataSet.Prior;

  except

    on e: exception do
    begin

      Criar_TelaMSGPadrao(TIT_ERRO_GRAVE,
                          E.StackTrace,
                          dmDBEXMaster.sNomeUsuario + ', ' + e.message,
                          gsAppPath + ICONE_ERRO,
                          ord(btnOK));

    end;

  end;

end;

procedure TfrmCRUDCadastro.actSairExecute(Sender: TObject);
begin

  Close;

end;

procedure TfrmCRUDCadastro.actSalvarExecute(Sender: TObject);
begin
  try

    if InserindoEditando_2(dtsMestre.DataSet) then
    begin

			SPMANTABGENERICA_PRINCIPAL(0, iTabela, dtsMestre);
      HabilitaDesabilitaControles(grpCadastro, False);
      edtTextoPesquisa.Clear;
      edtTextoPesquisa.SetFocus;

    end;

  except
    on e: exception do
    begin

      Criar_TelaMSGPadrao(TIT_ERRO_GRAVE,
                          E.StackTrace,
                          dmDBEXMaster.sNomeUsuario + ', ' + e.message,
                          gsAppPath + ICONE_ERRO,
                          ord(btnOK));

    end;

  end;

end;

procedure TfrmCRUDCadastro.actUltimoRegistroExecute(Sender: TObject);
begin

	try

		if not InserindoEditando_2(dtsMestre.DataSet) then
  		dtsMestre.DataSet.Last;

  except

    on e: exception do
    begin

      Criar_TelaMSGPadrao(TIT_ERRO_GRAVE,
                          E.StackTrace,
                          dmDBEXMaster.sNomeUsuario + ', ' + e.message,
                          gsAppPath + ICONE_ERRO,
                          ord(btnOK));

    end;

  end;

end;

procedure TfrmCRUDCadastro.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  sender := nil;
  sender.Free;
  sender.DisposeOf;

end;

procedure TfrmCRUDCadastro.FormCreate(Sender: TObject);
var
  i:integer;
begin

  for i := 0 to grdLista.Columns.Count - 1 do
    grdLista.Columns[i].Title.Color := COR_TITULO_GRADE;

  pgcCRUD.Pages[1].TabVisible := False;

  actAnimaMenuExecute(self);

end;

procedure TfrmCRUDCadastro.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  case key of
    VK_RETURN: Perform(WM_NEXTDLGCTL,0,0);
  end;

end;

procedure TfrmCRUDCadastro.FormResize(Sender: TObject);
begin

  Redimencionar(pnlFundo, sender);

end;

procedure TfrmCRUDCadastro.grdListaDblClick(Sender: TObject);
begin

  if not dtsMestre.DataSet.IsEmpty then
    pgcCRUD.ActivePageIndex := 0;

end;

procedure TfrmCRUDCadastro.grdListaDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

  if not dtsMestre.DataSet.IsEmpty then
  begin

    if not odd(dtsMestre.DataSet.RecNo) then
    begin

      grdLista.Canvas.Font.Color   := clBlack;
      grdLista.Canvas.Brush.Color  := COR_ZEBRA_GRADE;

    end
    else
    begin

      grdLista.Canvas.Font.Color   := clBlack;
      grdLista.Canvas.Brush.Color  := clWhite;

    end;

    grdLista.Canvas.FillRect(Rect);
    grdLista.DefaultDrawDataCell(Rect, Column.Field, State);

  end;

end;


{ TDBGrid }

procedure TDBGrid.DrawCellBackground(const ARect: TRect; AColor: TColor;
  AState: TGridDrawState; ACol, ARow: Integer);
begin
  inherited;

  if ACol < 0 then
    inherited DrawCellBackground(ARect, AColor, AState, ACol, ARow)
  else
    inherited DrawCellBackground(ARect, Columns[ACol].Title.Color, AState,
      ACol, ARow)

end;

end.
