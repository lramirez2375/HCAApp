<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminPage.aspx.cs" Inherits="HCA.HCAApp.AdminPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%--datatables--%>
    <script src="js/datatables.min.js"></script>
    <link href="css/datatables.min.css" type="text/css" rel="stylesheet"  />

    <%--datepicker--%>
    <link href="css/daterangepicker.css" rel="stylesheet"/>
    <script src="js/daterangepicker.js"></script>
    

    <script type="text/javascript" charset="utf-8">

        //Globals
        var meals = null;
        var selAdminMeals = null;
        var students = null;
        var studentsTable = null;
        var menu = [];
        var mealSetup = new Object();

        $(function () {
            loadStudents();
            loadMealGroups();
            $('input[name="selectMenuDates"]').daterangepicker();
            $("#selectMenuMealGroup").change(function () {
                changeMealSelection($("#selectMenuMealGroup option:selected").val());
            });
            $("#selectAdminMealGroup").change(function () {
                changeAdminMealSelection($("#selectAdminMealGroup option:selected").val());
            });
            $("#selectAdminMeal").change(function () {
                debugger;
                var selMeailId = $("#selectAdminMeal").val();
                var selMeal = null;
                $.each(selAdminMeals, function (idx, m) {
                    if (selMeailId == m.Id) {
                        selMeal = m;
                    }
                });
                $("#txtSelectedAdminMeal").val(selMeal.MealDescription);
                $("#txtSelectedAdminMealPrice").val(selMeal.Price);
                $("#txtSelectedAdminMealImage").val(selMeal.Image);
            });
            $("#select-meal")
                .button()
                .click(function () {
                    mealSetup = {
                        Dates: $('input[name="selectMenuDates"]').val(),
                        Mealid: $("#selectMenuMeal option:selected").val(),
                        Meal: $("#selectMenuMeal option:selected").text()
                    };
                    menu.push(mealSetup);
                    displayMenu();
                    return false;
                });
            $("#submit-meal")
                .button()
                .click(function () {
                    debugger;
                    submitMeal();
                    return false;
                });
        });

        function submitMeal() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AdminPageWS.asmx/SaveMeal",
                data: "{menus:" + JSON.stringify(menu) +  "}",
                dataType: "json",
                success: function (response) {
                    debugger;
                    $("#tdMenuResult").html("");

                }
            });
        }
        
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
            if (studentsTable== null) {
                studentsTable = $('#studentsTable').dataTable({
                    "bStateSave": true,
                    "bProcessing": true,
                    "bPaginate": false,
                    "aaData": students,
                    "aoColumns": [
                        { "sTitle": "Id", "mDataProp": "Id" },
                        {  "sTitle": "Name",
                            "mDataProp": "Name",
                            "mRender": function ( data, type, row ) {
                                return "<a href='StudentAdmin.aspx?id=" + row.Id + "'>" + data + "</a>";
                            }
                        },
                        { "sTitle": "Class", "mDataProp": "ClassName" },
                        {
                            "sTitle": "Balance",
                            "mDataProp": "Balance", 
                            "mRender": function ( data, type, row ) {
                                return FormatMoneyStr(data);
                            }
                        },
                        { "sTitle": "Free/Reduced", "mDataProp": "FreeReduced" }
                    ]
                });
            } else {
                studentsTable.fnClearTable();
                studentsTable.fnAddData(students);
            }
        }

        function loadMealGroups() {
            debugger;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StudentPageWS.asmx/GetAllMealGroups",
                dataType: "json",
                success: function (response) {
                    debugger;
                    var groups = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                    displayMultiselectCombos(null, 'selectMenuMealGroup', groups, false, 'MealGroupDescription');
                    displayMultiselectCombos(null, 'selectAdminMealGroup', groups, false, 'MealGroupDescription'); 
                }
            });

        }

        function changeMealSelection(id) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AdminPageWS.asmx/GetAllMealsByGroup",
                data: '{ groupId: ' + id + '}',
                dataType: "json",
                success: function (response) {
                    debugger;
                    meals = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                    displayMultiselectCombos('', 'selectMenuMeal', meals, false, 'MealDescription');
                }
            });
        }

        function changeAdminMealSelection(id) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AdminPageWS.asmx/GetAllMealsByGroup",
                data: '{ groupId: ' + id + '}',
                dataType: "json",
                success: function (response) {
                    debugger;
                    selAdminMeals = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                    displayMultiselectCombos('', 'selectAdminMeal', selAdminMeals, false, 'MealDescription');
                }
            });
        } 

        function displayMenu() {
            var menuText = "";
            $.each(menu, function (idx, m) {
                menuText += "Dates:" + m.Dates + "   Meal:" + m.Meal + "<br/>";
            });
            $("#tdMenuResult").html(menuText);
        }
        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="col-lg-12"><h1 class="page-header">All Students</h1></div>
        
    <div class="col-lg-3"><button type="button" class="btn btn-primary">Print all balances</button></div>
    <div class="col-lg-3"><a><button type="button" class="btn btn-primary">Print totals by item</button></a></div>
    <div class="col-lg-3"></div>
    <div class="col-lg-3"></div>
     
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
     <div class="col-lg-12"><br></div>
     <%--Meal manager--%>
     <div class="col-lg-12"><h1 class="page-header">Manage your meals</h1></div>
     <div class="col-lg-3"><p>Select meal time</p><select id="selectAdminMealGroup" ></select><br/></div>
     <div class="col-lg-3"><p>Select meal to edit</p><select id="selectAdminMeal" ><option>select a meal</option></select></div>
     <div class="col-lg-12"><h3 class="page-header">Edit or add new meal</h3></div>
     <div class="col-lg-3">
         Description:<input type="text" id="txtSelectedAdminMeal" />
     </div>
     <div class="col-lg-3">
         Price:<input type="text" id="txtSelectedAdminMealPrice" />
     </div>
     <div class="col-lg-3">
         Price:<input type="text" id="txtSelectedAdminMealImage" />
     </div>
     <div class="col-lg-3">
         <button id="save-edit-meal" type="button" class="btn btn-primary">save</button>&nbsp;&nbsp;<button id="add-new-meal" type="button" class="btn btn-primary">add new</button>
     </div>
     
     <%--Menu planner --%>
     <div class="col-lg-12"><br></div>
     <div class="col-lg-12"><h1 class="page-header">Plan your monthly menu</h1></div>
     <div class="col-lg-3">
         <p>Select meal time</p>
         <select id="selectMenuMealGroup" ></select><br/><br/>
         <select id="selectMenuMeal" multiple="multiple" ><option>select a meal</option></select><br/>
     </div>
     <div class="col-lg-3">
         <input type="text" name="selectMenuDates" value="<%=DateTime.Now%> - <%=DateTime.Now.AddMonths(2)%>" />
     </div>
      <div class="col-lg-1">
         <button id="select-meal" type="button" class="btn btn-primary">select</button>

     </div>    
     <div class="col-lg-5" id="tdMenuResult">
     </div> 
     <div class="col-lg-11" ></div>
     <div class="col-lg-1" >
        <button id="submit-meal" type="button" class="btn btn-primary">submit</button>
     </div>
     <div class="col-lg-12"><br></div>
       
    <script type="text/javascript">
        // For demo to fit into DataTables site builder...
        $('#studentsTable')
            .removeClass('display')
            .addClass('table table-striped table-bordered');
    </script>
</asp:Content>
