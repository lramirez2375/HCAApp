<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StudentPage.aspx.cs" Inherits="HCA.HCAApp.StudentPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" charset="utf-8">

        //Globals
        var selectedStudentId = 0;
        var selectedMeals = [];

        $(function () {
            loadMealGroups();
            loadStudentClasses();
            $("#save-meal")
                .button()
                .click(function () {
                    saveMeal();
                    return false;
                });
        });

         function saveMeal() {
             if (selectedStudentId == 0 || selectedMeals.length==0) {
                alert("You need to select a student and meals to proceed.");
            } else {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StudentPageWS.asmx/SaveMeal",
                data: '{ studentId: ' + selectedStudentId + ', meals:' + JSON.stringify(selectedMeals) + '}',
                dataType: "json",
                success: function (response) {
                    debugger;
                    $("#tdSelectedStudent").html("");
                    $("#tdSelectedMeals").html("");
                    $("#tdSelectedClass").html("");
                    selectedStudentId = 0;
                    selectedMeals = [];
                }
            });
            }
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
                    displayCombos("studentClassDropDown", "selectStudentClasses", studentClasses, "pick your class", "Class", "Id", "loadStudents");

                }
            });

        }

        function loadStudents(id,clasName) {
            $("#tdSelectedClass").html(clasName);
            debugger;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StudentPageWS.asmx/GetAllStudentsByClass",
                data: '{ classId: ' + id + '}',
                dataType: "json",
                success: function (response) {
                    debugger;
                    var students= (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                    displayCombos("studentsDropDown", "selectStudents", students, "pick your name", "Name", "Id", "selectStudent");

                }
            });

        }
        
        function selectStudent(id, studentName) {
            selectedStudentId = id;
            $("#tdSelectedStudent").html(studentName);
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
                    displayCombos("mealGroupDropDown", "selectGroupMeals", groups, "pick a meal", "MealGroupDescription", "Id", "changeMealSelection");
                    
                }
            });

        }
        
        function changeMealSelection(id, groupName) {
            $("#MealGroupName").html(groupName);
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "StudentPageWS.asmx/GetAllMealsByGroupByDate",
                data: '{ groupId: ' + id + ',date:"<%=DateTime.Now%>"}',
                dataType: "json",
                success: function (response) {
                    debugger;
                    var meals = (typeof response.d) == 'string' ? eval('(' + response.d.replace(/\/Date\((\d+)\)\//gi, "new Date($1)") + ')') : response.d;
                    displayMeals(meals);
                }
            });
        }

        function displayMeals(meals) {
            debugger;
            var strOut = "";
            var count = 3;
            $.each(meals, function (idx, m) {
                debugger;
                if (count % 3 == 0) strOut += "<div class='row'>";
                strOut += "<div class='col-lg-4 col-sm-6 text-center'>";
                strOut += "<a onclick='javascript:selectMeal(" + m.Id + ",\"" + m.MealDescription + "\");'>";
                strOut += "<img class='img-circle img-responsive img-center' src='" + m.Image + "' alt=''>";
                strOut += "<h3>" + m.MealDescription + "</h3>";
                strOut += "</a>";
                strOut += "</div>";
                if (count % 3 == 2) strOut += "</div>";
                count++;
            });
            $("#MealsContainer").html(strOut);
        }

        function selectMeal(id, mealDesc) {
            debugger;
            var prevValue = $("#tdSelectedMeals").html();
            $("#tdSelectedMeals").html(prevValue + "<p>" + mealDesc + "</p><br/>");
            selectedMeals.push(id);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Introduction Row -->
    <div class="row">
        <div class="col-lg-12">
            <h1 class="page-header">Start a meal</h1>
            <div class="dropdown" id="mealGroupDropDown"></div>
        </div>
        <div class="col-lg-4">
            <h1 class="page-header">Pick your class</h1>
            <div class="dropdown" id="studentClassDropDown"></div>
            <div id="tdSelectedClass"></div>
        </div>
        <div class="col-lg-4">
            <h1 class="page-header">Pick your name</h1>
            <div class="dropdown" id="studentsDropDown"></div>
            <div id="tdSelectedStudent"></div>
        </div>
        <div class="col-lg-4">
            <h1 class="page-header">Selected Items: </h1>
            <div id="tdSelectedMeals"></div>
            <button type="button" class="btn btn-primary" id="save-meal">next</button>
        </div>
    </div>

    <!-- Meals -->
    <div class="row">
        <div class="col-lg-12">
            <h2 class="page-header" id="MealGroupName"></h2>
        </div>
    </div>
    <div class="container" id="MealsContainer"></div>
    
</asp:Content>
