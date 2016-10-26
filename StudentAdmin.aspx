<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StudentAdmin.aspx.cs" Inherits="HCA.HCAApp.StudentAdmin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="js/datatables.min.js"></script>
    <link href="css/datatables.min.css" type="text/css" rel="stylesheet"  />

    <script type="text/javascript" charset="utf-8">
    //Globals
    var student = null;
    var purchases = null;
    var purchasesTable = null;
        
    $(function () {
        loadStudent();
    });

    function loadStudent() {
        debugger;
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "StudentAdminPageWS.asmx/GetStudentData",
            data: '{ id: ' + <%=Request.QueryString["id"]%> + '}',
            dataType: "json",
            success: function (response) {
                debugger;
                student = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                //display data
                $("#tdStudentName").html(student.Name);
                $("#tdClassName").html(student.ClassName);
                $("#tdBalance").html(FormatMoneyStr(student.Balance));
                loadPurchases();
            }
        });

    }
    
    function loadPurchases() {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "StudentAdminPageWS.asmx/GetStudentPurchases",
            data: '{ id: ' + <%=Request.QueryString["id"]%> + '}',
            dataType: "json",
            success: function (response) {
                debugger;
                purchases = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                initPurchasesTable();
            }
        });            
    }
    
    function initPurchasesTable() {
       if (purchasesTable== null) {
                purchasesTable= $('#purchasesTable').dataTable({
                    "bStateSave": true,
                    "bProcessing": true,
                    "bPaginate": false,
                    "aaData": purchases,
                    "aoColumns": [
                        { "sTitle": "Id", "mDataProp": "Id" },
                        {  "sTitle": "Meal","mDataProp": "MealDescription"},
                        { "sTitle": "Date", "mDataProp": "PurchaseDate" },
                        {
                            "sTitle": "Price",
                            "mDataProp": "PurchasePrice", 
                            "mRender": function ( data, type, row ) {
                                return FormatMoneyStr(data);
                            }
                        }
                    ]
                });
            } else {
                purchasesTable.fnClearTable();
                purchasesTable.fnAddData(purchases);
            } 
    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="col-lg-12"><h1 class="page-header" id="tdStudentName"></h1></div>
    <div class="col-lg-6"><h3 id="tdClassName"></h3></div>  
    <div class="col-lg-6">
        <h3>
            Balance: <span id="tdBalance"></span>
            <button type="button" class="btn btn-primary">add money</button>
            <button type="button" class="btn btn-primary">print receipt</button>
            <button type="button" class="btn btn-primary">print balance</button>
        </h3>
    </div>  
    
    <!--DataTable-->
    <div class="col-lg-12">
        <h1 class="page-header">Purchases</h1>
        <table id="purchasesTable" class="display"  width="100%">
        <thead>
		    <tr>
			    <th >Id</th>
			    <th >Meal</th>
                <th >Date</th>
                <th >Price</th>
		    </tr>
	    </thead>
	    <tbody>
	    </tbody>
        </table>
    </div>
    
    
    	
    <script type="text/javascript">
        // For demo to fit into DataTables site builder...
        $('#purchasesTable')
        .removeClass('display')
        .addClass('table table-striped table-bordered');
    </script>
</asp:Content>
