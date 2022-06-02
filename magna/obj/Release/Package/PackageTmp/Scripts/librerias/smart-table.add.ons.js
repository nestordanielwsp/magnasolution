//dependencias
//common/factories/object creator (para crear objetos desde un factory)
//labels
//notifications
//common/directives/keymap: códigos del keyboard 
//user: (para utilizar el guardado del orden y visibilidad de las columnas)

(function (angular, undefined) {

    'use strict';

    var searchTd = function (elem) {
        var maxDeep = 4;
        var i = 1;
        while (!elem.is('td') && i <= maxDeep) {
            elem = elem.parent();
            i++;
        }
        return elem;
    }

    var app = angular.module('smart-table');

    app.run(['$templateCache', function ($templateCache) {
        $templateCache.put('template/smart-table/pagination.html',
            '<div class="ui mini pagination menu"> <span class="item" > {{lbl.get("directives.mostrando","Mostrando")}} {{start}} {{lbl.get("directives.a","a")}} ' +
            '{{end}} {{lbl.get("directives.de","de")}} {{totalItemCount}} {{lbl.get("directives.registros","registros")}} </span> </div><div class="ui mini pagination menu" ng-if="numPages && pages.length >= 2">' +
            '<a class="item" ng-repeat="page in pages" ng-class="{active: page==currentPage}" href="javascript: void(0);" ng-click="selectPage(page)" >{{page}}</a>' +
            '</div>');
    }]);

    app.factory('tableConstants', function () {
        var constant = {
            comparision:
            {
                Equals: 1,
                NotEquals: 2,
                Like: 3,
                NotLike: 4,
                GreaterThan: 5,
                GreaterOrEqual: 6,
                LessThan: 7,
                LessThanOrEqual: 8,
                In: 9,
                Range:20
            },
            getComparisionId : function(name) {
                name = name.charAt(0).toUpperCase() + name.slice(1);
                return constant.comparision[name];
            }

        };
        return constant;
    });

    app.directive('uiTable', ["$compile", "$timeout", "objectCreator", "_", "labels", "server", "$q", "notification", "$document","util", "config",
    function ($compile, $timeout, objectCreator, _, labels, server, $q, notification, $document, util, config) {
        var directive = {};
        directive.require = ['uiTable', "?^exExport", "?^exPage"];

        directive.scope = {
            uiTable: '=?',
            control: '=?',
            parentCtrl: '=?',
            rootCtrl: '=?',
            type: '@?',
            onCommand: '&?',
            filter: '=?',
            exportBeginRow: "@?",
            exportBeginCol: "@?",
            exportable: "@?",
            exportRowFormatProp: '@',
            exportRowClassProp: '@',
            api: '=?',
            apiName: '@?',
            e: '=?'
            
        };

        directive.transclude = true;

        directive.link = function (scope, element, attrs, controllers, transclude) {

            //para la globalización
            labels.setLabels(scope);
            
            var exportable = scope.exportable !== "false";
            var localData = false;
            var applySorted = false;

            if (scope.filter == null) {
                scope.filter = {};
            }

            var ctrl = controllers[0];
            ctrl.mainElement = element;
            ctrl.uniqueName = attrs.uniqueName;
            ctrl.dynamicColumns = attrs.dynamicColumns != null;
            ctrl.columnOrder = 0;
            ctrl.deletedHidden = attrs.deletedHidden != null;
            ctrl.defaultRowCommand = attrs.allRowsEdition != null ? util.arrayCommand.updated : 0;

            //var ctrlParentEditor = scope.parentCtrl;

            $timeout(function () {
                ctrl.$tableElement = element.find(".st-fixed-wraper");
                if (ctrl.$tableElement.length === 0) {
                    ctrl.$tableElement = element;
                }
            }, 0);

            //inicializa la exportación
            ctrl.table.row = scope.exportBeginRow == null ? 1 : parseInt(scope.exportBeginRow);
            ctrl.table.col = scope.exportBeginCol == null ? 1 : parseInt(scope.exportBeginCol);
            ctrl.table.exportRowFormatProp = scope.exportRowFormatProp;
            ctrl.table.exportRowClassProp = scope.exportRowClassProp;

            //setea el control de exportación a excel dependiendo si existe puede ser una hoja o un excel entero
            ctrl.exportCtrl = controllers[2] == null ? controllers[1] : controllers[2];
            if (ctrl.exportCtrl != null && exportable) {
                ctrl.exportCtrl.addTable(ctrl.table);
            }

            ctrl.editOnFocus = false;
            ctrl.addMultiple = attrs.addMultiple !== "false";

            scope.summary = {
            };

            var functions = {};
            var createSummaryValues = function (item) {
                functions = {};
                scope.summary = {};
                var summaryFields = _.filter(ctrl.table.columns, function(e) {
                    return e.summary != null;
                });

                _.forIn(item, function (value, key) {
                    if (_.find(summaryFields, ["fieldName", key]) != null) {
                        if ((typeof value === 'function')) {
                            if (key.startsWith("get") && !isNaN(value())) {
                                functions[key] = true;
                                scope.summary[key] = 0;
                            }
                        } else if (!isNaN(value)) {
                            scope.summary[key] = 0;
                        }
                    }
                });
            }

            //obtiene los valores 
            ctrl.setSummaryValues = function (createProperties) {
                if (!ctrl.table.hasSummary) {
                    return;
                }
                $timeout(function () {
                    var data = scope.data;
                    if (data == null || data.length === 0) {
                        scope.summary = {};
                        return;
                    }
                    if (createProperties) {
                        createSummaryValues(data[0]);
                    } else {
                        var summaryFields = _.filter(ctrl.table.columns, function (e) {
                            return e.summary != null;
                        });
                        for (var j = 0; j < summaryFields.length; j++) {
                            scope.summary[summaryFields[j].fieldName] = 0;
                        }
                    }

                    for (var i = 0; i < data.length; i++) {
                        if (data[i].rowCommand === util.arrayCommand.deleted) {
                            continue;
                        }

                        _.forIn(data[i], function (value, key) {
                            if (scope.summary[key] == null) {
                                return;
                            }
                            var itemValue;
                            if (functions[key] == null) {
                                itemValue = value;
                            } else {
                                itemValue = value();
                            }
                            if (!isNaN(itemValue)) {
                                scope.summary[key] += itemValue;
                            }

                        });
                    }
                }, 0);
            }

            ctrl.controlRows = new RowCollection();

            if (scope.control == null) {
                scope.control = {};
            }

            if (scope.data == null) {
                scope.data = [];
            }

            var nextId = 1;
            function getNextId() {
                return nextId++;
            }

            ctrl.rowCopy = null;
            var newRow = null;

            //actualiza la información desde el servidor

            var setRowIds = function (data) {
                if (data == null || data.length === 0) {
                    return;
                }
                ctrl.rowCopy = null;


                var max = _.maxBy(data, "id")
                if (max == null)
                    nextId = 0;
                else
                    nextId = max.id + 1;
                //nextId = _.maxBy(data, "id").id + 1;


                for (var i = 0; i < data.length; i++) {
                    var row = data[i];
                    if (row.id != null && row.id !== 0) {
                        row._rowId = row.id;
                    } else {
                        row._rowId = nextId++;
                    }
                    //row.rowCommand = ctrl.defaultRowCommand;
                }
                nextId = _.maxBy(data, "_rowId")._rowId + 1;
            }

            //actualiza la información desde el servidor configurando primero el filtro con el estado de la tabla
            ctrl.refresh = function (tableState) {
                if (localData === true) {
                    return;
                }

                if (tableState == null) {
                    tableState = ctrl.stTableController.tableState();
                }

                //configura la parte de la paginación y ordenamiento
                scope.filter.pageSize = tableState.pagination.number;
                scope.filter.start = tableState.pagination.start;

                if (tableState.sort.predicate != null) {
                    scope.filter.sortCommand = tableState.sort.predicate + " " + (tableState.sort.reverse ? "desc" : "asc");
                } else {
                    scope.filter.sortCommand = "";
                }
                scope.filter.AggregationInfo = [];

                //configura las sumatorias en las tablas
                _.forIn(ctrl.table.footer[0].cells, function (value, key) {
                    if (value.summary != null) {
                        scope.filter.AggregationInfo.push(value);
                    }
                });

                // crea la funcion que será llamada ya sea al terminar la promsea o en el momento
                var refresh = function () {
                    var config = { showLoading: false }
                    ctrl.showDimmer();
                    ctrl.allRowsCreated = false;

                    var sourced = _.filter(ctrl.table.columns, function (e) {
                        return e.source != null && e.source.length > 0;
                    });

                    sourced = _.map(sourced, function (e) {
                        return e.fieldName + ":" + e.source;
                    });

                    scope.filter.sourcedColumns = sourced;

                    //si el refresh tiene un smart filter este se agrega
                    if (ctrl.stSmartFilterCtrl) {
                        scope.filter.items = ctrl.stSmartFilterCtrl.getFilterItems();
                    }
                    

                    //obtiene los datos de manera remota
                    server.getMany(ctrl.table.api, scope.filter, scope.type, config)
                        .then(function (result) {

                            scope.data = result.data;
                            ctrl.initializeTable();
                            scope.rows = scope.data;
                            
                            //si trae agregaciones las pone en el súmari
                            angular.extend(scope.summary, result.aggregations);
                            tableState.pagination.totalItemCount = result.rowCount;
                            tableState.pagination.numberOfPages = math.ceil(result.rowCount / scope.filter.pageSize);//set the number of pages so the pagination can update
                            //revisa si los datos regresados son mayores a el alto de la tabla para poner el escroll
                            if (ctrl.fixedCheckScroll != null) {
                                ctrl.fixedCheckScroll();
                            }

                            //oculta el dimmer
                            if (scope.data == null || scope.data.length === 0 || ctrl.controlRows.rows.length === 0) {
                                ctrl.lastRowCreated();
                            }

                        },
                        function () {
                            //En caso de error oculta el dimmer
                            ctrl.hideDimmer();
                        });
                };

                // si la parte de la configuración de columnas está activa entonces primero carga la configuración del servidor y después actualiza
                if (ctrl.columnVisibility.enabled === true) {
                    ctrl.columnVisibility.configLoaded.then(refresh);
                } else {
                    //en caso contrario actualiza en el momento
                    refresh();
                }
            }

            var refreshLocal = function () {
                ctrl.showDimmer();
                server.getMany(ctrl.api.filter, scope.filter, scope.type, { showLoading: false }).then(function (result) {
                    setRowIds(result.data);
                    scope.data.length = 0;
                    ctrl.controlRows.clear();
                    for (var i = 0; i < result.data.length; i++) {
                        scope.data.push(result.data[i]);
                    }

                    if (ctrl.fixedCheckScroll != null) {
                        ctrl.fixedCheckScroll();
                    }

                    if (scope.data == null || scope.data.length === 0) {
                        ctrl.hideDimmer();
                    }
                });
            }

            ctrl.refreshLocal = function (preventCheckDirty) {
                $timeout(function () {
                    //busca si los registros tienen alguna modificación
                    var dirty = _.findIndex(scope.data, function (e) {
                        return e.rowCommand > 0 || e._rowDeleted === true;
                    }) >= 0;
                    if (dirty && !preventCheckDirty) {
                        //notification.confirm(labels.get('directives.confirmRefresh', 'Existen registros modificados, si actualiza perderá los cambios, ¿desea continuar?'), refreshLocal);
                        notification.confirm(window.getLabel('rowsUploaded', 'There are modified rows, if you update the changes will be lost, do you want to continue?'), refreshLocal);
                    } else {
                        refreshLocal();
                    }
                }, 0);
            }

            ctrl.edit = function (row) {
                ctrl.onCommand('editing', row);
                if (ctrl.editorCtrl != null) {
                    ctrl.editorCtrl.edit(row)
                    .then(function (result) {
                        if (localData) {
                            var index = _.findIndex(scope.data, ["_rowId", row._rowId]);
                            angular.merge(scope.data[index], result);
                            ctrl.setSummaryValues(false);
                        } else {
                            ctrl.refresh();
                        }
                        ctrl.onCommand('edited', result);
                    });
                    return;
                }
                ctrl.rowCopy = angular.copy(row);
                newRow = false;
            }

            ctrl.modalEdit = function (row) {
                ctrl.editorCtrl.edit(row)
                    .then(function (result) {
                        if (localData) {
                            var index = _.findIndex(scope.data, ["_rowId", row._rowId]);
                            jQuery.extend(scope.data[index], result);
                        } else {
                            ctrl.refresh();
                        }
                    });
            }
            scope.isEditing = function (row) {
                return ctrl.rowCopy != null && ctrl.rowCopy._rowId === row._rowId;
            }

            //#region ediciones 
            ctrl.save = function () {
                return true;
            }

            ctrl.cancelEdit = function () {
                if (ctrl.rowCopy == null) {
                    return;
                }

                var index = _.findIndex(scope.data, ["_rowId", ctrl.rowCopy._rowId]);
                if (ctrl.rowCopy._isNew === true) {
                    ctrl.removeRow(ctrl.rowCopy);
                } else {

                    var undefinedProps = [];

                    _.forIn(scope.data[index], function (value, key) {

                        if (key !== "$$hashKey" && scope.data[index].hasOwnProperty(key)) {
                            if (ctrl.rowCopy[key] == undefined) {
                                undefinedProps.push(key);
                            }
                        }
                    });

                    for (var i = 0; i < undefinedProps.length; i++) {
                        delete scope.data[index][undefinedProps[i]];
                    }

                    jQuery.extend(scope.data[index], ctrl.rowCopy);
                    //angular.extend(scope.data[index], ctrl.rowCopy);
                }
                ctrl.rowCopy = null;
                newRow = null;

                //reseta la forma para que los nuevos campos no estén sucios
                ctrl.$form.$setUntouched();
                ctrl.$form.$setPristine();
            }

            ctrl.removeRow = function (row) {
                var index = _.findIndex(scope.data, ["_rowId", row._rowId]);
                scope.data.splice(index, 1);
                ctrl.controlRows.removeRow(row);
            }

            ctrl.add = function (newEntity, parent) {
                var entity = newEntity == null ? {} : newEntity;
                if (ctrl.editorCtrl != null) {
                    ctrl.onCommand('adding', entity);
                    ctrl.editorCtrl.new(entity)
                        .then(function(result) {
                            if (localData) {
                                result._rowId = getNextId();
                                scope.data.push(result);
                                ctrl.setSummaryValues(false);
                            } else {
                                ctrl.refresh();
                            }
                            ctrl.onCommand('added', result);
                        });
                    return;
                } else {
                    entity = ctrl.addLocalRow();
                    entity._isNew = false;
                    entity.rowCommand = util.arrayCommand.inserted;
                    if (parent != null && entity.setParent != null) {
                        entity.setParent(parent);
                    }
                }
            }

            ctrl.addLocalRow = function () {
                var entity = scope.type == null ? {} : objectCreator.create(scope.type, {});
                entity._rowId = getNextId();
                entity._isNew = true;
                if (scope.data == null) {
                    scope.data = [];
                }
                scope.data.push(entity);
                ctrl.controlRows.add(entity, scope.data.length - 1);

                $timeout(function () {
                    ctrl.controlRows.lastRowIndex = ctrl.controlRows.rows.length - 1;
                    ctrl.controlRows.lastColIndex = 0;
                    ctrl.setTdFocus();
                }, 0);

                return entity;
            }

            ctrl.localDelete = function (row) {
                ctrl.rowCopy = null;
                ctrl.removeRow(row);
                ctrl.setSummaryValues(false);
                ctrl.onCommand('deleted', row);
            }

            var rowDelete = function (row) {
                var data = ctrl.getData();
                ctrl.onCommand('delete', row);

                var entity = _.find(data, ["_rowId", row._rowId]);
                //si los eliminados solamente se ocultarán y no es un registro nuevo
                if (ctrl.deletedHidden && !entity._isNew && entity.rowCommand !== util.arrayCommand.inserted) {
                    entity.rowCommand = util.arrayCommand.deleted;
                    entity._rowDeleted = true;
                    ctrl.controlRows.removeRow(row);
                } else {
                    ctrl.removeRow(row);
                }

                ctrl.setSummaryValues(false);

                ctrl.rowCopy = null;
            }

            ctrl.delete = function (row) {

                ctrl.onCommand('deleting', row);

                if (ctrl.editorCtrl == null) {
                    if (!row._isNew) {
                        notification.confirm(window.getLabel('confirmDelete', '¿Desea eliminar el registro?'), rowDelete, [row]);
                    } else {
                        rowDelete(row);
                    }
                    return;
                }

                ctrl.editorCtrl.delete(row)
                   .then(function (result) {
                       if (localData) {
                           ctrl.localDelete(row);
                           ctrl.setSummaryValues(false);
                       } else {
                           ctrl.refresh();
                           ctrl.onCommand('deleted', row);
                       }
                   });
            }

            ctrl.getEntity = function (id) {
                return _.find(scope.data, ["_rowId", id]);
            }

            ctrl.getData = function () {
                return scope.data;
            }

            ctrl.getControl = function () {
                return scope.control;
            }

            ctrl.initializeTable = function () {
                setRowIds(scope.data);
                ctrl.controlRows.clear();
                ctrl.rowCopy = null;
            }

            ctrl.clearValidations = function () {
                //reseta la forma para que los nuevos campos no estén sucios
                ctrl.$form.$setUntouched();
                ctrl.$form.$setPristine();
                ctrl.submitted = false;
            }

            ctrl.sortableOptions = {
                update : function(ui, event) {
                    applySorted = true;
                }
            }

            //#endregion


            ctrl.showDimmer = function () {
                //todo poner la función para cuando no exista st-fixed
            }

            ctrl.showDimmer = function () {
                //todo poner la función para cuando no exista st-fixed
            }

            scope.control.add = function (entity) {
                ctrl.add(entity);
            }

            scope.control.closeEditor = function () {
                ctrl.editorCtrl.close();
            }

            scope.control.redraw = function (resetColumns) {
                var q = $q.defer();
                if (resetColumns) {
                    ctrl.resetColumns = true;
                    ctrl.table.columns = [];
                    $timeout(function () {
                        ctrl.resetColumns = false;
                        $timeout(function () {
                            ctrl.setFixedWidhts(scope.control.freezeLeft);
                            q.resolve(true);
                        }, 0);
                    }, 0);
                } else {
                    $timeout(function () {
                        ctrl.setFixedWidhts(scope.control.freezeLeft);
                        q.resolve(true);
                    }, 0);
                }
                return q.promise;
            }

            scope.control.refresh = function (preventCheckDirty) {
                if (localData) {
                    ctrl.refreshLocal(preventCheckDirty);
                } else {
                    ctrl.refresh();
                }
            }

            scope.control.refreshAndClose = function () {
                scope.control.refresh();
                scope.control.closeEditor();
            };

            scope.control.exportExcel = function () {
                //if (!ctrl.remoteData) {
                //    ctrl.table.rows = scope.datasource;
                //}
                ctrl.exportCtrl.export('Excel');
            }

            scope.control.getData = function () {
                return ctrl.getData();
            }

            scope.control.edit = function(row) {
                ctrl.edit(row);
            }

            scope.control.getModifiedData = function () {
                //si se ha aplicado ordenamiento, actualiza marca los registros con su nuevo orden
                if (applySorted === true) {
                    var order = 1;
                    for (var i = 0; i < scope.rows.length; i++) {
                        var row = scope.rows[i];
                        if (!row._rowDeleted) {
                            row.order = order++;
                        }
                        if (row.rowCommand == null || row.rowCommand === 0) {
                            row.rowCommand = util.arrayCommand.updated;
                        }
                    }
                }
                return _.filter(scope.data, function (e) {

                    //si row form está sucio (modificado) entonces actualiza y no tenía row command, entonces actualiza el registro para que sea marcado como actualizado
                    if (e.$rowform != null && e.$rowform.$dirty === true && e.rowCommand === 0) {
                        e.rowCommand = util.arrayCommand.updated;
                    }

                    //regresa modificados(incluyendo nuevos) y válidos además de elimnados
                    return ((e.rowCommand != null && e.rowCommand !== 0) && e._valid) || e._rowDeleted === true;
                });
            }

            scope.control.getInvalidData = function () {
                return _.filter(scope.data, function (e) {
                    return (e._valid === false && !e._rowDeleted) || e._isNew === true;
                });
            }

            scope.control.saveAll = function () {
                var save = function () {
                    // elimina los registros nuevos
                    scope.control.removeNewRows();
                    //obtiene los datos modificados
                    var validData = scope.control.getModifiedData();
                    //envía al servidor el guardar con los datos modificados
                    server.call(ctrl.api.saveAll, validData).then(function () {
                        scope.control.refresh(true);
                    });
                }
                $timeout(function () {
                    if (_.findIndex(scope.data, ['_valid', false]) >= 0) {
                        //notification.confirm(labels.get('directives.confirmInvalidRows', 'Existen filas inválidas estas no se guardarán, ¿desea continuar?'), save);
                        notification.confirm(window.getLabel('invalidRows', 'There are no valid rows, these will not be saved, Do yo want to save?'), save);
                    } else {
                        save();
                    }
                }, 0);
            }

            scope.control.save = function(close) {
                ctrl.editorCtrl.save(close);
            }

            scope.control.setSummaryValues = function() {
                ctrl.setSummaryValues();
            };

            //elimina las filas que están marcadas como nuevas (solo se agregaron a la tabla pero no se realizó nada sobre ellas)
            scope.control.removeNewRows = function () {

                if (!ctrl.editOnFocus) {
                    for (var i = 0; i < scope.data.length; i++) {
                        var row = scope.data[i];
                        if (row.$rowform == null) {
                            break;
                        }

                        //si row form está sucio (modificado) entonces actualiza y no tenía row command, entonces actualiza el registro para que sea marcado como actualizado
                        if (row.$rowform.$dirty === true && row.rowCommand === 0 ) {
                            row.rowCommand = util.arrayCommand.updated;
                        }

                        // si el registro no ha sido tocado y el comando era un insert entonces marca al row como _isnew para que sea eliminado
                        //ya que nada mas se agregó pero no trae nada
                        if (row.$rowform.$dirty === false && row.rowCommand === util.arrayCommand.inserted) {
                            row._isNew = true;
                        }
                    }
                }

                _.remove(scope.data, function (row) {
                    return row._isNew;
                });
            }


            if (scope.parentCtrl != null && scope.parentCtrl.addTable != null) {
                scope.parentCtrl.addTable(scope.control);
            }

            //si da click en cualquier otro lado fuera de los registros entonces guarda la fila actual
            $document.on('click.smartTable', function (elem) {
                //si existe la directiva focus edit lanza el click afuera del smart table
                if (ctrl.focusEditClick != null) {
                    ctrl.focusEditClick(elem);
                }

                //si existe la directiva navigation
                if (ctrl.navigation != null && ctrl.navigation.documentClicked != null) {
                    ctrl.navigation.documentClicked(elem);
                }
            });


            scope.$on('$destroy', function () {
                $document.off('.smartTable');
            });



            scope.$watch("uiTable",
               function (newValue, oldValue) {
                   applySorted = false;
                   if (Object.prototype.toString.call(newValue) === '[object Array]') {
                       localData = true;
                       scope.data = newValue;
                       ctrl.initializeTable();
                       ctrl.setSummaryValues(true);
                       if (ctrl.fixedCheckScroll != null) {
                           ctrl.fixedCheckScroll();
                       }
                       ctrl.table.rows = newValue;
                       ctrl.setNavigationColumns(true);
                   } else {
                       localData = false;
                       ctrl.table.api = newValue;
                   }
               }
           );

            scope.$watchCollection("uiTable",
                function (newValue, oldValue) {
                    applySorted = false;
                    if (Object.prototype.toString.call(newValue) === '[object Array]') {
                        if (ctrl.fixedCheckScroll != null) {
                            ctrl.fixedCheckScroll();
                        }
                    }
                }
            );

            scope.$watch("filter", function (newValue, oldValue) {
                ctrl.table.filter = newValue;
            });

            if (scope.apiName != null) {
                ctrl.setApiByName(scope.apiName);
            }

            scope.$watch("api", function (newValue, oldValue) {
                if (newValue != null) {
                    ctrl.setApi(newValue);
                }
            });

            transclude(scope, function (clone, scope) {
                element.append(clone);
            });

        };

        directive.controllerAs = "smartCtrl";

        directive.controller = ["$scope",
            function (scope) {

                var ctrl = this;

                ctrl.api = { inlineRemote: false };


                //inicializa las variables que serán utilizadas en los distintos plugins
                ctrl.fixed = {
                    enabled: false,
                    freezeLeft: 0
                }

                ctrl.columnVisibility = {
                    enabeld: false
                }

                ctrl.table = {
                    columns: [],
                    footer: [{ id: '0', cells: {}, IsAggregationContainer: true }],
                    filter: {},
                    headers: [],
                    api: "",
                    name: '',
                    hasSummary :false
                }

                ctrl.stTableController = null;

                //ctrl.dimmer = null;
                //////dimmer
                //ctrl.setDimmer = function (dimmer) {
                //    ctrl.dimmer = dimmer;
                //};

                ctrl.addColum = function (column) {
                    if (_.findIndex(ctrl.table.columns, ["data", column.fieldName]) < 0) {
                        ctrl.table.columns.push(column);
                        if (column.summary != null) {
                            ctrl.table.hasSummary = true;
                        }
                    }
                };

                ctrl.addEditor = function (editorCtrl, editorScope) {
                    ctrl.editorCtrl = editorCtrl;
                    editorScope.rootCtrl = scope.rootCtrl;
                    editorScope.parentCtrl = ctrl;
                    //if (scope.type == null && editorCtrl.type != null) {
                    //    scope.type = editorCtrl.type;
                    //}
                };

                ctrl.setParentControllers = function (childScope) {
                    childScope.parentCtrl = scope.parentCtrl;
                    childScope.rootCtrl = scope.rootCtrl;
                }

                ctrl.addHeader = function (header) {
                    var current = _.find(ctrl.table.headers, ["id", header.id]);
                    if (current == null) {
                        ctrl.table.headers.push(header);
                        current = header;
                    } else {
                        angular.extend(current.cells, header.cells);
                    }
                    return current;
                }

                ctrl.addFooter = function (footer) {
                    var current = _.find(ctrl.table.footer, ["id", footer.id]);
                    if (current == null) {
                        ctrl.table.footer.push(footer);
                        current = footer;
                    } else {
                        angular.extend(current.cells, footer.cells);
                    }
                    return current;
                }

                ctrl.addCellFooter = function (cellFooter) {
                    ctrl.table.footer[0].cells.push(cellFooter);
                };

                ctrl.isColVisible = function () {
                    return true;
                }

                ctrl.setNavigationColumns = function (changedOrderOrVisibility) {
                    //si la navegación es por celdas actualiza setea las columnas si no no es necesario
                    if (ctrl.cellNavigation === true && changedOrderOrVisibility === true) {
                        ctrl.controlRows.setColumns(ctrl.table.columns);
                    }
                }

                ctrl.onCommand = function (command, item) {
                    scope.control.modified = true;
                    if (scope.onCommand != null) {
                        var result = scope.onCommand({ command: command, item: item });
                        return result || true;
                    }
                    return true;
                }



                //#region apis para edición en el server
                ctrl.setApiByName = function (newValue) {
                    ctrl.api.delete = newValue + "/delete/";
                    ctrl.api.save = newValue + "/save/";
                    ctrl.api.saveAll = newValue + "/saveAll/";
                    ctrl.api.filter = newValue + "/filter/";
                    ctrl.api.inlineRemote = true;
                }

                ctrl.setApi = function (newValue) {
                    ctrl.api = newValue;
                    ctrl.api.inlineRemote = true;
                }

                //#endregion

                //en la última fila creada oculta el dimmer ya sea después de ordenar las columnas o en ese momento 
                //actualiza las columnas para navegación de la tabla
                var changedOrderOrVisibility = true;
                ctrl.lastRowCreated = function () {
                    $timeout(function () {
                        if (ctrl.columnVisibility.sortableColumns === true) {
                            ctrl.columnVisibility.setColumnOrder();
                            ctrl.hideDimmer();

                        } else {
                            ctrl.hideDimmer();
                        }
                    }, 0);
                    ctrl.setNavigationColumns(changedOrderOrVisibility);
                    ctrl.columnOrder = 0;

                    //sirve para indicar si ya todos los rows han sido creados
                    ctrl.allRowsCreated = true;
                    //para que solamente la primera vez que crea todas las columnas indique que cambió el orden o la visibilidad
                    changedOrderOrVisibility = false;
                }
            }
        ];

        return directive;
    }
    ]);

    app.directive('stNavigate', ["keyMap", "$timeout", "$q", function (keyMap, $timeout, $q) {

        return {
            require: ['^uiTable'],
            link: function (scope, element, attrs, controllers) {
                var tableCtrl = controllers[0];
                tableCtrl.grid = [];
                tableCtrl.cellNavigation = attrs.stNavigate === "cell";


                var moveScroll = function (direction) {
                    var $scrollBody = tableCtrl.$body != null ? tableCtrl.$body : elem.parent().parent().parent();
                    var $rows = $('> table > tbody > tr', $scrollBody);
                    var $tr = $rows.eq(tableCtrl.controlRows.lastRowIndex);
                    var trHeight = $tr.height();

                    var scroll = $scrollBody.scrollTop();
                    var height = $scrollBody.height();

                    var scrollTrY = $tr.position().top + (direction === "down" ? trHeight : 0) - tableCtrl.headHeight;

                    if (height < scrollTrY) {
                        $scrollBody.scrollTop(scroll + (height - trHeight));
                    }
                    if (scrollTrY < 0) {
                        $scrollBody.scrollTop(scroll - (height - trHeight));
                    }
                }

                //checa si el cursor está dentro de un control y este no está siendo editado.
                //para el caso de un textbox y si este textbox no tiene el texto seleccionado (higlighted)
                //cuando es un ui-dropdown
                //esto para que cuando el cursor esté en un texto y precione las teclas de izquierda o derecha no se mueva a la otra celda
                var isControlEditing = function (elem, key) {

                    if (elem.is('input:text')) {
                        //si es un search y está en modo búsqueda visible desactiva las teclas
                        if (elem.hasClass('prompt')) {
                            if ($(".transition", elem.parent().parent()).hasClass("visible")) {
                                return key === keyMap.arrowUp || key === keyMap.arrowDown || key === keyMap.enter || key === keyMap.arrowRight || key === keyMap.arrowLeft || key === keyMap.esc; //si está visible entonces desactiva las teclas de movimiento excepto tab.    
                            }
                            return false;
                        }

                        //si es un dropdown o searchs las teclas arrba y abajo pertenecen por lo que regresa true si cuando es alguna de estas teclas
                        if (elem.hasClass('search')) {
                            if (key === keyMap.arrowUp || key === keyMap.arrowDown)
                                return true;
                            if ($(".menu.transition", elem.parent()).hasClass("visible")) {
                                return key === keyMap.enter || key === keyMap.arrowRight || key === keyMap.arrowLeft || key === keyMap.esc; //si está visible entonces desactiva las teclas de movimiento excepto tab.
                            }
                            return false;
                        }

                        //si las teclas no son derecha o izquierda regresa false 
                        if (key !== keyMap.arrowRight && key !== keyMap.arrowLeft) {
                            return false;
                        }

                        var selectedTextLength = window.getSelection().toString().length;
                        var inputTextLength = elem.val().length;
                        return inputTextLength > 0 && selectedTextLength < inputTextLength;

                    }
                    return false;
                };

                var setSummaryValues = function() {
                    //si no es edit on focus calcula las sumatorias, si es focus on edit, dicha directiva es la que se encarga
                    if (tableCtrl.editOnFocus !== true) {
                        tableCtrl.setSummaryValues(false);
                    }
                }

                tableCtrl.navigation = {};

                tableCtrl.navigation.rowCreated = null;

                //resuelve la creación del row;
                tableCtrl.navigation.resolveRowCreated = function () {
                    if (tableCtrl.navigation.rowCreated != null) {
                        tableCtrl.navigation.rowCreated.resolve(true);
                    }
                }

                //inicializa la promesa par que sea resuleta cuando la fila haya sido creada
                //esto con el fin de esperar a que la fila se cree y después realizar la selección del td
                tableCtrl.navigation.initializeRowCreatedDefer = function () {
                    if (tableCtrl.editOnFocus === true) {
                        tableCtrl.navigation.rowCreated = $q.defer();
                    }
                }

                //al detectar un comando de navegación
                tableCtrl.navigation.keydown = function (event, sender) {

                    //checa si el evento fué fuera de la tabla si es así regresa verdadero para continuar con el evento de fuera y quita el keymap
                    if (!$(event.target).is("body") && $(event.target).closest("[ui-table]").length === 0) {
                        keyMap.setNaviationCtrl(null);
                        return true;
                    }

                    if (event.which !== keyMap.arrowUp && event.which !== keyMap.arrowDown && event.which !== keyMap.arrowLeft &&
                        event.which !== keyMap.arrowRight && event.which !== keyMap.tab && event.which !== keyMap.enter && event.which !== keyMap.esc) {
                        return true;
                    }

                    if (isControlEditing($(event.target), event.which)) {
                        return true;
                    }

                    tableCtrl.editionCanceled = false;

                    if (tableCtrl.changinPage === true) {
                        event.stopPropagation();
                        return false;
                    }

                    var direction = keyMap.getDirection(event.which);

                    if (tableCtrl.cellNavigation) {
                        if (event.which === keyMap.esc) {
                            tableCtrl.cancelEdit();
                            tableCtrl.editionCanceled = true;
                            scope.$apply();
                            tableCtrl.setTdFocus();
                            return false;
                        } else {
                            var move = tableCtrl.controlRows.moveCell(direction);
                            if (move.cellChanged === true) {
                                moveScroll(direction);
                                if (move.rowChanged === true) {
                                    if (tableCtrl.editOnFocus) {
                                        //si la tabla se edita en el focus, guarda el registro selecionado anterior
                                        //y pone en edición el nuevo registro
                                        tableCtrl.saveAndEdit(tableCtrl.controlRows.getSelected());
                                    }
                                    tableCtrl.navigation.initializeRowCreatedDefer();
                                }
                                tableCtrl.setTdFocus();
                            } else if (event.which === keyMap.enter) {
                                //si presionó enter y se agrega un nuevo registro en el último enter entonces agrega el registro, si no solo guarda la edición
                                if (tableCtrl.newRowOnLastEnter === true) {
                                    //si la forma es válida entoces guarda 
                                    if (tableCtrl.$form.$valid) {
                                        tableCtrl.add(false);
                                    } else {
                                        tableCtrl.submitted = true;
                                    }

                                } else {
                                    tableCtrl.save();
                                }
                            }

                            setSummaryValues();

                        }
                        scope.$apply();
                        return false;
                    } else {
                        if (event.which === keyMap.arrowUp || event.which === keyMap.arrowDown) {
                            var action = tableCtrl.controlRows.moveRow(direction);
                            if (action == null) {
                                return true;
                            }
                            switch (action) {
                                case "":
                                    moveScroll(direction);
                                    //tableCtrl.setSelections(null, true);
                                    break;
                                case "nextPage":
                                    break;
                                case "prevPage":
                                    break;
                            }
                            scope.$apply();
                            return false;
                        }
                    }
                    return true;
                };

                tableCtrl.navigation.setTdSelection = function (rowIndex, $td) {
                    var fieldName = $td.attr("st-cell");
                    var move = tableCtrl.controlRows.switchCellSelected(rowIndex, fieldName);
                    if (move.rowChanged === true) {
                        tableCtrl.navigation.initializeRowCreatedDefer();
                    }
                    if (move.cellChanged === true) {
                        tableCtrl.setTdFocus();
                        setSummaryValues();
                    }
                    keyMap.setNaviationCtrl(tableCtrl.navigation);
                }



                //el focus hacia el primer control dentro de un td
                var $lastInput = null;
                var setControlFocus = function ($td) {
                    var $input = $(".editfocus", $td).first();
                    if ($input.length === 0) {
                        $input = $("[ng-model]", $td).first();
                    }
                    if ($input.length > 0) {
                        if ($input.is('ui-dropdown')) {
                            $lastInput = $(".search", $input);
                            //$lastInput.focus();
                        } else if ($input.is('ui-search')) {
                            $("input", $input).focus();
                        }
                        else {
                            $input.focus();
                            $input.select();
                            $lastInput = $input;
                        }
                    }
                    else {
                        if ($lastInput != null) {
                            $lastInput.blur();
                            $lastInput = null;
                        }

                    }
                }


                //setea el hacia una celda en específico, busca si existe un input ahí para seleccionarlo
                tableCtrl.setTdFocus = function () {
                    var setFocus = function () {
                        $timeout(function () {
                            //obtiene la selda seleccionada /indice y nomber
                            var cell = tableCtrl.controlRows.getCellSelected();
                            var $rows = $("tbody >tr:nth-child(" + (cell.rowIndex + 1) + ") ", tableCtrl.mainElement);
                            //var $rows = $("[navy=" + ctrl.controlRows.lastRowIndex + "]", element);
                            var $td = $("[st-cell='" + cell.fieldName + "']", $rows);


                            $("td", tableCtrl.$tableElement).removeClass("focused");
                            $td.addClass("focused");

                            //setea el focus hacia el primer control seleccionado
                            setControlFocus($td);
                            tableCtrl.navigation.rowCreated = null;
                            keyMap.setNaviationCtrl(tableCtrl.navigation);
                        });
                    }

                    if (tableCtrl.navigation.rowCreated != null) {
                        tableCtrl.navigation.rowCreated.promise.then(setFocus);
                    } else {
                        setFocus();
                    }
                }

                tableCtrl.navigation.documentClicked = function(elem) {
                    if (keyMap.lastNavigationCtrl === tableCtrl.navigation && $(elem.target).closest("[ui-table]").length <= 0) {
                        keyMap.removeNavigationCtrl(tableCtrl.navigation);
                        //si no es edit on focus calcula las sumatorias, si es focus on edit, dicha directiva es la que se encarga
                        setSummaryValues();
                    }
                }

                scope.$on('$destroy', function () {
                    keyMap.removeNavigationCtrl(tableCtrl.navigation);
                    tableCtrl.navigation = null;
                });
            }
        };
    }]);

    app.directive('stRow', ["$compile", "$timeout", "keyMap", "$q", function ($compile, $timeout, keyMap, $q) {
        var directive = {};
        var isFrozenColumn = false;
        directive.require = ['^uiTable'];
        directive.scope = {
            row: '=stRow'
        }

        directive.link = function (scope, elem, attrs, controllers) {
            var tableCtrl = controllers[0];
            var rows = tableCtrl.controlRows;
            var rowIndex = elem.index();
            rows.add(scope.row, rowIndex);

            if (rowIndex === 0) {
                isFrozenColumn = (elem.closest(".dataTables_scroll.scroll-container").hasClass("frozen-left"));
                //si la tabla no está frezeada o es la columna está frezeada renicia el mapeo de las celdas
            }

            tableCtrl.setParentControllers(scope);

            var clicked = false;

            scope.tableCtrl = tableCtrl;

            var doubleClick = function () {
                tableCtrl.edit(scope.row);
            }

            if (tableCtrl.editOnFocus || tableCtrl.navigation != null || tableCtrl.editorCtrl != null) {
                elem.click(function(e) {
                    //console.log("stRow");
                    rowIndex = elem.index();
                    var $target = $(e.target);
                    if ($target.attr("ng-click") != null || $target.is('a') || $target.hasClass("preventClick") || $target.closest("td").hasClass("preventClick")) {
                        return true;
                    }
                    var colIndex = 0;
                    if (tableCtrl.cellNavigation) {
                        var td = searchTd($(e.target));
                        tableCtrl.navigation.setTdSelection(rowIndex, td);
                    } else {
                        var clearSelection = !e.ctrlKey;
                        if (clicked === true) {
                            clicked = false;
                            doubleClick();
                            rows.selectOne(rowIndex);
                        } else {
                            clicked = true;
                            rows.swichSelected(rowIndex, clearSelection);
                            scope.$apply();
                            $timeout(function() {
                                clicked = false;
                            }, 250);
                            //tableCtrl.setSelections(elem, clearSelection);
                        }

                        if (tableCtrl.navigation != null) {
                            if (rows.hasSelection()) {
                                //keyMap.setNaviationCtrl(tableCtrl.navigation);
                            } else {
                                keyMap.removeNavigationCtrl(tableCtrl.navigation);
                            }

                        }
                    }
                    if (tableCtrl.editOnFocus) {
                        //si la tabla se edita en el focus, guarda el registro selecionado anterior
                        //y pone en edición el nuevo registro
                        tableCtrl.saveAndEdit(tableCtrl.controlRows.getSelected());
                    }

                    scope.$apply();
                    return false;
                });
            }

            //realiza el ordenamiento de las columnas 
            if (tableCtrl.columnVisibility.enabled && !isFrozenColumn && tableCtrl.allRowsCreated === true) {
                $timeout(function () {
                    tableCtrl.columnVisibility.setOrder(elem, false);
                }, 0);
            }

            //en caso de que exista navegación resuleve que el row ha sido creado
            $timeout(function () {
                if (tableCtrl.navigation != null) {
                    tableCtrl.navigation.resolveRowCreated();
                }
            }, 0);

        };
        return directive;
    }]);

    app.directive('stRowEdit', ["$compile", "$timeout", "keyMap", "$q", function ($compile, $timeout, keyMap, $q) {
        var directive = {};
        directive.require = ['^uiTable'];
        directive.scope = {
            row: '=stRowEdit'
        }

        directive.link = function (scope, elem, attrs, controllers) {
            var tableCtrl = controllers[0];
            var rowIndex = elem.index();

            tableCtrl.rowCopy.$form = scope.row.$form;

            tableCtrl.setParentControllers(scope);

            var isFrozenColumn = (elem.closest(".dataTables_scroll.scroll-container").hasClass("frozen-left"));

            elem.click(function (e) {
                //console.log("stRowEdit");
                if (tableCtrl.cellNavigation) {
                    var td = searchTd($(e.target));
                    tableCtrl.navigation.setTdSelection(rowIndex, td);
                }
            });

            //realiza el ordenamiento de las columnas
            if (tableCtrl.columnVisibility.enabled && !isFrozenColumn) {
                $("input", elem).hide();
                $timeout(function () {
                    $("input", elem).show();
                    tableCtrl.columnVisibility.setOrder(elem, false);
                }, 0);
            }

            //en caso de que exista navegación resuleve que el row ha sido creado
            $timeout(function () {
                if (tableCtrl.navigation != null) {
                    tableCtrl.navigation.resolveRowCreated();
                }
            }, 0);

            //si es nuevo posiciona el scroll en la última fila.
            if (scope.row._isNew) {
                tableCtrl.setBottomScroll();
                //busca todos los padres que tienen scroll y checa si el elemento está dentro del rango de dicho scrol de los papás, en caso de que no, posiciona el scroll
                //de los papaás para que el elemento sea visible
                var scrollParent = elem.scrollParent();
                while (scrollParent.is('div')) {
                    var elementScroll = (elem.offset().top - scrollParent.offset().top) + elem.height();
                    if (elementScroll > scrollParent.scrollTop() + scrollParent.height()) {
                        scrollParent.scrollTop(elementScroll);
                    }
                    scrollParent = scrollParent.scrollParent();
                }
            }

            scope.$watch("form", function (newValue, oldValue) {

            });

        };
        return directive;
    }]);

    // EX-footer directiva para indicar que la fila actual va como footer
    app.directive('stFooter', function () {
        var directive = {};
        directive.require = ['stFooter', '?^uiTable'];
        directive.restrict = "A";
        directive.link = function (scope, elem, attrs, controllers) {
            var ctrl = controllers[0];
            ctrl.footer.styleName = attrs.styleName;
            ctrl.footer.id = attrs.stFooter === "" ? "0" : attrs.stFooter;
            for (var i = 1; i < controllers.length; i++) {
                if (controllers[i] != null && controllers[i].addFooter != null) {
                    ctrl.footer = controllers[i].addFooter(ctrl.footer);
                }
            }
        };

        directive.controller = [function () {
            var ctrl = this;
            ctrl.footer = {};
            ctrl.footer.cells = {};

            ctrl.addCell = function (cell) {
                ctrl.footer.cells[cell.fieldName] = cell;
            };
        }
        ];

        return directive;
    });

    //UI-uiField directiva que liga los campos a una propiedad de un objeto
    app.directive('stField', ["$timeout","tableConstants", function ($timeout,tableConstants) {
        var directive = {};
        directive.require = ['?^exHeader', '^uiTable'];
        directive.restrict = "A";
        directive.scope = {};

        var createfilter = function(column, attrs) {
            //definición de filtros
            column.filtrable = attrs.stFilter != null;

            column.searchText = attrs.searchText !== "false";

            if (!column.filtrable) {
                return;
            }

            column.stFilter = attrs.stFilter;
            column.filterTemplate = attrs.filterTemplate;
            column.attrs = attrs.filterAttrs;
            
            if (attrs.filterOp == null) {
                switch (attrs.stFilter) {
                    case "dropdown":
                        column.filterOp = "equals";
                        break;
                    case "dropdownMultiple":
                        column.filterOp = "in";
                        break;
                    case "range":
                    case "rangeDate":
                        column.filterValue = [null, null];
                        column.filterOp = "range";
                        break;
                    default:
                        column.filterOp = "Equals";
                        break;
                }
            } else {
                column.filterOp = attrs.filterOp;
            }
            column.filterTypeId = tableConstants.getComparisionId(column.filterOp);
            //termina definición de filtros

        }

        directive.link = function (scope, elem, attrs, controllers) {

            var tableCtrl = controllers[1];


            scope.stFieldColumn = {}
            scope.stFieldColumn.fieldName = attrs.stField;
            scope.stFieldColumn.visible = attrs.visible !== "false";
            scope.stFieldColumn.exportable = attrs.exportable !== "false";
            scope.stFieldColumn.width = attrs.width == null ? 100 : parseFloat(attrs.width);
            scope.stFieldColumn.sortable = attrs.sortable !== "false";
            scope.stFieldColumn.summary = attrs.summary;
            
            if (attrs.order == null) {
                scope.stFieldColumn.order = tableCtrl.columnOrder++;
            } else {
                scope.stFieldColumn.order = parseInt(attrs.order);
                tableCtrl.columnOrder = scope.stFieldColumn.order + 1;
            }

            createfilter(scope.stFieldColumn, attrs);
            
            scope.stFieldColumn.colspan = 1;
            scope.stFieldColumn.source = attrs.source;
            scope.stFieldColumn.headerText = elem.text().trim();
            scope.stFieldColumn.title = attrs.title == null ? scope.stFieldColumn.headerText : attrs.title;
            scope.stFieldColumn.value = scope.stFieldColumn.title;

            if (attrs.format != null) {
                var params = attrs.format.split(':');
                var name = params[0];
                params.splice(0, 1);
                scope.stFieldColumn.filter =
                {
                    name: name,
                    params: params
                }
            }



            //obtiene el div sobre el que está el elemento actual, para saber si está en la columna freezeada o no
            var ancestor = $(elem).closest(".dataTables_scroll");
            scope.stFieldColumn.isFrozen = ancestor.hasClass("frozen-left");

            $timeout(function () {
                //si no está activo el selector de columnas no es necesario el watch
                if (tableCtrl.columnVisibility.enabled === true) {
                    scope.$watch("stFieldColumn.visible", function (newValue, oldValue) {
                        if (newValue === oldValue) {
                            return;
                        }
                        if (newValue === false) {
                            elem.hide();
                            $("[st-cell='" + scope.stFieldColumn.fieldName + "']", tableCtrl.mainElement).hide();
                        } else {
                            elem.show();
                            $("[st-cell='" + scope.stFieldColumn.fieldName + "']", tableCtrl.mainElement).show();
                        }

                        //tableCtrl.setFixedWidhts();
                    });
                }
            }, 0);


            if (controllers != null) {
                for (var i = 0; i < controllers.length; i++) {
                    if (controllers[i] == null) {
                        continue;
                    }
                    if (controllers[i].addCell != null) {
                        controllers[i].addCell(scope.stFieldColumn);
                    }
                    if (controllers[i].addColum != null) {
                        controllers[i].addColum(scope.stFieldColumn);
                    }
                }
            }

            scope.stFieldColumn.updateValue = function () {
                scope.stFieldColumn.value = elem.text().trim();
                scope.stFieldColumn.title = scope.stFieldColumn.value;
            }


        };
        return directive;
    }]);

    //UI-uiField directiva que liga los campos a una propiedad de un objeto
    app.directive('stCell', ["$compile", function ($compile) {
        var directive = {};
        directive.require = ['^uiTable', '^?stFooter'];
        directive.restrict = "A";
        directive.link = function (scope, elem, attrs, controllers) {
            var config = {}
            config.fieldName = attrs.stCell;
            config.summary = attrs.summary;
            config.format = attrs.format;

            var tableCtrl = controllers[0];
            var footerCtl = controllers[1];

            if (footerCtl != null) {
                footerCtl.addCell(config);
                //si es una celda de summary y no tiene html personalizado entonces genera su binding al sumary
                if (elem.html().trim() === "") {
                    var span = $("<span>");
                    var value = "{{summary['" + config.fieldName + "']";
                    if (attrs.format != null) {
                        value = value + "|" + attrs.format;
                    }
                    value += "}}";
                    span.html(value);
                    $compile(span)(scope);
                    elem.append(span);
                }

                config.updateValue = function () {
                    if (config.format === "currency" || config.format === "number") {
                        config.value = parseFloat(elem.text().trim().toString().replace(/[^0-9.]+/g, '').replace(/\.{2,}/, '.'));
                    } else {
                        config.value = elem.text().trim();
                    }
                }
            } else {
                if (elem.html().trim() === "") {
                    var spanCell = $("<span>");
                    var valueCell = "{{row['" + config.fieldName + "']";
                    if (attrs.source != null) {
                        valueCell = valueCell + "|" + "sourced:'" + attrs.source + "'";
                    }
                    else if (attrs.format != null) {
                        valueCell = valueCell + "|" + attrs.format;
                    }
                    valueCell += "}}";
                    spanCell.html(valueCell);
                    $compile(spanCell)(scope);
                    elem.append(spanCell);
                }
            }

            if (tableCtrl.columnVisibility.enabled === true) {
                var col = _.find(tableCtrl.table.columns, ["fieldName", attrs.stCell]);
                if (col != null && col.visible === false) {
                    elem.hide();
                }
            }


        };
        return directive;
    }]);

    app.directive('stEdit', [
        function () {
            var directive = {};
            directive.require = ['^uiTable'];

            directive.link = function (scope, elem, attrs, controllers) {

                var tableCtrl = controllers[0];
                elem.parent().addClass("preventClick");
                elem.click(function (e) {
                    //console.log("stEdit");
                    tableCtrl.edit(scope.row);
                    //scope.$apply();
                });
            };

            return directive;
        }
    ]);

    app.directive('stDelete', [
    function () {
        var directive = {};
        directive.require = ['^uiTable'];

        directive.link = function (scope, elem, attrs, controllers) {

            var tableCtrl = controllers[0];

            elem.closest("td").addClass("preventClick");

            elem.click(function (e) {
                //console.log("stDelete");
                tableCtrl.delete(scope.row);
                scope.$apply();
            });
        };
        return directive;
    }
    ]);

    app.directive('stColVisibility', ["$timeout", "labels", "_", "user", "$q", function ($timeout, labels, _, user, $q) {
        var directive = {};
        directive.restrict = "E";
        directive.require = ['stColVisibility', '^uiTable'];
        directive.replace = true;
        directive.templateUrl = "app/common/directives/templates/ColumnVisibility.html?ver=" + config.version;
        directive.scope = {
            sortableColumns: '@?'
        };
        directive.link = function (scope, element, attr, controllers) {
            var ctrl = controllers[0];
            var tableCtrl = controllers[1];

            scope.tableCtrl = tableCtrl;
            tableCtrl.columnVisibility.sortableColumns = scope.sortableColumns != null;
            ctrl.sortableColumns = tableCtrl.columnVisibility.sortableColumns;
            scope.lbl = labels;

            var isSorted = {};
            $timeout(function () {
                element
                    .popup({
                        popup: $('.ui.popup', element).first(),
                        hoverable: true,
                        on: "click",
                        prefer: 'opposite',
                        position: 'bottom left',
                        delay: {
                            show: 200,
                            hide: 800
                        }
                    });

            }, 0);

            var saveConfiguration = function () {
                if (tableCtrl.uniqueName == null) {
                    alert("favor de configurar el attributo unique-name en el elemento ui-table para guardar el estado del control");
                    return;
                }

                var config = {
                    name: tableCtrl.uniqueName,
                    jsonData: scope.tableCtrl.table.columns
                }

                user.saveWebControlConfig(config);
            }



            //para cada columna en la tabla setea el orden de la columna
            tableCtrl.columnVisibility.setOrder = function ($tr, isHead) {
                //si no está activo el ordenamiento de columnas no hace nada
                if (!tableCtrl.columnVisibility.sortableColumns)
                    return;

                for (var i = 0; i < ctrl.columns.length; i++) {
                    var col = ctrl.columns[i];
                    if (col.visible === false) {
                        continue;
                    }
                    var selector = "[" + (isHead ? "st-field" : "st-cell") + "='" + col.fieldName + "']";
                    var element = $(selector, $tr);
                    element.appendTo($tr);
                }
            }

            //ordena las columnas dependiendo de un orden recibido
            tableCtrl.columnVisibility.setColumnOrder = function () {
                //si no está activo el ordenamiento de columnas no hace nada
                if (!tableCtrl.columnVisibility.sortableColumns)
                    return;

                var trs = $(".dataTables_scroll:not(.frozen-left) > > table > >tr", tableCtrl.mainElement);
                trs.each(function (index, tr) {
                    var $tr = $(tr);
                    var isHead = $tr.parent().is("thead");
                    tableCtrl.columnVisibility.setOrder($tr, isHead);
                });
            }


            ctrl.switchVisibiltiy = function (col, $event) {

                col.visible = !col.visible;
                saveConfiguration();

                // si la columna cambia a visible entonces checa si ya estaba ordenada si no estaba ordenada vuelve a ordenar todo
                if (col.visible && tableCtrl.columnVisibility.sortableColumns === true) {
                    if (!isSorted[col.fieldName]) {
                        $timeout(function () {
                            tableCtrl.columnVisibility.setColumnOrder();
                        }, 0);
                    }
                }
                //actualiza la variable como que si está ordenada pra que no vuelva a ordenar las columnas en caso de cambio
                isSorted[col.fieldName] = true;
                //vuelve a calcular los witdhs
                tableCtrl.setFixedWidhts();
                //actualiza el orden navegación de las celdas
                tableCtrl.setNavigationColumns(true);
                $event.stopPropagation();
            }


            //cuando se ha movido el orden de las columnas 
            ctrl.orderUpdated = function () {
                $timeout(function () {
                    for (var i = 0; i < ctrl.columns.length; i++) {
                        ctrl.columns[i].order = i + tableCtrl.fixed.freezeLeft;
                    }
                    tableCtrl.columnVisibility.setColumnOrder();
                    saveConfiguration();
                    //actualiza el orden navegación de las celdas
                    tableCtrl.setNavigationColumns(true);
                }, 0);
            }

            //actualiza los titulos de las columnas 
            $timeout(function () {
                for (var i = 0; i < scope.tableCtrl.table.columns.length; i++) {
                    scope.tableCtrl.table.columns[i].updateValue();
                }
            }, 0);

            //activa el plugin de selección de columnas visible para indicar a los otros plugins que está activo
            tableCtrl.columnVisibility.enabled = true;

            //carga la configuración desde el servidor
            var q = $q.defer();
            //crea la promsesa
            tableCtrl.columnVisibility.configLoaded = q.promise;
            //manda a llamar la funcion al servidor
            user.getWebcontrolConfig(tableCtrl.uniqueName)
                .then(function (result) {
                    //si no hay configuración guardada entonces no configura
                    if (result == null) {
                        //obtiene las columnas elegibles para mostrar u ocultar
                        ctrl.columns = _.sortBy(_.filter(scope.tableCtrl.table.columns, function (e) {
                            return !e.isFrozen;
                        }), ['order']);
                    } else {
                        var columns = result.jsonData;
                        //configura las columnas
                        for (var i = 0; i < columns.length; i++) {
                            var colSaved = columns[i];
                            var col = _.find(tableCtrl.table.columns, ["fieldName", colSaved.fieldName]);
                            if (col != null) {
                                col.visible = colSaved.visible;
                                if (tableCtrl.columnVisibility.sortableColumns) {
                                    col.order = colSaved.order;
                                }
                            }
                        }

                        //obtiene las columnas elegibles para mostrar u ocultar
                        ctrl.columns = _.sortBy(_.filter(scope.tableCtrl.table.columns, function (e) {
                            return !e.isFrozen;
                        }), ['order']);

                        tableCtrl.columnVisibility.setColumnOrder();
                        tableCtrl.setFixedWidhts();

                        tableCtrl.setNavigationColumns(true);
                    }
                    q.resolve(true);
                });


        };
        directive.controllerAs = "ctrl";
        directive.controller = [function () {

        }];
        return directive;
    }]);

    app.directive('repeatDone', function () {
        return function (scope, element, attrs) {
            //element.bind('$destroy', function (event) {
            if (scope.$last) {
                scope.$eval(attrs.repeatDone);
            }
            //});
        }
    });
})(angular);
