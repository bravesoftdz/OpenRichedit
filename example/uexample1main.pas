unit uexample1main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  RichEdit, DOM, SAX_HTML, DOM_HTML;

type
  TForm1 = class(TForm)
    TreeView1: TTreeView;
    procedure FormCreate(Sender: TObject);
  private
    procedure XML2Tree(tree: TTreeView; XMLDoc: TXMLDocument);
    { private declarations }
  public
    { public declarations }
    RE : TRichEdit;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  DN: TDOMText;
  Root: TDOMElement;
  doc: THTMLDocument;
begin
  RE := TRichEdit.Create(Self);
  RE.Parent:=Self;
  RE.Align := alClient;

  ReadHTMLFile(doc,'..\..\test1.html');
  XML2Tree(TreeView1,doc);
  RE.Document.ReadFromDOM(doc);

end;

procedure TForm1.XML2Tree(tree: TTreeView; XMLDoc: TXMLDocument);
var
  iNode: TDOMNode;

  procedure ProcessNode(Node: TDOMNode; TreeNode: TTreeNode);
  var
    cNode: TDOMNode;
    s: string;
  begin
    if Node = nil then Exit; // Stops if reached a leaf

    // Adds a node to the tree
    if Node.HasAttributes and (Node.Attributes.Length>0) then
      s := Node.NodeName+'('+Node.Attributes[0].NodeName+'='+Node.Attributes[0].NodeValue+')'
    else
      s := Node.NodeName;
    if Node.NodeValue<>'' then
      s := s+'='+Node.NodeValue;
    TreeNode := tree.Items.AddChild(TreeNode, s);

    // Goes to the child node
    cNode := Node.FirstChild;

    // Processes all child nodes
    while cNode <> nil do
    begin
      ProcessNode(cNode, TreeNode);
      cNode := cNode.NextSibling;
    end;
  end;

begin
  iNode := XMLDoc.DocumentElement.FirstChild;
  while iNode <> nil do
  begin
    ProcessNode(iNode, nil); // Recursive
    iNode := iNode.NextSibling;
  end;
end;

end.

