
// Contacts Module
var Contacts = angular.module("Contact", ["ListView", "Filter", "Anim", "ContactField", "ContactType"]);

// Contacts configuration section ---------------------------
Contacts.config(["$routeProvider", function($routeProvider){

    // Add any route you need here
    $routeProvider.
        when("/contacts", {
            templateUrl: template("contact/index"),
            controller: "ContactController"
        }).
        when("/contacts/new",{
            templateUrl: template("contact/new"),
            controller: "AddContactController"
        }).
        when("/contacts/:id/edit",{
            templateUrl: template("contact/new"),
            controller: "AddContactController"
        });

}]);

// Contact index controller -------------------------------------------------------
// This controller is responsible for list page (index)
Contacts.controller("ContactController", ["$scope", "gettext", "Restangular", "catch_error", "$location",
                                      function($scope, gettext, API, catch_error, $location){

    $scope.filter_config = {
        list: API.all("contacts")
    };
    $scope.contacts = [];
    // Cache object for each field name possible values
    $scope.cache = {};

    // Change event handler for field_name combobox in bulk edit
    $scope.field_name_change = function(x){
        var current_value = $("#field_name").val();
        $scope.current_field= _.find($scope.fields, function(x){
            return x.name == current_value;
        });
        if( "to" in $scope.current_field ){
            if (! ($scope.current_field.name in $scope.cache)) {
                $scope.current_field.to().then(function(x){
                    $scope.cache[$scope.current_field.name] = x;
                });
            }
        }
    };

    $scope.columns = [
        {field:'prefix', displayName: gettext('Prefix')},
        {field:'first_name', displayName: gettext('First name')},
        {field:'middle_name', displayName: gettext('Middle name')},
        {field:'last_name', displayName: gettext('Last name')},
        {field:'suffix', displayName: gettext('Suffix')},
        {field:'organization', displayName: gettext('Organization')},
        {field:'is_organization', displayName: gettext('Is organization')}
    ];
    $scope.fields = [
        {
            name: "organization",
            title: gettext("Organization"),
            type: "string"
        },
        {
            name: "is_organization",
            title: gettext("Is organization"),
            type: "boolean"
        }
    ];

    // details_template is the address of template which should load for
    // each item details section
    $scope.details_template = template("contact/details");

    // Buttons for top of the list-view
    $scope.buttons = [
        {
            title: gettext("New"),
            icon: "fa fa-plus",
            classes: "btn tiny green",
            route: "#contacts/new"

        },
        {
            title: gettext("Bulk Edit"),
            icon: "fa fa-edit",
            classes: "btn tiny yellow",
            action: function(){
                $scope.$apply("bulk_edit = ! bulk_edit");
            }

        },
        {
            title: gettext("Duplicate"),
            icon: "fa fa-files-o",
            classes: "btn tiny red",
            action: function(){
                var selected = _.find($scope.contacts, function(x){
                    return x.is_selected === true;
                });

                if (selected === undefined ) {
                    error_message(gettext("You should only select one item to copy."));
                }
                else {
                    $location.path("/contacts/-" + selected.id + "/edit");
                }
            }
        }

    ];

    /*
     * On bulk save event
     */
    $scope.bulk_save = function(){

        $scope.view_progressbar = true;
        var value = $("#field_value").val();
        var field = $scope.current_field.name;
        var type = $scope.current_field.type;
        var field_name = $scope.current_field.title;
        if ((type == "has_many") || (type == "belongs_to")) {
            value = parseInt(value, 10);
        }
        var requests_count = 0;

        $scope.rfiller = 0;
        $scope.sfiller = 0;
        $scope.success = 0;
        $scope.failed = 0;
        $scope.total = _.where($scope.contacts, function(x){return x.is_selected === true;}).length;

        _.each($scope.contacts, function(x){
            if( x.is_selected === true ){
                x[field] = value;
                requests_count++;

                var rwidth = (requests_count * 100) / $scope.total;
                if (requests_count == $scope.total) { rwidth = 100; }
                $scope.rfiller = rwidth + "%";

                API.one("contacts", x.id).patch(x).then(function(data){
                    $scope.success++;
                    var swidth = parseInt(($scope.success * 100) / $scope.total);
                    if ($scope.sucess == $scope.total) { swidth = 100; }
                    $scope.sfiller = swidth + "%";
                    x[field_name.toLowerCase()] = data[field_name.toLowerCase()];
                }, function(data){
                    $scope.failed++;
                    catch_error(data);
                });

            }
        });

    };

    /*
     * On bulk cancel event
     */
    $scope.bulk_cancel = function(){
        $("#field_name").val(0);
        document.getElementById("bulk_form").reset();
        $scope.view_progressbar = false;
        $scope.bulk_edit = false;
    };

    /*
     * On delete event handler - `items` is an array of objects to delete
     */
    $scope.on_delete = function(items){

        var query = [];
        items.forEach(function(item){
            query.push(item.id);
        });

        API.all("contacts").customDELETE(query.join(","))
            .then(function(data) {

                $scope.contacts = _.filter($scope.contacts, function(x){
                    return !(query.indexOf(x.id) != -1);
                });
                success_message(data.msg);
            }, function(data){
                catch_error(data);
            });

    };
    /*
    API.all("contacts").getList()
        .then(function(data){
            $scope.contacts = data;
        }, function(data){
            catch_error(data);
        });
     */
    $scope.full_name = function(value) {
        if (! value.is_organization) {
            var res =  value.prefix || "";
            res = res + " " + value.first_name + " ";
            if (value.middle_name){
                res = res + value.middle_name;
            }
            res = res + " " + value.last_name;
            if (value.suffix) {
                res = res + " " + value.suffix;
            }
            return res;
        }
        else {
            return value.organization;
        }
    };

}]);

Contacts.controller("AddContactController", ["Restangular", "$scope", "$location", "$routeParams", "gettext", "catch_error", function(API, $scope, $location, $routeParams, gettext, catch_error){

    $scope.select2options = {};

    // Details vars
    $scope.details_count = [0];
    $scope.details = [{}];
    API.all("contact_fields").getList().then(function(data){
        $scope.detail_fields = data;
    }, function(data) {
        catch_error(data);
    });

    API.all("contact_types").getList().then(function(data){
    $scope.detail_types = data;
    }, function(data) {
        catch_error(data);
    });
    // ---

    $scope.editing = false;
    $scope.current_tab = 1;
    $scope.activate_tab = function(tab, $event){
        $scope.current_tab = tab;
    };
    $scope.obj_id = null;
    var is_copy = false;

    if( "id" in $routeParams ){
        $scope.obj_id = $routeParams.id;
        $scope.editing = true;
        if ($scope.obj_id < 0) {
            is_copy = true;
            $scope.obj_id = $scope.obj_id * -1;
        }

        var obj = API.one("contacts", $scope.obj_id).get()
                .then(function(data) {

                    $scope.prefix = data.prefix;
                    $scope.first_name = data.first_name;
                    $scope.middle_name = data.middle_name;
                    $scope.last_name = data.last_name;
                    $scope.suffix = data.suffix;
                    $scope.organization = data.organization;
                    $scope.is_organization = data.is_organization;
                    $scope.details = data.details;
                    $scope.details_count = [];
                    for(i = 0; i < data.details.length; i++){
                        $scope.details_count.push(i);
                    }
                }, function(data){
                    catch_error(data);
                });

    }


    $scope.add_another_row = function(){
        var last = _.last($scope.details_count);
        if (last === undefined) {
            last = -1;
        }
        $scope.details_count.push(last + 1);
        $scope.details.push({});
    };

    $scope.remove_row = function(){
        $scope.details_count.pop();
        var lastobj = $scope.details.pop();
        if ("id" in lastobj) {
            API.all("contact_details").customDELETE(lastobj.id)
            .then(function(data) {
                success_message(data.msg);
            }, function(data){
                catch_error(data);
            });
        }
    };

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
        $location.path("contacts");
    };

    $scope.save = function(save_another){
        $("small.error").html("");
        $("small.error").removeClass("error");

        var contact = {contact: {
            prefix: $scope.prefix,
            first_name: $scope.first_name,
            middle_name: $scope.middle_name,
            last_name: $scope.last_name,
            suffix: $scope.suffix,
            organization: $scope.organization,
            is_organization: $scope.is_organization,
            details: $scope.details,
            __res__: 0
        }};
        if (($scope.obj_id) && (is_copy === false)) {

            API.one("contacts", $scope.obj_id).patch(contact)
                .then(function(){
                    success_message(gettext("Contact updated successfully."));
                    if (save_another) {
                        $(".form input").val("");
                    }
                    else {
                        $location.path("contacts");
                    }
                }, function(data){
                    catch_error(data);
                });

        }
        else {
            API.all("contacts").customPOST(contact, "").then(function(){
                success_message(gettext("Contact created successfully."));
                if (save_another) {
                    $(".form input").val("");
                }
                else {
                    $location.path("contacts");
                }
            }, function(data){
                catch_error(data);
            });
        }

    };
}]);

Contacts.controller("ContactMenuController", ["gettext", function(gettext){
    this.menu_items = [
        {title: gettext("Contacts"), url: "/contacts"},
        {title: gettext("Contact Fields"), url: "/contact_fields"},
        {title: gettext("Contact Types"), url: "/contact_types"}
    ];
}]);
