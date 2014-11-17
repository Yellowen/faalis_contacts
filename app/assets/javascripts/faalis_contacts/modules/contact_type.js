
// ContactTypes Module
var ContactTypes = angular.module("ContactType", ["ListView", "Filter", "Anim"]);

// ContactTypes configuration section ---------------------------
ContactTypes.config(["$routeProvider", function($routeProvider){

    // Add any route you need here
    $routeProvider.
        when("/contact_types", {
            templateUrl: template("contact_type/index"),
            controller: "ContactTypeController"
        }).
        when("/contact_types/new",{
            templateUrl: template("contact_type/new"),
            controller: "AddContactTypeController"
        }).
        when("/contact_types/:id/edit",{
            templateUrl: template("contact_type/new"),
            controller: "AddContactTypeController"
        });

}]);

// ContactType index controller -------------------------------------------------------
// This controller is responsible for list page (index)
ContactTypes.controller("ContactTypeController", ["$scope", "gettext", "Restangular", "catch_error", "$location",
                                      function($scope, gettext, API, catch_error, $location){

    $scope.filter_config = {
        list: API.all("contact_types")
    };
    $scope.contact_types = [];


    // details_template is the address of template which should load for
    // each item details section
    $scope.details_template = template("contact_type/details");

    // Buttons for top of the list-view
    $scope.buttons = [
        {
            title: gettext("New"),
            icon: "fa fa-plus",
            classes: "btn btn-success",
            route: "#contact_types/new"

        },
        {
            title: gettext("Duplicate"),
            icon: "fa fa-files-o",
            classes: "btn btn-warning",
            action: function(){
                var selected = _.find($scope.contact_types, function(x){
                    return x.is_selected === true;
                });

                if (selected === undefined ) {
                    error_message(gettext("You should only select one item to copy."));
                }
                else {
                    $location.path("/contact_types/-" + selected.id + "/edit");
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

        API.all("contact_types").customDELETE(query.join(","))
            .then(function(data) {

                $scope.contact_types = _.filter($scope.contact_types, function(x){
                    return !(query.indexOf(x.id) != -1);
                });
                success_message(data.msg);
            }, function(data){
                catch_error(data);
            });

    };
    /*
    API.all("contact_types").getList()
        .then(function(data){
            $scope.contact_types = data;
        }, function(data){
            catch_error(data);
        });
     */
}]);

ContactTypes.controller("AddContactTypeController", ["Restangular", "$scope", "$location", "$routeParams", "gettext", "catch_error", function(API, $scope, $location, $routeParams, gettext, catch_error){

    $scope.select2options = {};
    $scope.editing = false;
    $scope.obj_id = null;
    var is_copy = false;



    if( "id" in $routeParams ){
        $scope.obj_id = $routeParams.id;
        $scope.editing = true;
        if ($scope.obj_id < 0) {
            is_copy = true;
            $scope.obj_id = $scope.obj_id * -1;
        }

        var obj = API.one("contact_types", $scope.obj_id).get()
                .then(function(data) {

                    $scope.name = data.name;
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
        $location.path("contact_types");
    };

    $scope.save = function(save_another){
        var contact_type = {contact_type: {
            name: $scope.name,
            __res__: 0
        }};
        if (($scope.obj_id) && (is_copy === false)) {

            API.one("contact_types", $scope.obj_id).patch(contact_type)
                .then(function(){
                    success_message(gettext("ContactType updated successfully."));
                    if (save_another) {
                        $(".form input").val("");
                    }
                    else {
                        $location.path("contact_types");
                    }
                }, function(data){
                    catch_error(data);
                });

        }
        else {
            API.all("contact_types").customPOST(contact_type, "").then(function(){
                success_message(gettext("ContactType created successfully."));
                if (save_another) {
                    $(".form input").val("");
                }
                else {
                    $location.path("contact_types");
                }
            }, function(data){
                catch_error(data);
            });
        }

    };
}]);
