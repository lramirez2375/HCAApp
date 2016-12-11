<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageStudent.aspx.cs" Inherits="HCA.HCAApp.ManageStudent" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%--datatables--%>
    <script src="js/datatables.min.js"></script>
    <link href="css/datatables.min.css" type="text/css" rel="stylesheet"  />

    <%--datepicker--%>
    <link href="css/daterangepicker.css" rel="stylesheet"/>
    <script src="js/daterangepicker.js"></script>
    

    <script type="text/javascript" charset="utf-8">

        //Globals
        var students = null;
        var studentsTable = null;
        var selectedStudentId = 0;
        var selectedStudent = null;

        $(function () {
            loadStudents();
            loadStudentClasses();
            //dates
            $('input[name = "txtRptFrom"]').daterangepicker({
                singleDatePicker: true,
                showDropdowns: true
            });

            $('input[name = "txtRptTo"]').daterangepicker({
                singleDatePicker: true,
                showDropdowns: true
            });
            
            $("#view-balances-rpt")
                .button()
                .click(function () {
                    window.open("reports/RVBalancesReport.aspx", "_blank");
                    return false;
                });
            $("#view-purchases-rpt")
                .button()
                .click(function () {
                    var fromDate = $("#txtRptFrom").val();
                    var toDate = $("#txtRptTo").val();
                    window.open("reports/RVPurchasesReport.aspx?from=" + fromDate + "&to=" + toDate, "_blank");
                    return false;
                });
            $("#add-new-student")
                .button()
                .click(function () {
                    debugger;
                    editStudent(0);
                    return false;
                });
            //dialog related
            $('body').on('show.bs.modal', function () {
                $('#addStudent .modal-body').css('overflow-y', 'auto');

                $('#addStudent .modal-body').css('max-height', $(window).height() * 0.7);

            });
        });

        function loadStudents() {
            debugger;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AdminPageWS.asmx/GetAllStudents",
                dataType: "json",
                success: function (response) {
                    debugger;
                    students = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                    initTable();

                }
            });

        }

        function initTable() {
            if (studentsTable == null) {
                studentsTable = $('#studentsTable').dataTable({
                    "bStateSave": true,
                    "bProcessing": true,
                    "bPaginate": false,
                    "aaData": students,
                    "aoColumns": [
                        { "sTitle": "LCPS Id", "mDataProp": "LCPS_Id" },
                        { "sTitle": "Name",
                            "mDataProp": "Name",
                            "mRender": function (data, type, row) {
                                return "<a href='StudentAdmin.aspx?id=" + row.Id + "'>" + data + "</a>";
                            }
                        },
                        { "sTitle": "Class", "mDataProp": "ClassName" },
                        {
                            "sTitle": "Balance",
                            "mDataProp": "Balance",
                            "mRender": function (data, type, row) {
                                return FormatMoneyStr(data);
                            }
                        },
                        {
                            "sTitle": "",
                            "mDataProp": null,
                            "mRender": function (data, type, row) {
                                return "<a href='javascript:editStudent(" + row.Id + ");'>edit</a>";
                            }
                        }
                    ]
                });
            } else {
                studentsTable.fnClearTable();
                studentsTable.fnAddData(students);
            }
        }

        function editStudent(studentId) {
            debugger;
            selectedStudentId = studentId;
            selectedStudent = null;
            if (studentId == 0) {
                $("#txtStudentId").val("");
                $("#txtStudentName").val("");
                $("#txtParentName").val("");
                $("#txtParentEmail").val("");

            } else {
                $.each(students, function (idx, obj) {
                    if (studentId == obj.Id) {
                        selectedStudent = obj;
                    }
                });
                $("#txtStudentId").val(selectedStudent.LCPS_Id);
                $("#txtStudentName").val(selectedStudent.Name);
                $("#txtParentName").val(selectedStudent.Parent);
                $("#txtParentEmail").val(selectedStudent.Email);
                $("#selectStudentClasses").val(selectedStudent.ClassId);
            }
            $("#addStudent").modal("show");
        }

        
        function loadStudentClasses() {
            debugger;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StudentPageWS.asmx/GetAllStudentClasses",
                dataType: "json",
                success: function (response) {
                    debugger;
                    var studentClasses = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                    displaySingleCombos('', 'selectStudentClasses', studentClasses, false, "Class");

                }
            });

        }
        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Modal -->
  <div class="modal fade" id="addStudent" role="dialog" tabindex="-1" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">Add or edit a student</h4>
        </div>
        <div class="modal-body">
           <table>
           <thead>
           </thead>
           <tbody class="table">
           <tr>
              <td>LCPS Student Id</td>
              <td><input type="text" name="txtStudentId" id="txtStudentId" /></td>
           </tr>
           <tr>
              <td>Student Name</td>
              <td><input type="text" name="txtStudentName" id="txtStudentName" /></td>
           </tr>
           <tr>
              <td>Parent Name</td>
              <td><input type="text" name="txtParentName" id="txtParentName" /></td>
           </tr>
           <tr>
              <td>Contact email</td>
              <td><input type="text" name="txtParentEmail" id="txtParentEmail" /></td>
           </tr>
           <tr>
              <td>Class</td>
              <td><select id="selectStudentClasses" class="selectpicker" data-size="8"></select></td>
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
    <%--End modal--%>
    <div class="col-lg-12"><h1 class="page-header">All Students</h1></div>
        
    <div class="col-lg-2"><button type="button" id="view-balances-rpt" class="btn btn-primary">Print all balances</button></div>
    <div class="col-lg-8">
        <input type="text" name="txtRptFrom" id="txtRptFrom" value="<%=DateTime.Now.AddMonths(-1)%>" /><br/>
        to<br/>
        <input type="text" name="txtRptTo" id="txtRptTo" value="<%=DateTime.Now%>" /><br/>
        <button type="button" id="view-purchases-rpt" class="btn btn-primary">Print totals by item</button>
    </div>
    
    <div class="col-lg-2">
        <%--<button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#addStudent">Add new student</button>--%>
        <button type="button" class="btn btn-info btn-lg" id="add-new-student">Add new student</button>
    </div>
    <div class="col-lg-12"><br></div>
            
    <div class="col-lg-12">
        <table id="studentsTable" class="display"  width="100%">
        <thead>
		    <tr>
			    <th >Id</th>
			    <th >Name</th>
                <th >Class</th>
                <th >Balance</th>
                <th >Free/Reduced</th>
		    </tr>
	    </thead>
	    <tbody>
	    </tbody>
        </table>
    </div>
     
    <script type="text/javascript">
        // For demo to fit into DataTables site builder...
        $('#studentsTable')
            .removeClass('display')
            .addClass('table table-striped table-bordered');
        //dialog events
        $("#addStudent").on('hide.bs.modal', function () {
            var LCPSId = $("#txtStudentId").val();
            var studentName = $("#txtStudentName").val();
            var parent = $("#txtParentName").val();
            var email = $("#txtParentEmail").val();
            var classId = $("#selectStudentClasses option:selected").val();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AdminPageWS.asmx/SaveStudent",
                data: "{" +
                        "id:" + selectedStudentId + "," +
                        "lcpsid:'" + LCPSId + "'," +
                        "studentName:'" + studentName + "'," +
                        "parent:'" + parent + "'," +
                        "email:'" + email + "'," +
                        "classId:" + classId +
                      "}",
                dataType: "json",
                success: function (response) {
                    students = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                    initTable();
                }
            });
        });
        
    </script>
</asp:Content>
