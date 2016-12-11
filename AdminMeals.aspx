<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminMeals.aspx.cs" Inherits="HCA.HCAApp.AdminMeals" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%--datatables--%>
    <script type="text/javascript" src="js/datatables.min.js"></script>
    <link href="css/datatables.min.css" type="text/css" rel="stylesheet"  />
    
    <script type="text/javascript" charset="utf-8">

    //Globals
    var selAdminMeals = null;
    var selMeailId = 0;
    var selMeal = null;

    $(function () {
        loadMealGroups();
        //
        $("#selectAdminMealGroup").change(function () {
            changeAdminMealSelection($("#selectAdminMealGroup option:selected").val());
        });
        $("#selectAdminMeal").change(function () {
            debugger;
            selMeailId = $("#selectAdminMeal").val();
            selMeal = null;
            $.each(selAdminMeals, function (idx, m) {
                if (selMeailId == m.Id) {
                    selMeal = m;
                }
            });
            $("#txtSelectedAdminMeal").val(selMeal.MealDescription);
            $("#txtSelectedAdminMealPrice").val(selMeal.Price);
            $("#txtSelectedAdminMealImage").val(selMeal.Image);
        });
        
        $("#save-edit-meal")
                .button()
                .click(function () {
                    saveMeal();
                    return false;
                });
        $("#add-new-meal")
                .button()
                .click(function () {
                    selMeailId = 0;
                    saveMeal();
                    return false;
                });
        
    });

    function saveMeal() {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AdminPageWS.asmx/SaveAddMeal",
            data: "{" +
                        "id:" + selMeailId + "," +
                        "desc:'" + $("#txtSelectedAdminMeal").val() + "'," +
                        "price:" + $("#txtSelectedAdminMealPrice").val() + "," +
                        "image:'" + $("#txtSelectedAdminMealImage").val() + "'," +
                        "mealGroupId:" + $("#selectAdminMealGroup option:selected").val() +
                      "}",
            dataType: "json",
            success: function (response) {
                changeAdminMealSelection($("#selectAdminMealGroup option:selected").val());
                //here clean
                selMeailId = 0;
                selMeal = null;
                $("#txtSelectedAdminMeal").val("");
                $("#txtSelectedAdminMealPrice").val("");
                $("#txtSelectedAdminMealImage").val("");
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
                var groups = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                displayMultiselectCombos(null, 'selectAdminMealGroup', groups, false, 'MealGroupDescription');
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

    
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
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
         Image:<input type="text" id="txtSelectedAdminMealImage" />
     </div>
     <div class="col-lg-3">
         <button id="save-edit-meal" type="button" class="btn btn-primary">save</button>
         &nbsp;&nbsp;
         <button id="add-new-meal" type="button" class="btn btn-primary">add new</button>
     </div>
     
</asp:Content>