<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StudentAdmin.aspx.cs" Inherits="HCA.HCAApp.StudentAdmin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="js/datatables.min.js"></script>
    <link href="css/datatables.min.css" type="text/css" rel="stylesheet"  />

    <script type="text/javascript" charset="utf-8">
    //Globals
    var student = null;
    var purchases = null;
    var purchasesTable = null;
    var transfers = null;
    var transfersTable = null;
    var selTransfer = null;
    var selTransferId = 0;
        
    $(function () {
        loadStudent();
        //bind buttons
        $("#print-report")
            .button()
            .click(function() {
                window.open("Reports/RVStudentDetailReport.aspx?id=" + <%=Context.Request.QueryString["id"]%>, "_blank");
            });
        $("#add-money")
            .button()
            .click(function() {
                $("#txtCheckNumber").val("");
                $("#txtCheckAmount").val("");
                $("#addCheck").modal("show");
                selTransferId = 0;
                return false;
            });
        $("#edit-parent")
            .button()
            .click(function() {
                $("#txtParentName").val(student.Parent);
                $("#txtParentEmail").val(student.Email);
                $("#editParent").modal("show");
                return false;
            });
        
        //
        //dialog related
        $('body').on('show.bs.modal', function () {
            $('#addCheck .modal-body').css('overflow-y', 'auto');
            $('#addCheck .modal-body').css('max-height', $(window).height() * 0.7);
        });
        //
        $('body').on('show.bs.modal', function () {
            $('#editParent .modal-body').css('overflow-y', 'auto');
            $('#editParent .modal-body').css('max-height', $(window).height() * 0.7);
        });
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
                $("#tdStudentName").html(student.Name + "(" + student.LCPS_Id + ")");
                $("#tdClassName").html(student.ClassName);
                $("#tdParentName").html(student.Parent);
                $("#tdContactEmail").html(student.Email);
                $("#tdBalance").html(FormatMoneyStr(student.Balance));
                loadPurchases();
                loadMoneyTransfers();
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
    
    function loadMoneyTransfers() {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "StudentAdminPageWS.asmx/GetStudentMoneyTransfers",
            data: '{ id: ' + <%=Request.QueryString["id"]%> + '}',
            dataType: "json",
            success: function (response) {
                debugger;
                transfers = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                initTransfersTable();
            }
        });            
    }
    
    function initTransfersTable() {
       if (transfersTable== null) {
                transfersTable= $('#transfersTable').dataTable({
                    "bStateSave": true,
                    "bProcessing": true,
                    "bPaginate": false,
                    "aaData": transfers,
                    "aoColumns": [
                        { "sTitle": "Id", "mDataProp": "Id" },
                        { "sTitle": "Date", "mDataProp": "DateEntered" },
                        {
                            "sTitle": "Amount",
                            "mDataProp": "Amount", 
                            "mRender": function ( data, type, row ) {
                                return FormatMoneyStr(data);
                            }
                        },
                        {
                            "sTitle": "",
                            "mDataProp": null, 
                            "mRender": function ( data, type, row ) {
                                var sRet="<a href='javascript:editTransfer(" + row.Id + ");'>edit</a>";
                                sRet += "&nbsp;&nbsp;";
                                sRet +="<a href='javascript:deleteTransfer(" + row.Id + ");'>delete</a>";
                                return sRet;
                            }
                        }
                    ]
                });
            } else {
                transfersTable.fnClearTable();
                transfersTable.fnAddData(transfers);
            } 
    }
    
    function selectTransfer(id) {
        $.each(transfers, function (idx, obj) {
            if (id == obj.Id) {
                selTransfer = obj;
                selTransferId = obj.Id;
            }
        });
    }
    
    function editTransfer(id) {
        selectTransfer(id);
        $("#txtCheckNumber").val(selTransfer.CheckNumber);
        $("#txtCheckAmount").val(selTransfer.Amount);
        $("#addCheck").modal("show");
    }
    
    function deleteTransfer(id) {
        selectTransfer(id);
        if (confirm('Are you absolutely sure you want to delete this transfer?')) {
             $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StudentAdminPageWS.asmx/DeleteCheckFromStudent",
                data: "{id:" + <%=Request.QueryString["id"]%> + ",transferId:" + selTransfer.Id + "}",
                dataType: "json",
                success: function (response) {
                    transfers = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                    initTransfersTable();
                }
            });
        }
    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <!-- add check modal dialog -->
  <div class="modal fade" id="addCheck" role="dialog" tabindex="-1" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">Add money by Check</h4>
        </div>
        <div class="modal-body">
           <table>
           <thead>
           </thead>
           <tbody class="table">
           <tr>
              <td>Check No</td>
              <td><input type="text" name="txtCheckNumber" id="txtCheckNumber" /></td>
           </tr>
           <tr>
              <td>Amount</td>
              <td><input type="text" name="txtCheckAmount" id="txtCheckAmount" /></td>
           </tr>
           </tbody>
           </table>
           
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-tertiary" data-dismiss="modal">Save</button>
        </div>
      </div>
      
    </div>
    </div>  
    <%--End add check modal--%>
  <!-- edit parent / email modal dialog -->
  <div class="modal fade" id="editParent" role="dialog" tabindex="-1" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">Edit student contact info</h4>
        </div>
        <div class="modal-body">
           <table>
           <thead>
           </thead>
           <tbody class="table">
           <tr>
              <td>Parent name</td>
              <td><input type="text" name="txtParentName" id="txtParentName" /></td>
           </tr>
           <tr>
              <td>Email</td>
              <td><input type="text" name="txtParentEmail" id="txtParentEmail" /></td>
           </tr>
           </tbody>
           </table>
           
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-tertiary" data-dismiss="modal">Save</button>
        </div>
      </div>
      
    </div>
    </div>  
    <%--End edit parent modal--%>
    <div class="col-lg-12"><h1 class="page-header" id="tdStudentName"></h1></div>
    <div class="col-lg-6"><h3 id="tdClassName"></h3></div>  
    <div class="col-lg-6">
        <h3>
            Balance: <span id="tdBalance"></span>
            <button type="button" class="btn btn-primary" id="print-report">print</button>
        </h3>
    </div>  
    <div class="col-lg-6"><h3 id="tdParentName"></h3></div>  
    <div class="col-lg-6"><h3 id="tdContactEmail"></h3><button type="button" id="edit-parent" class="btn btn-primary">edit</button></div>  
    
    <%--tabs--%>
    <ul class="nav nav-tabs" role="tablist">
        <li role="presentation" class="active"><a href="#purchases" aria-controls="home" role="tab" data-toggle="tab">Purchases</a></li>
        <li role="presentation"><a href="#transfers" aria-controls="profile" role="tab" data-toggle="tab">Money Transfers</a></li>
        <li role="presentation"><a href="#preorders" aria-controls="messages" role="tab" data-toggle="tab">Pre-Orders</a></li>
    </ul>
    
    <div class="tab-content">
    <%--purchases tab--%>
    <div role="tabpanel" class="tab-pane active" id="purchases">
        <!--Purchases DataTable-->
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
    </div>
    <%--transfer tab--%>
    <div role="tabpanel" class="tab-pane " id="transfers">
        <!--money transfers DataTable-->
         <div class="col-lg-12">
            <h1 class="page-header">Money Transfers <div style="float:right;"><button type="button" id="add-money" class="btn btn-primary">add money</button></div></h1>
            <table id="transfersTable" class="display"  width="100%">
            <thead>
		        <tr>
			        <th >Id</th>
                    <th >Date</th>
                    <th >Amount</th>
                    <th ></th>
		        </tr>
	        </thead>
	        <tbody>
	        </tbody>
            </table>
        </div>
    </div>
    <%--pre orders tab--%>
    <div role="tabpanel" class="tab-pane " id="preorders">
        under contruction...
    </div>
  </div>
  <%--end tabs--%>

    <script type="text/javascript">
        // For demo to fit into DataTables site builder...
        $('#purchasesTable')
        .removeClass('display')
        .addClass('table table-striped table-bordered');

        $('#transfersTable')
        .removeClass('display')
        .addClass('table table-striped table-bordered');

        //dialog events
        $("#addCheck").on('hide.bs.modal', function () {
            var checkNo= $("#txtCheckNumber").val();
            var checkAmount= $("#txtCheckAmount").val();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StudentAdminPageWS.asmx/AddEditCheckToStudent",
                data: "{" +
                        "id:" + <%=Request.QueryString["id"]%> + "," +
                        "transferId:" + selTransferId + "," +
                        "checkNo:'" + checkNo + "'," +
                        "checkAmount:" + checkAmount + 
                      "}",
                dataType: "json",
                success: function (response) {
                    transfers = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                    initTransfersTable();
                }
            });
        });
        //
         $("#editParent").on('hide.bs.modal', function () {
            var parentName= $("#txtParentName").val();
            var parentEmail= $("#txtParentEmail").val();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StudentAdminPageWS.asmx/EditParent",
                data: "{" +
                        "id:" + <%=Request.QueryString["id"]%> + "," +
                        "parentName:'" + parentName + "'," +
                        "parentEmail:'" + parentEmail + "'" +
                      "}",
                dataType: "json",
                success: function (response) {
                    loadStudent();
                }
            });
        });
    </script>
</asp:Content>
