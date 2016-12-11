<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MenuAdmin.aspx.cs" Inherits="HCA.HCAApp.MenuAdmin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%--datatables--%>
    <script src="js/datatables.min.js"></script>
    <link href="css/datatables.min.css" type="text/css" rel="stylesheet"  />

    <%--daterangepicker--%>
    <link href="css/daterangepicker.css" rel="stylesheet"/>
    <script src="js/daterangepicker.js"></script>
    <%--datepicker--%>
    <link href="css/datepicker.css" rel="stylesheet"/>
    <script src="js/bootstrap-datepicker.js"></script>

    <script type="text/javascript" charset="utf-8">

        //Globals
        var menu = [];
        var mealSetup = new Object();
        var groups = null;

        $(function () {
            loadMealGroups();
            //dates
            $('input[name="selectMenuDates"]').daterangepicker();
            //
            $("#selectMenuMealGroup").change(function () {
                changeMealSelection($("#selectMenuMealGroup option:selected").val());
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

            //preview menu
                $("#txtPreviewMenuDate").datepicker({
                    todayHighlight: true
                })
                .on('changeDate', function (ev) {
                    previewMenuPerDate();
                    return false;
                });
            

            

        });

        function submitMeal() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AdminPageWS.asmx/SaveMeal",
                data: "{menus:" + JSON.stringify(menu) + "}",
                dataType: "json",
                success: function (response) {
                    debugger;
                    $("#tdMenuResult").html("");
                    menu = [];
                }
            });
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
                    groups = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                    displayMultiselectCombos(null, 'selectMenuMealGroup', groups, false, 'MealGroupDescription');
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

        function displayMenu() {
            var menuText = "";
            $.each(menu, function (idx, m) {
                menuText += "Dates:" + m.Dates + "   Meal:" + m.Meal + "<br/>";
            });
            $("#tdMenuResult").html(menuText);
        }

        //Preview Menu
        function previewMealGroups(id, groupName, previewDate) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StudentPageWS.asmx/GetAllMealsByGroupByDate",
                data: '{ groupId: ' + id + ',date:"' + previewDate + '"}',
                dataType: "json",
                success: function (response) {
                    debugger;
                    var previewMeals = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                    displayMeals(previewMeals, groupName, previewDate);
                }
            });
        }

        function displayMeals(meals, groupName, previewDate) {
            debugger;
            var strOut = "<div class='col-lg-12'><h2>" + groupName + "</h2></div>";
            var count = 3;
            $.each(meals, function (idx, m) {
                debugger;
                if (count % 3 == 0) strOut += "<div class='row'>";
                strOut += "<div class='col-lg-4 col-sm-6 text-center'>";
                strOut += "<img class='img-circle img-responsive img-center' src='" + m.Image + "' alt=''>";
                strOut += "<h3>" + m.MealDescription + "</h3>";
                strOut += "<br/>";
                strOut += "<a onclick='javascript:deleteMealFromMenu(" + m.Id + ",\"" + previewDate + "\");'>remove</a>";
                strOut += "</div>";
                if (count % 3 == 2) strOut += "</div>";
                count++;
            });
            //
            var strFinal = $("#MealsContainer").html();
            strFinal += "<br/><br/>";
            $("#MealsContainer").html(strFinal + strOut);
        }

        function deleteMealFromMenu(id, previewDate) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AdminPageWS.asmx/DeleteMealFromMenu",
                data: '{ mealId: ' + id + ',date:"' + previewDate + '"}',
                dataType: "json",
                success: function (response) {
                    debugger;
                    previewMenuPerDate();
                }
            });
        }

        function previewMenuPerDate() {
            $("#MealsContainer").html("");
            var previewDate = $("#txtPreviewMenuDate").data('date');
            $.each(groups, function (idx, g) {
                debugger;
                previewMealGroups(g.Id, g.MealGroupDescription, previewDate);
            });
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
     <%--Menu planner --%>
     <div class="col-lg-12"><br></div>
     <div class="col-lg-12"><h1 class="page-header">Plan your monthly menu</h1></div>
     <div class="col-lg-3">
         <p>Select meal time</p>
         <select id="selectMenuMealGroup" ></select><br/><br/>
         <select id="selectMenuMeal" ><option>select a meal</option></select><br/>
     </div>
     <div class="col-lg-3">
         <input type="text" name="selectMenuDates" value="<%=DateTime.Now%> - <%=DateTime.Now.AddMonths(2)%>" />
     </div>
      <div class="col-lg-1">
         <button id="select-meal" type="button" class="btn btn-primary">select</button>

     </div>    
     <div class="col-lg-5" style="float:right;border:black;border-style:solid;border-width:1px;padding: 3px;">
         <div class="col-lg-12" id="tdMenuResult" style="float:right;">
             No meals selected
         </div> 
         <div class="col-lg-12" style="float:right;">
            <button id="submit-meal" type="button" class="btn btn-primary">submit</button>
         </div>
     </div>
     <div class="col-lg-12"><br></div>
    
    <%--Menu preview--%>
    <div class="col-lg-12"><h1 class="page-header">Preview Menu</h1></div>
    <div class="col-lg-12">
        <div id="txtPreviewMenuDate" data-date-format="m/d/yyyy"></div>
    </div>
    
       
    <div class="container" id="MealsContainer" ></div>
       
    
</asp:Content>

