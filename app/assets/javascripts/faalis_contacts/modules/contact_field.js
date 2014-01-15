
// ContactFields Module
var ContactFields = angular.module("ContactField", ["ListView", "Filter", "Anim"]);

// ContactFields configuration section ---------------------------
ContactFields.config(["$routeProvider", function($routeProvider){

    // Add any route you need here
    $routeProvider.
        when("/contact_fields", {
            templateUrl: template("contact_field/index"),
            controller: "ContactFieldController"
        }).
        when("/contact_fields/new",{
            templateUrl: template("contact_field/new"),
            controller: "AddContactFieldController"
        }).
        when("/contact_fields/:id/edit",{
            templateUrl: template("contact_field/new"),
            controller: "AddContactFieldController"
        });

}]);

// ContactField index controller -------------------------------------------------------
// This controller is responsible for list page (index)
ContactFields.controller("ContactFieldController", ["$scope", "gettext", "Restangular", "catch_error", "$location",
                                      function($scope, gettext, API, catch_error, $location){

    $scope.filter_config = {
        list: API.all("contact_fields")
    };
    $scope.contact_fields = [];
    

    // details_template is the address of template which should load for
    // each item details section
    $scope.details_template = template("contact_field/details");

    // Buttons for top of the list-view
    $scope.buttons = [
        {
            title: gettext("New"),
            icon: "fa fa-plus",
            classes: "btn tiny green",
            route: "#contact_fields/new"

        },
        {
            title: gettext("Duplicate"),
            icon: "fa fa-files-o",
            classes: "btn tiny red",
            action: function(){
                var selected = _.find($scope.contact_fields, function(x){
                    return x.is_selected === true;
                });

                if (selected === undefined ) {
                    error_message(gettext("You should only select one item to copy."));
                }
                else {
                    $location.path("/contact_fields/-" + selected.id + "/edit");
                }
            }
        }

    ];
    /*
     * On delete event handler - `items` is an array of objects to delete
     */
    $scope.on_delete = function(items){

        var query = [];
        items.forEach(function(item){
            query.push(item.id);
        });

        API.all("contact_fields").customDELETE(query.join(","))
            .then(function(data) {

                $scope.contact_fields = _.filter($scope.contact_fields, function(x){
                    return !(query.indexOf(x.id) != -1);
                });
                success_message(data.msg);
            }, function(data){
                catch_error(data);
            });

    };
    /*
    API.all("contact_fields").getList()
        .then(function(data){
            $scope.contact_fields = data;
        }, function(data){
            catch_error(data);
        });
     */
}]);

ContactFields.controller("AddContactFieldController", ["Restangular", "$scope", "$location", "$routeParams", "gettext", "catch_error", function(API, $scope, $location, $routeParams, gettext, catch_error){

    $scope.select2options = {};
    $scope.editing = false;
    $scope.obj_id = null;
    var is_copy = false;

    
    $scope.value_type_choices = _.sortBy([
        {name: "string", title: "String"},
        {name: "numeric", title: "Numeric"},
        {name: "email", title: "Email"},
    ], "title");
    if( "id" in $routeParams ){
        $scope.obj_id = $routeParams.id;
        $scope.editing = true;
        if ($scope.obj_id < 0) {
            is_copy = true;
            $scope.obj_id = $scope.obj_id * -1;
        }

        var obj = API.one("contact_fields", $scope.obj_id).get()
                .then(function(data) {
                
                    $scope.name = data.name;
                    $scope.value_type = data.value_type;
                    $scope.validation_rules = data.validation_rules;
                }, function(data){
                    catch_error(data);
                });

    }


    $scope.have = function(field, obj_id) {
        var tmp = _.where($scope[field], {id: obj_id});
        if (tmp.length > 0) {
            return true;
        }
        else {
            return false;
        }
    };

    $scope.cancel = function(){
        $(".form input").val("");
        $location.path("contact_fields");
    };

    $scope.save = function(save_another){
        var contact_field = {contact_field: {
            name: $scope.name,
            value_type: $scope.value_type,
            validation_rules: $scope.validation_rules,
            __res__: 0
        }};
        if (($scope.obj_id) && (is_copy === false)) {

            API.one("contact_fields", $scope.obj_id).patch(contact_field)
                .then(function(){
                    success_message(gettext("ContactField updated successfully."));
                    if (save_another) {
                        $(".form input").val("");
                    }
                    else {
                        $location.path("contact_fields");
                    }
                }, function(data){
                    catch_error(data);
                });

        }
        else {
            API.all("contact_fields").customPOST(contact_field, "").then(function(){
                success_message(gettext("ContactField created successfully."));
                if (save_another) {
                    $(".form input").val("");
                }
                else {
                    $location.path("contact_fields");
                }
            }, function(data){
                catch_error(data);
            });
        }

    };
}]);

