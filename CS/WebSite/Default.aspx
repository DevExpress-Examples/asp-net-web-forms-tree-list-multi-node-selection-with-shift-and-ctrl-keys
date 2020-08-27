<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v17.2, Version=17.2.15.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.15.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<title>Multi-node selection with Shift and Ctrl keys</title>

<script type="text/javascript">
var __dxLastSelectedKey = null;
function tree_NodeClick(s, e) {
	var isShift = e.htmlEvent.shiftKey;
	var isCtrl = e.htmlEvent.ctrlKey;
	if(!isShift && !isCtrl) {
		var keys = s.GetVisibleNodeKeys();
		for(var i = 0; i < keys.length; i++)
			s.SelectNode(keys[i], false);
	}	
	if(isShift && __dxLastSelectedKey != null) {
		var row1 = s.GetNodeHtmlElement(__dxLastSelectedKey);
		var row2 = s.GetNodeHtmlElement(e.nodeKey);
		var index1 = row1.rowIndex;
		var index2 = row2.rowIndex;
		if(index1 > index2) {
			var temp = index1; 
			index1 = index2; index2 = temp;
		}
		var table = row1.parentNode.parentNode;
		for(var i = index1; i <= index2; i++) {
			var key = s.GetNodeKeyByRow(table.rows[i]);
			if(key != null)
				s.SelectNode(key, true);
		}		
	} else {		
		s.SelectNode(e.nodeKey, !isCtrl || !s.IsNodeSelected(e.nodeKey));
	}
	__dxLastSelectedKey = e.nodeKey;
	if(isShift || isCtrl) 
		ASPxClientUtils.ClearSelection();
}
</script>
</head>

<body>
    <form id="form1" runat="server">
		<dx:ASPxTreeList runat="server" ID="tree" ClientInstanceName="tree" AutoGenerateColumns="False" DataSourceID="AccessDataSource1" KeyFieldName="ID" ParentFieldName="ParentID">
			<SettingsBehavior AutoExpandAllNodes="True" />
			<SettingsSelection Enabled="True" />
			<Columns>
				<dx:TreeListDataColumn FieldName="Subject" VisibleIndex="0" />				
				<dx:TreeListDataColumn FieldName="From" VisibleIndex="1" />				
				<dx:TreeListDataColumn FieldName="Date" VisibleIndex="2" />				
			</Columns>
			<ClientSideEvents NodeClick="tree_NodeClick" />			
		</dx:ASPxTreeList>
		<asp:AccessDataSource ID="AccessDataSource1" runat="server" DataFile="~/App_Data/NewsGroups.mdb"
			SelectCommand="SELECT [ID], [ParentID], [Subject], [From], [Date] FROM [Threads]">
		</asp:AccessDataSource>
    </form>
</body>
</html>
