declare const _vtela: { soap: number, codtela: number, editar: number, excluir: number, incluir: number, especiais:array };
declare const br: { t: "br" };
declare const _urlxml: string;
declare const _w: Window;
declare const _d: Document;
declare const ForupGF: {
	TransferenciaEntreContas: any
	Financeiro: any
	Movimentacao: any
	Transacao: any
	Cobranca: any
	Titulo: any
	ContaConciliacao: {
		pesquisaSacado:{}
		tabelaCobrancas:HTMLTableSectionElement
	}
};
declare const sp: '&nbsp;';
declare const sp2: '&nbsp;&nbsp;';
declare const sp4: '&nbsp;&nbsp;&nbsp;&nbsp;';
declare const tinymce:any;

declare const financeiro: {};

declare function limpaCampos(...parameters: any[]): avoid;
declare function _get(op: string | HTMLElement): HTMLElement;
declare function agora(): number;
declare function required(): void;
declare function iconeVideo(url: string): HTMLElement;
declare function comparaData(data1: any, data2: any): number;
declare function data2sys(valor: string | number, formato?: string): string | number;
declare function geraTela(op: object): HTMLElement;
declare function _new(tag: string, atributos?: object): HTMLElement;
declare function popUp(op: object): HTMLElement;
declare function remove(element: string | HTMLElement);
declare function includeOnce(...parameters: any[]);
declare function ApiConnect(codtela: number);

declare function is(a): string;
declare function isBoolean(a): Boolean;
declare function isNull(a): Boolean;
declare function isEmpty(o): Boolean;
declare function isFunction(a): Boolean;
declare function isObject(a): Boolean;
declare function isAlien(a): Boolean;
declare function isString(a): Boolean;
declare function isUndefined(a): Boolean;
declare function isSet(a): Boolean;

declare class ConexaoSOAP {
	constructor(codtela: number, servico: string)
	addParametro(id: string, value: any)
	getObjeto()
}

declare class Icone {
	constructor(...parameters: any[])
	static getIcone(icone: string | object, attrib?: object):HTMLElement
}

declare class TabPainel {
	[x: string]: HTMLElement;
	constructor(...parameters: any[])
	insereTab(conteudo:HTMLElement|Object, nome: string|HTMLElement, icone: string | object):HTMLElement
}


declare class PopUpMenu {
	constructor(...parameters: any[])
	show()
}

declare class PesquisaExt {
	recuperaPagina: any
	tela: number
	funcao: string
	tamanhoPagina: number
	modo: string
	geraTabela(itens:array,op:{})
	recordSets:array
}

declare class ApiConnect {
	constructor(codtela: number)
}

interface Window {
	financeiro: any
	ForupGF: any
}

declare class FileUpload {
	constructor(...parameters: any[])
	getFiles(): any[]
}

interface ChildNode {
	insertRowExt(index?: any): HTMLTableRowElement;
	appendChildExt(op: object | string, atrib?: object): HTMLElement | any[];
}

interface HTMLElement {
	value: any;
	show():void;
	showModal():void;
}
