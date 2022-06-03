
window.config = {IdVariable : "Id"}



(function () {
    var app = angular.module("customDirectives");


   

    app.directive('uiCheckboxTree', ["$timeout", "$injector", function ($timeout, $injector) {
        var directive = {};

        function TreeNode(entity) {
            var self = this;

            self.Children = [];
            self.Item = {};

            var parent = null;

            if (entity !== null) {
                angular.extend(this, entity);
            }

            if (self.allowChilds == null) {
                self.allowChilds = function () {
                    return true;
                }
            }

            self.Item.allowChilds = function () {
                return self.allowChilds();
            }

            self.hasChilds = function () {
                return _.some(self.Children, function (e) {
                    return e.Item.rowCommand !== 3; // todo util.arrayCommand.deleted;
                });
            }

            self.setParent = function (newParent) {
                parent = newParent;
            }

            self.getParent = function () {
                return parent;
            }

            var state = null;
            self.setState = function (value) {
                state = value;
            }
            self.getState = function () {
                return state;
            }
        }

        //directive.templateUrl = "app/common/directives/tree/uiEditableTree.html?ver=" + config.version;
        //$templateCache.get("common/tree/uiEditableTree.html"); //"app/modules/common/tree/uiTree.html?ver1.8";
        directive.restrict = "E";

        directive.require = ['uiCheckboxTree', 'ngModel'];


        directive.scope = {
            source: '@',
            type: '@?',
            title: '@',
            filter: '=?',
            plainDatasource: '=',
        };

        directive.templateUrl = function (elem, attrs) {
            var version = Math.floor(Date.now() / 1000);
            return (attrs.templateUrl || "../Scripts/configuracion/checkBoxTree.html") + "?ver=" + version;
        }

        directive.link = function (scope, element, attrs, controllers) {
            var ctrl = controllers[0];
            var modelController = controllers[1];

            var ids = [];


           
            var setModelValue = function () {
                var values = [];
                for (var i = 0; i < ids.length; i++) {
                    values.push(ids[i]);
                }
                modelController.$setViewValue(values);

            }


            scope.dragEnabled = false;

            scope.treeOptions = {
            };

            if (scope.filter == null) {
                scope.filter = {};
            }

       
            scope.collapseAll = function () {
                scope.$broadcast('angular-ui-tree:collapse-all');
            };

            scope.expandAll = function () {
                scope.$broadcast('angular-ui-tree:expand-all');
            };

            scope.toggle = function (scopeNode) {
                scopeNode.toggle();
            };

            var toggleChildren = function (items, checked) {
                for (var i = 0; i < items.length; i++) {
                    items[i].ticked = checked;
                    scope.toogleCheckBox(items[i]);
                }
            }
       
            var addOrRemoveIdItem = function (id, ticked, index) {
                if (ticked && index < 0) {
                    ids.push(id);
                }
                if (!ticked && index >= 0) {
                    ids.splice(index, 1);
                }
            }

            //revisa para sus hijos si estan seleccionados o no
            var toogleParent = function (node) {
                var tickCount = 0;
                node.indeterminate = false;
                for (var i = 0; i < node.Children.length; i++) {
                    if (node.Children[i].ticked) {
                        tickCount++;
                    }
                }

                var index = ids.indexOf(node.Item[window.config.IdVariable]);
                addOrRemoveIdItem(node.Item.Id, tickCount !== 0, index);

                if (tickCount < node.Children.length) {
                    node.ticked = false;
                }

                if (tickCount === node.Children.length) {
                    node.ticked = true;
                } else if (tickCount > 0) {
                    node.indeterminate = true;
                }

                var parent = node.getParent();
                if (parent != null) {
                    toogleParent(parent);
                }

            }

            scope.toogleCheckBox = function (node, fromFormater) {
                var item = node.Item;
                var index = ids.indexOf(item[window.config.IdVariable]);

                addOrRemoveIdItem(item.Id, node.ticked, index);

                toggleChildren(node.Children, node.ticked);

                var parent = node.getParent();
                if (parent != null) {
                    toogleParent(parent);
                }

                if (!fromFormater) {
                    setModelValue();
                }
            };



         
            scope.root = new TreeNode();

            scope.$watch("source", function (newValue, oldValue) {
                if (newValue != null) {
                    ctrl.loadData();
                }
            });

            scope.$watch("filter", function (newValue, oldValue) {
                if (newValue != null && scope.source != null) {
                    ctrl.loadData();
                }
            });

            var childrens = [];

            var generateTree = function (data, parentId, level, parent) {
                var result = [];
                var items = _.where(data, {"ParentId": parentId});
                for (var i = 0; i < items.length; i++) {
                    var item = new TreeNode({ Item: items[i], Level: level });
                    item.setParent(parent);
                    item.Children = generateTree(data, items[i].Id, level + 1, item);
                    result.push(item);
                    if (item.Children.length === 0) {
                        childrens.push(item);
                    }
                }
                return result;
            }

            var setTicks = function () {
                for (var i = 0; i < childrens.length; i++) {
                    var node = childrens[i];
                    node.ticked = ids.indexOf(node.Item.Id) >= 0;
                    var parent = node.getParent();
                    if (parent != null) {
                        toogleParent(parent);
                    }
                }
            }

            scope.$watch("plainDatasource", function (newValue, oldValue) {
                childrens = [];
                if (newValue != null) {
                    scope.root.Item = { name: 'Root' }
                    scope.root.Children = generateTree(newValue, 0, 0);
                    setTicks();
                    $timeout(function () {
                        scope.$broadcast('angular-ui-tree:collapse-all');
                    }, 0);
                }
            });



            //cuando cambia el modelo setea los valores
            modelController.$formatters.push(function (modelValue) {
                ids.length = 0;
                if (modelValue != null) {
                    for (var i = 0; i < modelValue.length; i++) {
                        ids.push(modelValue[i]);
                    }
                    setTicks();
                }
                return modelValue;
            });




        };

        directive.controller = [ "$scope", function (scope) {
            var ctrl = this;

        }];

        return directive;
    }]);

})();


